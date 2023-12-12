import 'package:bloc/bloc.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/domain/rule_set/rules_service.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:equatable/equatable.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit({
    required List<Player> players,
    this.useOwnRuleSet = false,
  }) : super(StatisticsState(
          players: players,
        ));

  final bool useOwnRuleSet;

  void loadRuleSet() {
    RuleSet ruleSet = app<RuleService>().loadRuleSet(
      useOwnRules: useOwnRuleSet,
    );
    app<GameService>().saveGame(Game(players: state.players));
    emit(state.copyWith(ruleSet: ruleSet));
  }

  Future<void> closeRound() async {
    RuleSet ruleSet = state.ruleSet ?? const RuleSet();

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
            getPointsOfClosingPlayer(playerPointsmap, closingPlayer);

        final bool closingPlayerHasLost = isClosingPlayerLooser(
          playerPointsmap,
          closingPlayer,
          pointsOfClosingPlayer,
        );

        if (player == closingPlayer && closingPlayerHasLost) {
          points = points + 5;
        }

        if (player == closingPlayer &&
            !closingPlayerHasLost &&
            ruleSet.roundWinnerGetsZeroPoints) {
          points = 0;
        }

        if (ruleSet.useKamikazeRule &&
            checkIfPlayerHitsKamikaze(playerPointsmap)) {
          if (points == 50) {
            points = 0;
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
                hasPenaltyPoints:
                    closingPlayer == player && closingPlayerHasLost),
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
      ),
    );

    Game? game =
        await app<GameService>().saveGame(Game(players: state.players));

    if (game?.isGameFinished ?? false) {
      finishGame();
    }
  }

  void finishGame() {
    // TODO: delete saved active game and add the finished
    // to the list of games
    print('Finish game!');
  }

  bool checkIfPlayerHitsKamikaze(Map<String, int?> playerPointsmap) {
    return playerPointsmap.entries.any((element) => element.value == 50);
  }

  int getPointsOfClosingPlayer(
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

  bool isClosingPlayerLooser(
    Map<String, int?> playerPointsmap,
    Player closingPlayer,
    int pointsOfClosingPlayer,
  ) {
    return playerPointsmap.entries.any((MapEntry<String, int?> element) =>
        element.key != closingPlayer.name &&
        (element.value ?? 0) < pointsOfClosingPlayer);
  }
}
