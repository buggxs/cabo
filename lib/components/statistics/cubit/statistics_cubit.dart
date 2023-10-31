import 'package:bloc/bloc.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:flutter/material.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit({required List<Player> players})
      : super(StatisticsState(
          players: players,
        ));

  Future<void> closeRound(BuildContext context) async {
    if (state.players == null) {
      return;
    }

    List<Player> players = state.players!;

    final Player? closingPlayer =
        await showRoundCloserDialog(context: context, players: state.players);

    if (closingPlayer == null) {
      return;
    }

    final Map<String, int?>? playerPointsmap =
        await showPointDialog(context, state.players);

    if (playerPointsmap != null) {
      for (int i = 0; i < players.length; i++) {
        Player player = players[i];
        int points = playerPointsmap[player.name] ?? 0;

        int pointsOfClosingPlayer = playerPointsmap.entries
                .firstWhere(
                  (MapEntry<String, int?> entry) =>
                      entry.key == closingPlayer.name,
                )
                .value ??
            0;

        final bool closingPlayerIsWinner = playerPointsmap.entries.any(
            (MapEntry<String, int?> element) =>
                element.key != closingPlayer.name &&
                (element.value ?? 0) < pointsOfClosingPlayer);

        if (player == closingPlayer && closingPlayerIsWinner) {
          points = points + 5;
        }

        players[i] = player.copyWith(
          rounds: [
            ...player.rounds,
            Round(
                round: player.rounds.length + 1,
                points: points,
                hasClosedRound: closingPlayer == player,
                hasPenaltyPoints:
                    closingPlayer == player && closingPlayerIsWinner),
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
  }
}
