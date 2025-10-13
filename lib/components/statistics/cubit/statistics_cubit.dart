import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/main_menu/screens/main_menu_screen.dart';
import 'package:cabo/components/statistics/screens/public_game_screen.dart';
import 'package:cabo/components/statistics/widgets/winner_dialog.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/domain/game/public_game_service.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/rating/rating_service.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/domain/rule_set/rules_service.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> with LoggerMixin {
  StatisticsCubit({required List<Player> players, Game? game})
    : super(StatisticsState(players: players)) {
    loadGame(game: game);
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _gameSubscription;

  void loadGame({Game? game}) {
    DateTime startingDateTime = game?.startedAt?.isNotEmpty ?? false
        ? DateFormat('dd-MM-yyyy HH:mm').parse(game!.startedAt!)
        : DateTime.now();
    if (game == null) {
      _createLocalGame(startingDateTime);
    } else {
      _startGame(game, startingDateTime);
    }

    if ((game?.isPublic ?? false) &&
        FirebaseAuth.instance.currentUser != null) {
      _subscribePublicGame();
    }
  }

  void _createLocalGame(DateTime startedAt) async {
    RuleSet ruleSet = await loadRuleSet();

    Game game = Game(
      startedAt: DateFormat('dd-MM-yyyy HH:mm').format(startedAt),
      players: state.players,
      ruleSet: ruleSet,
    );

    Game currentGame =
        await app<GameService>().saveLastPlayedGame(game) ?? game;

    _startGame(currentGame, startedAt);
  }

  void _startGame(Game game, DateTime startedAt) {
    emit(state.copyWith(game: game, startedAt: startedAt));
  }

  Future<RuleSet> loadRuleSet() async {
    return app<RuleService>().loadRuleSet();
  }

  void closeRound({int? index}) {
    _closeOfflineRound(index);
  }

  /// Will force a game to finish.
  /// It will set the finishedAt of [Game] to the current time
  void onPopScreen() {
    if (state.game?.isGameFinished ?? false) {
      return;
    }

    _saveGame(state.game!, forceFinish: true);
  }

  void showPublicGameDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => PublicGameScreen(
          publishGame: _publishGame,
          gameId: state.game?.publicId,
          game: state.game,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Future<Game?> _publishGame() async {
    Game publicGame = await app<PublicGameService>().saveOrUpdateGame(
      game: state.game!,
    );

    emit(state.copyWith(game: publicGame));

    _subscribePublicGame();

    return publicGame;
  }

  Future<void> _subscribePublicGame() async {
    await _gameSubscription?.cancel();
    _gameSubscription = app<PublicGameService>()
        .subscribeToGame(state.game!.publicId!)
        .listen((snapshot) {
          if (snapshot.exists) {
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

            if (gameData.isGameFinished &&
                FirebaseAuth.instance.currentUser?.uid != gameData.ownerId) {
              _finishGame(gameData.players);
            }
          }
        });
  }

  @override
  Future<void> close() {
    _gameSubscription?.cancel();
    return super.close();
  }

  Future<void> _closeOfflineRound(int? index) async {
    RuleSet ruleSet = state.game?.ruleSet ?? const RuleSet();

    if (state.players.isEmpty) {
      return;
    }

    List<Player> players = List.from(state.players);

    final Player? closingPlayer = await app<StatisticsDialogService>()
        .showRoundCloserDialog(players: players);

    if (closingPlayer == null) {
      return;
    }

    final Map<String, int?>? playerPointsmap =
        await app<StatisticsDialogService>().showPointDialog(state.players);

    if (playerPointsmap != null) {
      for (int i = 0; i < players.length; i++) {
        Player player = players[i];
        int playerPoints = playerPointsmap[player.name] ?? 0;

        int pointsOfClosingPlayer = _getPointsOfClosingPlayer(
          playerPointsmap,
          closingPlayer,
        );

        bool closingPlayerHasLost = _isClosingPlayerLooser(
          playerPointsmap,
          closingPlayer,
          pointsOfClosingPlayer,
        );

        if (player == closingPlayer && closingPlayerHasLost) {
          playerPoints = playerPoints + 5;
        }

        if (ruleSet.roundWinnerGetsZeroPoints) {
          if (player == closingPlayer && !closingPlayerHasLost) {
            playerPoints = 0;
          } else if (closingPlayerHasLost &&
              playerPoints == _getLowestPoints(playerPointsmap)) {
            playerPoints = 0;
          }
        }

        if (ruleSet.useKamikazeRule &&
            _checkIfPlayerHitsKamikaze(playerPointsmap, ruleSet) != null) {
          if (_checkIfPlayerHitsKamikaze(playerPointsmap, ruleSet) ==
              player.name) {
            playerPoints = 0;
            closingPlayerHasLost = false;
          } else {
            playerPoints = 50;
          }
        }

        if (index != null) {
          List<Round> round = List.of(players[i].rounds);
          round.removeAt(index);
          players[i] = player.copyWith(
            rounds: [
              ...round,
              Round(
                round: player.rounds.length + 1,
                points: playerPoints,
                hasClosedRound: closingPlayer == player,
                hasPenaltyPoints:
                    closingPlayer == player && closingPlayerHasLost,
                hasPrecisionLanding: _hasDonePrecisionLanding(
                  player,
                  playerPoints,
                ),
                isWonRound: _hasWonRound(
                  player.name,
                  playerPointsmap,
                  ruleSet,
                  playerPoints,
                  closingPlayer,
                  closingPlayerHasLost,
                ),
              ),
            ],
          );
        } else {
          players[i] = player.copyWith(
            rounds: [
              ...player.rounds,
              Round(
                round: player.rounds.length + 1,
                points: playerPoints,
                hasClosedRound: closingPlayer == player,
                hasPenaltyPoints:
                    closingPlayer == player && closingPlayerHasLost,
                hasPrecisionLanding: _hasDonePrecisionLanding(
                  player,
                  playerPoints,
                ),
                isWonRound: _hasWonRound(
                  player.name,
                  playerPointsmap,
                  ruleSet,
                  playerPoints,
                  closingPlayer,
                  closingPlayerHasLost,
                ),
              ),
            ],
          );
        }
      }
    }

    players.sort(
      (Player a, Player b) => a.totalPoints.compareTo(b.totalPoints),
    );

    for (int i = 0; i < players.length; i++) {
      players[i] = players[i].copyWith(place: i + 1);
    }

    // Create the updated game with the new player data
    Game updatedGame = state.game!.copyWith(players: players);

    // Update the state with the new players and game data
    emit(state.copyWith(players: players, game: updatedGame));

    // Save the game state
    _saveGame(updatedGame);

    if (updatedGame.isGameFinished) {
      _finishGame(players);
    }
  }

  void _finishGame(List<Player> players) {
    Player winner = players.firstWhere((player) => player.place == 1);

    // Show the winner dialog
    _showWinnerDialog(
      winner: winner,
      onConfirm: () {
        app<NavigationService>().navigatorKey.currentState?.popAndPushNamed(
          MainMenuScreen.route,
        );

        app<RatingService>().trackGameCompletion();
      },
    );
  }

  bool _hasWonRound(
    String playerName,
    Map<String, int?> playerPointsmap,
    RuleSet ruleSet,
    int points,
    Player closingPlayer,
    bool closingPlayerHasLost,
  ) {
    if (!ruleSet.useKamikazeRule ||
        _checkIfPlayerHitsKamikaze(playerPointsmap, ruleSet) == null) {
      // If closing Player and another player have same points
      if (!closingPlayerHasLost &&
          points == _getLowestPoints(playerPointsmap) &&
          playerName != closingPlayer.name) {
        return false;
      }

      return playerPointsmap[playerName] == _getLowestPoints(playerPointsmap);
    }

    if (_checkIfPlayerHitsKamikaze(playerPointsmap, ruleSet) == playerName) {
      return true;
    } else {
      return false;
    }
  }

  bool _hasDonePrecisionLanding(Player player, int points) {
    RuleSet ruleSet = state.game?.ruleSet ?? const RuleSet();
    if (ruleSet.precisionLanding) {
      if ((player.totalPoints + points) == ruleSet.totalGamePoints) {
        return true;
      }
    }
    return false;
  }

  void _saveGame(Game game, {bool forceFinish = false}) async {
    if (game.isGameFinished || forceFinish) {
      DateTime finishedAt = DateTime.now();
      String finishedGame = DateFormat('dd-MM-yyyy HH:mm').format(finishedAt);

      if (forceFinish) {
        String? uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid == game.ownerId || !game.isPublic) {
          game = game.copyWith(finishedAt: finishedGame);
        }
      } else {
        game = game.copyWith(finishedAt: finishedGame);
      }

      app<GameService>().saveToGameHistory(game);
    }
    if (state.game?.isPublic ?? false) {
      app<PublicGameService>().saveOrUpdateGame(game: game);
    }

    await app<GameService>().saveLastPlayedGame(game);
  }

  String? _checkIfPlayerHitsKamikaze(
    Map<String, int?> playerPointsmap,
    RuleSet ruleSet,
  ) {
    return playerPointsmap.entries
        .where((element) => element.value == ruleSet.kamikazePoints)
        .firstOrNull
        ?.key;
  }

  int _getLowestPoints(Map<String, int?> playerPointsmap) {
    MapEntry<String, int?>? lowest;
    for (var element in playerPointsmap.entries) {
      lowest ??= element;
      if ((lowest.value ?? 0) >= (element.value ?? 0)) {
        lowest = element;
      }
    }
    return lowest!.value ?? 0;
  }

  int _getPointsOfClosingPlayer(
    Map<String, int?> playerPointsmap,
    Player closingPlayer,
  ) {
    return playerPointsmap.entries
            .firstWhere(
              (MapEntry<String, int?> entry) => entry.key == closingPlayer.name,
            )
            .value ??
        0;
  }

  bool _isClosingPlayerLooser(
    Map<String, int?> playerPointsmap,
    Player closingPlayer,
    int pointsOfClosingPlayer,
  ) {
    return playerPointsmap.entries.any(
      (MapEntry<String, int?> element) =>
          element.key != closingPlayer.name &&
          (element.value ?? 0) < pointsOfClosingPlayer,
    );
  }

  // Shows the winner dialog with animation
  void _showWinnerDialog({required Player winner, void Function()? onConfirm}) {
    app<NavigationService>().showAppDialog(
      dialog: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(
            style: BorderStyle.solid,
            color: CaboTheme.tertiaryColor,
            width: 2,
          ),
        ),
        backgroundColor: CaboTheme.secondaryColor,
        child: WinnerDialog(winner: winner, onConfirm: onConfirm),
      ),
    );
  }
}
