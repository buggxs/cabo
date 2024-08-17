part of 'statistics_cubit.dart';

class StatisticsState extends Equatable {
  const StatisticsState({
    this.game,
    required this.players,
    this.startedAt,
    this.publicGame,
  });

  final Game? game;
  final OpenGame? publicGame;
  final List<Player> players;
  final DateTime? startedAt;

  StatisticsState copyWith({
    List<Player>? players,
    OpenGame? publicGame,
    Game? game,
    DateTime? startedAt,
  }) {
    return StatisticsState(
      game: game ?? this.game,
      players: players ?? this.players,
      startedAt: startedAt ?? this.startedAt,
      publicGame: publicGame ?? this.publicGame,
    );
  }

  bool get isPublicGame => publicGame != null;

  @override
  List<Object?> get props => [
        players,
        game,
        publicGame,
        // startedAt,
      ];
}
