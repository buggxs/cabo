part of 'rule_set_cubit.dart';

class RuleSetState extends Equatable {
  const RuleSetState({this.ruleSet = const RuleSet()});

  final RuleSet ruleSet;

  RuleSetState copyWith({RuleSet? ruleSet}) {
    return RuleSetState(ruleSet: ruleSet ?? this.ruleSet);
  }

  @override
  List<Object?> get props => [ruleSet];
}
