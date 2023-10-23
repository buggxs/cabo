import 'package:cabo/domain/player/player_service.dart';
import 'package:get_it/get_it.dart';

final GetIt app = GetIt.instance;

void setup() {
  app.registerLazySingleton<PlayerService>(() => LocalPlayerService());
}
