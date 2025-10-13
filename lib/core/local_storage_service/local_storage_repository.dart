import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageRepository<T> {
  LocalStorageRepository();

  /// storage key to find the stored value
  String get storageKey;

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  /// Will return a list of all local saved objects from type [T]
  /// It search for the [storageKey]
  Future<List<T>?> getAll() async {
    final SharedPreferences prefs = await _prefs;
    final String? listString = prefs.getString('${storageKey}_list');
    if (listString?.isEmpty ?? true) {
      return null;
    }
    final List<dynamic> list = jsonDecode(listString!);
    final List<T> localList = list
        .map((dynamic e) => castMapToObject(e as Map<String, dynamic>))
        .toList();
    return Future<List<T>?>.value(localList);
  }

  /// Will save a list of objects from type [T]
  /// Will be saved under "[storageKey]_list"
  Future<void> saveAll(List<T> objectList) async {
    final SharedPreferences prefs = await _prefs;
    String encodedJsonString = jsonEncode(objectList);
    prefs.setString('${storageKey}_list', encodedJsonString);
  }

  Future<T?> saveCurrent(T object) async {
    final SharedPreferences prefs = await _prefs;
    bool success = await prefs.setString(storageKey, jsonEncode(object));
    return success ? object : null;
  }

  /// Retrieves the currently saved object under the [storageKey]
  Future<T?> getCurrent() async {
    final SharedPreferences prefs = await _prefs;
    String? object = prefs.getString(storageKey);
    return object != null ? castMapToObject(jsonDecode(object)) : null;
  }

  /// Cast generic to Object
  T castMapToObject(dynamic object);
}
