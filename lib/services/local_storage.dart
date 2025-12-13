// simple wrapper for SharedPreferences to persist small user settings
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _notifEnabledKey = 'notif_enabled';
  static const _dailySummaryKey = 'daily_summary_time'; // stored as string "HH:mm"

  Future<SharedPreferences> _prefs() async => await SharedPreferences.getInstance();

  Future<bool> isNotificationsEnabled() async {
    final p = await _prefs();
    return p.getBool(_notifEnabledKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final p = await _prefs();
    await p.setBool(_notifEnabledKey, value);
  }

  Future<String?> getDailySummaryTime() async {
    final p = await _prefs();
    return p.getString(_dailySummaryKey);
  }

  Future<void> setDailySummaryTime(String hhmm) async {
    final p = await _prefs();
    await p.setString(_dailySummaryKey, hhmm);
  }

  // Generic helpers
  Future<void> setString(String key, String value) async {
    final p = await _prefs();
    await p.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final p = await _prefs();
    return p.getString(key);
  }
}
