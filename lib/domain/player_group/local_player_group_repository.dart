import 'package:cabo/core/local_storage_service/local_storage_repository.dart';
import 'package:cabo/domain/player_group/data/player_group.dart';

class LocalPlayerGroupRepository extends LocalStorageRepository<PlayerGroup> {
  @override
  PlayerGroup castMapToObject(dynamic object) {
    return PlayerGroup.fromJson(object);
  }

  @override
  String get storageKey => 'player_groups';
}
