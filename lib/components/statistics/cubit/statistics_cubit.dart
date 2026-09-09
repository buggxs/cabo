import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cabo/components/statistics/screens/public_game_screen.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/domain/game/public_game_service.dart';
import 'package:cabo/domain/player/data/player.dart';
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
  StatisticsCubit({
    required List<Player> players,
    Game? game,
    FirebaseAuth? auth,
  }) : _authOverride = auth,
       super(StatisticsState(players: players)) {
    loadGame(game: game);
  }

  final FirebaseAuth? _authOverride;
  FirebaseAuth get _auth => _authOverride ?? FirebaseAuth.instance;
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

    if ((game?.isPublic ?? false) && _auth.currentUser != null) {
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

  /// Will force a game to finish for the owner (or a local game).
  /// For public games, non-owners simply leave locally — no Firestore write
  /// happens; the game stays live for the remaining players.
  Future<void> onPopScreen() async {
    if (state.game?.isGameFinished ?? false) {
      return;
    }

    await _saveGame(state.game!, forceFinish: true);
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

    // publicId/ownerId sofort lokal persistieren, sonst geht die Subscription
    // beim App-Restart verloren, falls bis dahin keine Runde geschlossen wurde.
    await app<GameService>().saveLastPlayedGame(publicGame);

    emit(state.copyWith(game: publicGame));

    _subscribePublicGame();

    return publicGame;
  }

  Future<void> _subscribePublicGame() async {
    await _gameSubscription?.cancel();
    _gameSubscription = app<PublicGameService>()
        .subscribeToGame(state.game!.publicId!)
        .listen((snapshot) {
          if (!snapshot.exists) {
            return;
          }

          // Eigene lokale Writes nicht als Remote-Update verarbeiten —
          // sonst doppelter emit / UI-Flackern.
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
    _gameSubscription?.cancel();
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
      for (int i = 0; i < players.length; i++) {
        players[i] = _applyRound(
          player: players[i],
          ruleSet: ruleSet,
          playerPointsMap: playerPointsMap,
          closingPlayer: closingPlayer,
          index: index,
        );
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

  /// Replaces the round at [index] or appends a new one when [index] is `null`.
  Player _applyRound({
    required Player player,
    required RuleSet ruleSet,
    required Map<String, int?> playerPointsMap,
    required Player closingPlayer,
    int? index,
  }) {
    final List<Round> rounds = List<Round>.of(player.rounds);
    if (index != null && index < rounds.length) {
      rounds.removeAt(index);
    }

    final Round round = _buildRound(
      player: player,
      pointsBeforeRound: player.copyWith(rounds: rounds).totalPoints,
      roundNumber: rounds.length + 1,
      ruleSet: ruleSet,
      playerPointsMap: playerPointsMap,
      closingPlayer: closingPlayer,
    );

    return player.copyWith(rounds: <Round>[...rounds, round]);
  }

  Round _buildRound({
    required Player player,
    required int pointsBeforeRound,
    required int roundNumber,
    required RuleSet ruleSet,
    required Map<String, int?> playerPointsMap,
    required Player closingPlayer,
  }) {
    final bool hasClosedRound = player.name == closingPlayer.name;
    final String? kamikazePlayerName = _findKamikazePlayer(
      playerPointsMap,
      ruleSet,
    );

    if (kamikazePlayerName != null) {
      return _buildKamikazeRound(
        isKamikazePlayer: kamikazePlayerName == player.name,
        hasClosedRound: hasClosedRound,
        roundNumber: roundNumber,
        ruleSet: ruleSet,
        pointsBeforeRound: pointsBeforeRound,
      );
    }

    final bool hasClosingPlayerLost = _isClosingPlayerLooser(
      playerPointsMap,
      closingPlayer,
      _getPointsOfClosingPlayer(playerPointsMap, closingPlayer),
    );
    final bool hasPenaltyPoints = hasClosedRound && hasClosingPlayerLost;
    final bool isWonRound = _hasWonRound(
      player.name,
      playerPointsMap,
      closingPlayer,
      hasClosingPlayerLost,
    );

    int points = playerPointsMap[player.name] ?? 0;
    if (hasPenaltyPoints) {
      points += kFailedCaboPenaltyPoints;
    }
    if (ruleSet.roundWinnerGetsZeroPoints && isWonRound) {
      points = 0;
    }

    return _createRound(
      roundNumber: roundNumber,
      points: points,
      hasClosedRound: hasClosedRound,
      hasPenaltyPoints: hasPenaltyPoints,
      isWonRound: isWonRound,
      ruleSet: ruleSet,
      pointsBeforeRound: pointsBeforeRound,
    );
  }

  /// A kamikaze replaces the whole round result: the kamikaze player wins the
  /// round with zero points, everyone else takes the configured penalty.
  Round _buildKamikazeRound({
    required bool isKamikazePlayer,
    required bool hasClosedRound,
    required int roundNumber,
    required RuleSet ruleSet,
    required int pointsBeforeRound,
  }) {
    return _createRound(
      roundNumber: roundNumber,
      points: isKamikazePlayer ? 0 : ruleSet.kamikazePoints,
      hasClosedRound: hasClosedRound,
      hasPenaltyPoints: false,
      isWonRound: isKamikazePlayer,
      ruleSet: ruleSet,
      pointsBeforeRound: pointsBeforeRound,
      isKamikazeRound: true,
    );
  }

  Round _createRound({
    required int roundNumber,
    required int points,
    required bool hasClosedRound,
    required bool hasPenaltyPoints,
    required bool isWonRound,
    required RuleSet ruleSet,
    required int pointsBeforeRound,
    bool isKamikazeRound = false,
  }) {
    final int deduction = _precisionLandingDeduction(
      ruleSet,
      pointsBeforeRound + points,
    );

    return Round(
      round: roundNumber,
      points: points,
      hasClosedRound: hasClosedRound,
      hasPenaltyPoints: hasPenaltyPoints,
      hasPrecisionLanding: deduction > 0,
      precisionLandingDeduction: deduction > 0 ? deduction : null,
      isKamikazeRound: isKamikazeRound,
      isWonRound: isWonRound,
    );
  }

  /// Landing exactly on the total game points halves the player's score
  /// instead of ending the game.
  int _precisionLandingDeduction(RuleSet ruleSet, int totalPointsAfterRound) {
    if (!ruleSet.precisionLanding ||
        totalPointsAfterRound != ruleSet.totalGamePoints) {
      return 0;
    }
    return ruleSet.totalGamePoints ~/ 2;
  }

  void _finishGame(List<Player> players) {
    final Player? winner = players
        .where((player) => player.place == 1)
        .firstOrNull;
    if (winner == null) {
      logger.warning('_finishGame called without a winner candidate');
      return;
    }

    app<NavigationService>().pushToEndGameScreen(game: state.game!);
  }

  /// The lowest hand wins the round; on a tie the player who called Cabo wins.
  bool _hasWonRound(
    String playerName,
    Map<String, int?> playerPointsMap,
    Player closingPlayer,
    bool hasClosingPlayerLost,
  ) {
    if ((playerPointsMap[playerName] ?? 0) !=
        _getLowestPoints(playerPointsMap)) {
      return false;
    }

    if (!hasClosingPlayerLost) {
      return playerName == closingPlayer.name;
    }

    return true;
  }

  Future<void> _saveGame(Game game, {bool forceFinish = false}) async {
    // Non-Owner darf im Public Game das Spiel nicht vorzeitig für alle beenden.
    // In diesem Fall verlässt der Spieler nur lokal — kein Firestore-/History-Write.
    if (forceFinish && game.isPublic && !_isOwnerOf(game)) {
      return;
    }

    // Ein veröffentlichtes Spiel ohne eine einzige Runde wurde nur ausprobiert.
    // Es wird wieder aus Firestore entfernt, statt als beendetes Spiel dort
    // liegen zu bleiben.
    final bool isAbandonedPublicGame =
        forceFinish && game.isPublic && !game.hasRounds;

    if (isAbandonedPublicGame) {
      await _discardPublicGame(game);
    }

    if (game.isGameFinished || forceFinish) {
      final String finishedGame = DateFormat(
        'dd-MM-yyyy HH:mm',
      ).format(DateTime.now());
      game = game.copyWith(finishedAt: finishedGame);
      // State sofort aktualisieren, damit isGameFinished true ist und der
      // EndGameScreen anschließend angezeigt werden kann.
      emit(state.copyWith(game: game));
      await app<GameService>().saveToGameHistory(game);
    }

    if (game.isPublic && !isAbandonedPublicGame) {
      try {
        await app<PublicGameService>().saveOrUpdateGame(game: game);
      } catch (e, stackTrace) {
        logger.severe('Failed to sync public game to Firestore', e, stackTrace);
      }
    }

    await app<GameService>().saveLastPlayedGame(game);
  }

  bool _isOwnerOf(Game game) => _auth.currentUser?.uid == game.ownerId;

  Future<void> _discardPublicGame(Game game) async {
    await _gameSubscription?.cancel();
    _gameSubscription = null;

    try {
      await app<PublicGameService>().deleteGame(game.publicId!);
    } catch (e, stackTrace) {
      logger.severe('Failed to delete empty public game', e, stackTrace);
    }
  }

  String? _findKamikazePlayer(
    Map<String, int?> playerPointsMap,
    RuleSet ruleSet,
  ) {
    if (!ruleSet.useKamikazeRule) {
      return null;
    }

    return playerPointsMap.entries
        .where(
          (MapEntry<String, int?> entry) =>
              entry.value == ruleSet.kamikazePoints,
        )
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
    return lowest?.value ?? 0;
  }

  int _getPointsOfClosingPlayer(
    Map<String, int?> playerPointsmap,
    Player closingPlayer,
  ) {
    return playerPointsmap.entries
            .where(
              (MapEntry<String, int?> entry) => entry.key == closingPlayer.name,
            )
            .firstOrNull
            ?.value ??
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
}
