part of 'statistics_cubit.dart';

class StatisticsState extends Equatable {
  const StatisticsState({
    this.gameId,
    this.ruleSet,
    required this.players,
    this.startedAt,
  });

  final int? gameId;
  final List<Player> players;
  final RuleSet? ruleSet;
  final DateTime? startedAt;

  StatisticsState copyWith({
    int? gameId,
    List<Player>? players,
    RuleSet? ruleSet,
    DateTime? startedAt,
  }) {
    return StatisticsState(
      gameId: gameId ?? this.gameId,
      players: players ?? this.players,
      ruleSet: ruleSet ?? this.ruleSet,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  @override
  List<Object?> get props => [
        ruleSet,
        players,
        // TODO: find a good way to test it
        // startedAt,
      ];
}
