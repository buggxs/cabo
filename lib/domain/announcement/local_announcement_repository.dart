import 'package:shared_preferences/shared_preferences.dart';

class LocalAnnouncementRepository {
  static const String _lastSeenAnnouncementIdKey = 'announcement_last_seen_id';
  static const String _appStartCountKey = 'announcement_app_start_count';

  Future<String?> getLastSeenAnnouncementId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSeenAnnouncementIdKey);
  }

  Future<void> saveLastSeenAnnouncementId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSeenAnnouncementIdKey, id);
  }

  /// Increments the app start counter and returns the new value.
  Future<int> incrementAppStartCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int count = (prefs.getInt(_appStartCountKey) ?? 0) + 1;
    await prefs.setInt(_appStartCountKey, count);
    return count;
  }
}
