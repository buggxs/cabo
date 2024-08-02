part of 'statistics_cubit.dart';

class StatisticsState extends Equatable {
  const StatisticsState({
    this.gameId,
    this.ruleSet,
    this.game,
    required this.players,
    this.startedAt,
    this.isPublic = false,
    this.publicGame,
  });

  final int? gameId;
  final Game? game;
  final OpenGame? publicGame;
  final List<Player> players;
  final RuleSet? ruleSet;
  final DateTime? startedAt;
  final bool isPublic;

  StatisticsState copyWith({
    int? gameId,
    List<Player>? players,
    OpenGame? publicGame,
    Game? game,
    RuleSet? ruleSet,
    DateTime? startedAt,
    bool? isPublic,
  }) {
    return StatisticsState(
      gameId: gameId ?? this.gameId,
      game: game ?? this.game,
      players: players ?? this.players,
      ruleSet: ruleSet ?? this.ruleSet,
      startedAt: startedAt ?? this.startedAt,
      isPublic: isPublic ?? this.isPublic,
      publicGame: publicGame ?? this.publicGame,
    );
  }

  @override
  List<Object?> get props => [
        ruleSet,
        players,
        game,
        isPublic,
        publicGame,
        // TODO: find a good way to test it
        // startedAt,
      ];
}
