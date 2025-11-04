import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/domain/application/local_application_repository.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/domain/game/local_game_repository.dart';
import 'package:cabo/domain/game/public_game_service.dart';
import 'package:cabo/domain/player/local_player_repository.dart';
import 'package:cabo/domain/player/player_service.dart';
import 'package:cabo/domain/rating/rating_service.dart';
import 'package:cabo/domain/rule_set/local_rule_set_repository.dart';
import 'package:cabo/domain/rule_set/rules_service.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:get_it/get_it.dart';

final GetIt app = GetIt.instance;

void setup() {
  app.allowReassignment = true;

  app
    ..registerFactory<PlayerService>(() => LocalPlayerService())
    ..registerFactory<RuleService>(() => LocalRuleService())
    ..registerFactory<GameService>(() => LocalGameService())
    ..registerFactory<PublicGameService>(() => PublicGameService())
    ..registerFactory<StatisticsDialogService>(() => StatisticsDialogService())
    ..registerSingleton<NavigationService>(NavigationService())
    ..registerSingleton<LocalPlayerRepository>(LocalPlayerRepository())
    ..registerSingleton<LocalGameRepository>(LocalGameRepository())
    ..registerLazySingleton<LocalRuleSetRepository>(LocalRuleSetRepository.new)
    ..registerLazySingleton<LocalApplicationRepository>(
      LocalApplicationRepository.new,
    )
    ..registerLazySingleton<RatingService>(RatingService.new)
    ..registerLazySingleton<ApplicationCubit>(
      () =>
          ApplicationCubit(repository: app<LocalApplicationRepository>())
            ..init(),
    );
}
