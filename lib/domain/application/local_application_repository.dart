import 'package:cabo/core/local_storage_service/local_storage_repository.dart';

class LocalApplicationRepository extends LocalStorageRepository<bool> {
  @override
  bool castMapToObject(dynamic object) {
    return object;
  }

  @override
  String get storageKey => 'application';
}
