import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageRepository<T> {
  LocalStorageRepository();

  String get storageKey;

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<List<T>?> getAll() async {
    final SharedPreferences prefs = await _prefs;
    final String? listString = prefs.getString('${storageKey}_list');
    if (listString?.isEmpty ?? true) {
      return null;
    }
    final List<dynamic> list = jsonDecode(listString!) as List<dynamic>;
    final List<T> localList = list
        .map((dynamic e) => castMapToObject(e as Map<String, dynamic>))
        .toList();
    return Future<List<T>?>.value(localList);
  }

  Future<void> saveAll(List<T> objectList) async {
    final SharedPreferences prefs = await _prefs;
    final String encodedJsonString = jsonEncode(objectList);
    await prefs.setString('${storageKey}_list', encodedJsonString);
  }

  Future<T?> saveCurrent(T object) async {
    final SharedPreferences prefs = await _prefs;
    final bool isSaved = await prefs.setString(storageKey, jsonEncode(object));
    return isSaved ? object : null;
  }

  Future<T?> getCurrent() async {
    final SharedPreferences prefs = await _prefs;
    final String? object = prefs.getString(storageKey);
    return object != null ? castMapToObject(jsonDecode(object)) : null;
  }

  T castMapToObject(dynamic object);
}
