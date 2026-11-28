import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cabo/components/statistics/screens/public_game_screen.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/domain/game/public_game_service.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round_scorer.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/domain/rule_set/rules_service.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> with LoggerMixin {
  StatisticsCubit({
    required List<Player> players,
    Game? game,
    FirebaseAuth? auth,
  }) : _authOverride = auth,
       _initialPlayerOrder = players
           .map((Player player) => player.name)
           .toList(),
       super(StatisticsState(players: players)) {
    loadGame(game: game);
  }

  // Seating order of the players, captured before any placement sorting.
  final List<String> _initialPlayerOrder;
  final FirebaseAuth? _authOverride;
  FirebaseAuth get _auth => _authOverride ?? FirebaseAuth.instance;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _gameSubscription;

  void loadGame({Game? game}) {
    final DateTime startingDateTime = game?.startedAt?.isNotEmpty ?? false
        ? DateFormat('dd-MM-yyyy HH:mm').parse(game!.startedAt!)
        : DateTime.now();
    if (game == null) {
      unawaited(_createLocalGame(startingDateTime));
    } else {
      _startGame(game);
    }

    if ((game?.isPublic ?? false) && _auth.currentUser != null) {
      unawaited(_subscribePublicGame());
    }
  }

  Future<void> _createLocalGame(DateTime startedAt) async {
    final RuleSet ruleSet = await _loadRuleSet();

    final Game game = Game(
      startedAt: DateFormat('dd-MM-yyyy HH:mm').format(startedAt),
      players: state.players,
      ruleSet: ruleSet,
      seatingOrder: _initialPlayerOrder,
    );

    final Game currentGame =
        await app<GameService>().saveLastPlayedGame(game) ?? game;

    _startGame(currentGame);
  }

  void _startGame(Game game) {
    emit(state.copyWith(game: _withSeatingOrder(game)));
  }

  // Games saved before the seating order existed adopt their current player
  // order once, so the dealer rotation stays stable from then on.
  Game _withSeatingOrder(Game game) {
    if (game.seatingOrder.isNotEmpty) {
      return game;
    }
    return game.copyWith(
      seatingOrder: game.players.map((Player player) => player.name).toList(),
    );
  }

  Future<RuleSet> _loadRuleSet() {
    return app<RuleService>().loadRuleSet();
  }

  // Already played rounds keep the scoring they were closed with.
  Future<void> reloadRuleSet() async {
    final Game? game = state.game;
    if (game == null) {
      return;
    }

    final RuleSet ruleSet = await _loadRuleSet();
    if (ruleSet == game.ruleSet) {
      return;
    }

    final Game updatedGame = game.copyWith(ruleSet: ruleSet);
    emit(state.copyWith(game: updatedGame));

    await _saveGame(updatedGame);

    if (updatedGame.isGameFinished) {
      _finishGame(updatedGame.players);
    }
  }

  void closeRound({int? index}) {
    unawaited(_closeOfflineRound(index));
  }

  // Forces the game to finish for the owner (or a local game). For public
  // games, non-owners simply leave locally: no Firestore write happens and the
  // game stays live for the remaining players.
  Future<void> onPopScreen() async {
    if (state.game?.isGameFinished ?? false) {
      return;
    }

    await _saveGame(state.game!, shouldForceFinish: true);
  }

  void showPublicGameDialog() {
    unawaited(
      app<NavigationService>().pushFullscreenDialog<void>(
        PublicGameScreen(
          publishGame: _publishGame,
          gameId: state.game?.publicId,
          game: state.game,
        ),
      ),
    );
  }

  Future<Game?> _publishGame() async {
    final Game publicGame = await app<PublicGameService>().saveOrUpdateGame(
      game: state.game!,
    );

    // Persist publicId/ownerId locally right away, otherwise the subscription
    // is lost on app restart if no round has been closed until then.
    await app<GameService>().saveLastPlayedGame(publicGame);

    emit(state.copyWith(game: publicGame));

    unawaited(_subscribePublicGame());

    return publicGame;
  }

  Future<void> _subscribePublicGame() async {
    await _gameSubscription?.cancel();
    _gameSubscription = app<PublicGameService>()
        .subscribeToGame(state.game!.publicId!)
        .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
          if (!snapshot.exists) {
            return;
          }

          // Own local writes must not be handled as remote updates,
          // otherwise they cause a double emit and UI flicker.
          if (snapshot.metadata.hasPendingWrites) {
            return;
          }

          final Game gameData = Game.fromJson(snapshot.data()!);
          logger.info('Game was updated');

          if (state.game == gameData) {
            return;
          }

          emit(
            state.copyWith(
              game: gameData.copyWith(publicId: snapshot.id),
              players: gameData.players,
            ),
          );

          if (gameData.isGameFinished && gameData.players.isNotEmpty) {
            _finishGame(gameData.players);
          }
        });
  }

  @override
  Future<void> close() {
    unawaited(_gameSubscription?.cancel());
    return super.close();
  }

  Future<void> _closeOfflineRound(int? index) async {
    if (state.players.isEmpty) {
      return;
    }

    final RuleSet ruleSet = state.game?.ruleSet ?? const RuleSet();
    final List<Player> players = List<Player>.from(state.players);

    final Player? closingPlayer = await app<StatisticsDialogService>()
        .showRoundCloserDialog(players: players);

    if (closingPlayer == null) {
      return;
    }

    final Map<String, int?>? playerPointsMap =
        await app<StatisticsDialogService>().showPointDialog(
          state.players,
          closer: closingPlayer,
        );

    if (playerPointsMap != null) {
      final RoundScorer scorer = RoundScorer(
        ruleSet: ruleSet,
        playerPoints: playerPointsMap,
        closingPlayerName: closingPlayer.name,
      );
      for (int i = 0; i < players.length; i++) {
        players[i] = scorer.applyRound(players[i], index: index);
      }
    }

    _updatePlayers(_rankByPoints(players));
  }

  List<Player> _rankByPoints(List<Player> players) {
    players.sort(
      (Player a, Player b) => a.totalPoints.compareTo(b.totalPoints),
    );

    for (int i = 0; i < players.length; i++) {
      players[i] = players[i].copyWith(place: i + 1);
    }
    return players;
  }

  void _updatePlayers(List<Player> players) {
    final Game updatedGame = state.game!.copyWith(players: players);
    emit(state.copyWith(players: players, game: updatedGame));

    unawaited(_saveGame(updatedGame));

    if (updatedGame.isGameFinished) {
      _finishGame(players);
    }
  }

  void _finishGame(List<Player> players) {
    final Player? winner = players
        .where((Player player) => player.place == 1)
        .firstOrNull;
    if (winner == null) {
      logger.warning('_finishGame called without a winner candidate');
      return;
    }

    app<NavigationService>().pushToEndGameScreen(game: state.game!);
  }

  Future<void> _saveGame(Game game, {bool shouldForceFinish = false}) async {
    // A non-owner must not end a public game early for everyone. The player
    // only leaves locally: no Firestore or history write.
    if (shouldForceFinish && game.isPublic && !_isOwnerOf(game)) {
      return;
    }

    // A published game without a single round was only tried out. It is
    // removed from Firestore instead of staying there as a finished game.
    final bool isAbandonedPublicGame =
        shouldForceFinish && game.isPublic && !game.hasRounds;

    if (isAbandonedPublicGame) {
      await _discardPublicGame(game);
    }

    Game gameToSave = game;
    if (game.isGameFinished || shouldForceFinish) {
      gameToSave = await _archiveFinishedGame(game);
    }

    if (gameToSave.isPublic && !isAbandonedPublicGame) {
      try {
        await app<PublicGameService>().saveOrUpdateGame(game: gameToSave);
      } on Exception catch (e, stackTrace) {
        logger.severe('Failed to sync public game to Firestore', e, stackTrace);
      }
    }

    await app<GameService>().saveLastPlayedGame(gameToSave);
  }

  Future<Game> _archiveFinishedGame(Game game) async {
    final String finishedAt = DateFormat(
      'dd-MM-yyyy HH:mm',
    ).format(DateTime.now());
    final Game finishedGame = game.copyWith(finishedAt: finishedAt);
    // Update the state right away so isGameFinished is true and the
    // EndGameScreen can be shown afterwards.
    emit(state.copyWith(game: finishedGame));
    await app<GameService>().saveToGameHistory(finishedGame);
    return finishedGame;
  }

  bool _isOwnerOf(Game game) => _auth.currentUser?.uid == game.ownerId;

  Future<void> _discardPublicGame(Game game) async {
    await _gameSubscription?.cancel();
    _gameSubscription = null;

    try {
      await app<PublicGameService>().deleteGame(game.publicId!);
    } on Exception catch (e, stackTrace) {
      logger.severe('Failed to delete empty public game', e, stackTrace);
    }
  }
}
