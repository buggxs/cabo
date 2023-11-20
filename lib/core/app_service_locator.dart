import 'package:cabo/domain/player/player_service.dart';
import 'package:cabo/domain/rule_set/rules_service.dart';
import 'package:get_it/get_it.dart';

final GetIt app = GetIt.instance;

void setup() {
  app
    ..registerLazySingleton<PlayerService>(() => LocalPlayerService())
    ..registerLazySingleton<RuleService>(() => LocalRuleService());
}
