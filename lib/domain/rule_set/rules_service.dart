import 'package:cabo/domain/rule_set/data/rule_set.dart';

abstract class RuleService {
  RuleSet loadRuleSet({
    bool useOwnRules,
  });
}

class LocalRuleService implements RuleService {
  @override
  RuleSet loadRuleSet({bool useOwnRules = false}) {
    return useOwnRules ? kOwnRuleSet : const RuleSet();
  }
}
