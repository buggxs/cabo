import 'package:bloc/bloc.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/domain/rule_set/rules_service.dart';
import 'package:equatable/equatable.dart';

part 'rule_set_state.dart';

class RuleSetCubit extends Cubit<RuleSetState> {
  RuleSetCubit() : super(const RuleSetState());

  final RuleService _ruleService = app<RuleService>();

  void loadRuleSet() async {
    final RuleSet ruleSet = await _ruleService.loadRuleSet();
    emit(state.copyWith(ruleSet: ruleSet));
  }

  void resetRuleSet() async {
    final RuleSet? ruleSet = await _ruleService.saveRuleSet(const RuleSet());
    emit(state.copyWith(ruleSet: ruleSet));
  }

  void saveRuleSet(RuleSet updatedRuleSet) async {
    final RuleSet? ruleSet = await _ruleService.saveRuleSet(updatedRuleSet);
    emit(state.copyWith(ruleSet: ruleSet));
  }
}
