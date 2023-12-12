import 'package:cabo/core/local_storage_service/local_storage_repository.dart';
import 'package:cabo/domain/player/data/player.dart';

class LocalPlayerRepository extends LocalStorageRepository<Player> {
  @override
  Player castMapToObject(Map<String, dynamic> object) {
    return Player.fromJson(object);
  }

  @override
  String get storageKey => 'players';
}
