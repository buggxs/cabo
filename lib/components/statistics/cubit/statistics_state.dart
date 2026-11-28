part of 'statistics_cubit.dart';

class StatisticsState extends Equatable {
  const StatisticsState({this.game, required this.players});

  final Game? game;
  final List<Player> players;

  StatisticsState copyWith({List<Player>? players, Game? game}) {
    return StatisticsState(
      game: game ?? this.game,
      players: players ?? this.players,
    );
  }

  @override
  List<Object?> get props => <Object?>[players, game];
}
