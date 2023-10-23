part of 'statistics_cubit.dart';

class StatisticsState {
  StatisticsState({
    this.players,
  });

  final List<Player>? players;

  StatisticsState copyWith({
    List<Player>? players,
  }) {
    return StatisticsState(
      players: players ?? this.players,
    );
  }
}
