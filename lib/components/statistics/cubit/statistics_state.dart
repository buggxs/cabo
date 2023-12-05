part of 'statistics_cubit.dart';

class StatisticsState extends Equatable {
  const StatisticsState({
    this.ruleSet,
    this.players,
  });

  final List<Player>? players;
  final RuleSet? ruleSet;

  StatisticsState copyWith({
    List<Player>? players,
    RuleSet? ruleSet,
  }) {
    return StatisticsState(
      players: players ?? this.players,
      ruleSet: ruleSet ?? this.ruleSet,
    );
  }

  @override
  List<Object?> get props => [ruleSet, players];
}
