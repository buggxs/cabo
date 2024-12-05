import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/domain/rule_set/local_rule_set_repository.dart';

abstract class RuleService {
  Future<RuleSet> loadRuleSet();

  Future<RuleSet?> saveRuleSet(RuleSet ruleSet);
}

class LocalRuleService implements RuleService {
  final LocalRuleSetRepository repository = app<LocalRuleSetRepository>();

  @override
  Future<RuleSet> loadRuleSet() async {
    return await repository.getCurrent() ?? const RuleSet();
  }

  @override
  Future<RuleSet?> saveRuleSet(RuleSet ruleSet) async {
    return repository.saveCurrent(ruleSet);
  }
}
