import 'package:cabo/core/local_storage_service/local_storage_repository.dart';

class LocalDesignRepository extends LocalStorageRepository<String> {
  @override
  String castMapToObject(dynamic object) {
    return object as String;
  }

  @override
  String get storageKey => 'design_theme';
}
