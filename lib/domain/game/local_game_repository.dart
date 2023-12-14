import 'package:cabo/core/local_storage_service/local_storage_repository.dart';
import 'package:cabo/domain/game/game.dart';

class LocalGameRepository extends LocalStorageRepository<Game> {
  @override
  Game castMapToObject(Map<String, dynamic> object) {
    return Game.fromJson(object);
  }

  @override
  String get storageKey => 'game';
}
