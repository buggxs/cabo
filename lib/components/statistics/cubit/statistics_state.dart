part of 'statistics_cubit.dart';

class StatisticsState extends Equatable {
  const StatisticsState({this.game, required this.players, this.startedAt});

  final Game? game;
  final List<Player> players;
  final DateTime? startedAt;

  StatisticsState copyWith({
    List<Player>? players,
    Game? game,
    DateTime? startedAt,
  }) {
    return StatisticsState(
      game: game ?? this.game,
      players: players ?? this.players,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  @override
  List<Object?> get props => [
    players,
    game,
    // startedAt,
  ];
}
