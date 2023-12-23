part of 'statistics_cubit.dart';

class StatisticsState extends Equatable {
  const StatisticsState({
    this.ruleSet,
    required this.players,
    this.startedAt,
  });

  final List<Player> players;
  final RuleSet? ruleSet;
  final DateTime? startedAt;

  StatisticsState copyWith({
    List<Player>? players,
    RuleSet? ruleSet,
    DateTime? startedAt,
  }) {
    return StatisticsState(
      players: players ?? this.players,
      ruleSet: ruleSet ?? this.ruleSet,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  @override
  List<Object?> get props => [
        ruleSet,
        players,
        startedAt,
      ];
}
