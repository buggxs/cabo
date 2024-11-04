import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/domain/open_game/open_game.dart';
import 'package:cabo/domain/open_game/open_game_service.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/domain/rule_set/rules_service.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> with LoggerMixin {
  StatisticsCubit({
    required List<Player> players,
    this.useOwnRuleSet = false,
    Game? game,
  }) : super(
          StatisticsState(
            players: players,
          ),
        ) {
    loadGame(game: game);
  }

  final OpenGameService openGameService = app<OpenGameService>();
  final bool useOwnRuleSet;

  late final StompClient? client;

  void loadGame({Game? game}) {
    DateTime startingDateTime = game?.startedAt?.isNotEmpty ?? false
        ? DateFormat.yMd().parse(game!.startedAt!)
        : DateTime.now();
    if (game == null) {
      _createLocalGame(startingDateTime);
    } else {
      _startGame(game, startingDateTime);
    }
  }

  void _createLocalGame(DateTime startedAt) async {
    RuleSet ruleSet = await loadRuleSet();

    Game game = Game(
      startedAt: DateFormat.yMd().format(startedAt),
      players: state.players,
      ruleSet: ruleSet,
    );

    Game currentGame =
        await app<GameService>().saveLastPlayedGame(game) ?? game;

    _startGame(currentGame, startedAt);
  }

  void _startGame(Game game, DateTime startedAt) {
    emit(state.copyWith(
      game: game,
      startedAt: startedAt,
    ));
  }

  Future<RuleSet> loadRuleSet() async {
    return app<RuleService>().loadRuleSet(
      useOwnRules: useOwnRuleSet,
    );
  }

  Future<String?> publishGame() async {
    if (state.game == null) {
      return null;
    }

    OpenGame openGame = await openGameService.publishGame(state.game!);
    emit(
      state.copyWith(
        publicGame: openGame,
        game: openGame.game,
      ),
    );

    _connectToWebSocket();
    return openGame.publicId;
  }

  void _connectToWebSocket() {
    client = StompClient(
      config: StompConfig(
          url: 'ws://18.156.177.170:80/cabo-ws',
          onConnect: _onConnectCallback,
          onStompError: (frame) {
            log.severe(frame);
          },
          onWebSocketError: (error) {
            log.severe(error);
          },
          onDebugMessage: (message) {
            log.info(message);
          }),
    );
    client?.activate();
  }

  /// [client] is connected and ready
  void _onConnectCallback(StompFrame connectFrame) {
    log.info('StompFrame Body content:');
    log.info(connectFrame.body);
    client?.subscribe(
        destination: '/game/room/${state.publicGame?.publicId}',
        headers: {},
        callback: (StompFrame frame) {
          // Received a frame for this subscription
          log.info('');
          log.info(frame.body);
          if (frame.body != null) {
            final Map<String, dynamic> json = jsonDecode(frame.body ?? '');

            // Retrieving new game stats after _closeOnlineRound()
            if (json['event'] == 'UPDATE_GAME') {
              final Game game = Game.fromJson(json['payload']['game']);
              emit(
                state.copyWith(
                  players: game.players,
                  game: game,
                ),
              );

              _saveGame(state.game!);
            }
          }
        });
  }

  /// Close round when game is online
  /// Game stats will be processed online on a server
  /// Points will be send via websocket to the server
  void _closeOnlineRound() async {
    final Player? closingPlayer = await app<StatisticsDialogService>()
        .showRoundCloserDialog(players: state.players);

    if (closingPlayer == null) {
      return;
    }

    final Map<String, int?>? playerPointsmap =
        await app<StatisticsDialogService>().showPointDialog(state.players);

    if (playerPointsmap != null &&
        state.publicGame?.publicId != null &&
        state.game != null) {
      Map<String, dynamic> message = {
        "channel": ["GENERAL"],
        "event": "ADD_ROUND",
        "payload": {
          "openGame": OpenGame(
            id: state.publicGame!.id,
            publicId: state.publicGame!.publicId!,
            gameId: state.publicGame!.gameId!,
            game: state.game!,
          ).toJson(),
          "closingPlayer": closingPlayer.toJson(),
          "playerPointsMap": playerPointsmap,
        },
      };

      client?.send(
        destination: '/cabo/room/${state.publicGame!.publicId!}',
        headers: {},
        body: jsonEncode(message),
      );
    }
  }

  void closeRound() {
    if (state.isPublicGame) {
      _closeOnlineRound();
    } else {
      _closeOfflineRound();
    }
  }

  /// Will force a game to finish.
  /// It will set the finishedAt of [Game] to the current time
  void onPopScreen() {
    _saveGame(state.game!, forceFinish: true);
  }

  /// Close round when game is offline game
  /// Stats will be processed offline on the device
  /// Game stats will be saved in local device storage
  Future<void> _closeOfflineRound() async {
    RuleSet ruleSet = state.game?.ruleSet ?? const RuleSet();

    if (state.players.isEmpty) {
      return;
    }

    List<Player> players = List.from(state.players);

    final Player? closingPlayer = await app<StatisticsDialogService>()
        .showRoundCloserDialog(players: state.players);

    if (closingPlayer == null) {
      return;
    }

    final Map<String, int?>? playerPointsmap =
        await app<StatisticsDialogService>().showPointDialog(state.players);

    if (playerPointsmap != null) {
      for (int i = 0; i < players.length; i++) {
        Player player = players[i];
        int points = playerPointsmap[player.name] ?? 0;

        int pointsOfClosingPlayer =
            _getPointsOfClosingPlayer(playerPointsmap, closingPlayer);

        bool closingPlayerHasLost = _isClosingPlayerLooser(
          playerPointsmap,
          closingPlayer,
          pointsOfClosingPlayer,
        );

        if (player == closingPlayer && closingPlayerHasLost) {
          points = points + 5;
        }

        if (ruleSet.roundWinnerGetsZeroPoints) {
          if (player == closingPlayer && !closingPlayerHasLost) {
            points = 0;
          } else if (closingPlayerHasLost &&
              player.name == _getPlayerWithLowestPoints(playerPointsmap)) {
            points = 0;
          }
        }

        if (ruleSet.useKamikazeRule &&
            _checkIfPlayerHitsKamikaze(playerPointsmap)) {
          if (points == 55) {
            points = 0;
            closingPlayerHasLost = false;
          } else {
            points = 50;
          }
        }

        players[i] = player.copyWith(
          rounds: [
            ...player.rounds,
            Round(
              round: player.rounds.length + 1,
              points: points,
              hasClosedRound: closingPlayer == player,
              hasPenaltyPoints: closingPlayer == player && closingPlayerHasLost,
              hasPrecisionLanding: _hasDonePrecisionLanding(player, points),
            ),
          ],
        );
      }
    }

    players
        .sort((Player a, Player b) => a.totalPoints.compareTo(b.totalPoints));

    for (int i = 0; i < players.length; i++) {
      players[i] = players[i].copyWith(place: i + 1);
    }

    emit(
      state.copyWith(
        players: players,
        game: state.game!.copyWith(
          players: players,
        ),
      ),
    );

    _saveGame(state.game!);
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
      String finishedGame = DateFormat('dd-MM-yyyy').format(finishedAt);

      game = game.copyWith(
        finishedAt: finishedGame,
      );

      app<GameService>().saveToGameHistory(game);

      if (state.isPublicGame && client != null) {
        client?.deactivate();
      }
    }

    await app<GameService>().saveLastPlayedGame(game);
  }

  bool _checkIfPlayerHitsKamikaze(Map<String, int?> playerPointsmap) {
    return playerPointsmap.entries.any((element) => element.value == 50);
  }

  String _getPlayerWithLowestPoints(Map<String, int?> playerPointsmap) {
    MapEntry<String, int?>? lowest;
    for (var element in playerPointsmap.entries) {
      lowest ??= element;
      if ((lowest.value ?? 0) > (element.value ?? 0)) {
        lowest = element;
      }
    }
    return lowest!.key;
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
    return playerPointsmap.entries.any((MapEntry<String, int?> element) =>
        element.key != closingPlayer.name &&
        (element.value ?? 0) < pointsOfClosingPlayer);
  }
}
