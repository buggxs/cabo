import 'package:cabo/core/local_storage_service/local_storage_repository.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';

class LocalRuleSetRepository extends LocalStorageRepository<RuleSet> {
  @override
  RuleSet castMapToObject(Map<String, dynamic> object) {
    return RuleSet.fromJson(object);
  }

  @override
  String get storageKey => 'rule_set';
}
