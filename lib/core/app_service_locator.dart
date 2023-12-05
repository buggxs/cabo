import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/domain/player/player_service.dart';
import 'package:cabo/domain/rule_set/rules_service.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:get_it/get_it.dart';

final GetIt app = GetIt.instance;

void setup() {
  app.allowReassignment = true;

  app
    ..registerFactory<PlayerService>(() => LocalPlayerService())
    ..registerFactory<RuleService>(() => LocalRuleService())
    ..registerFactory<StatisticsDialogService>(() => StatisticsDialogService())
    ..registerSingleton<NavigationService>(NavigationService());
}
