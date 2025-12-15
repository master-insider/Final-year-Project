// lib/services/local_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

/// A simple wrapper for SharedPreferences to persist non-sensitive user settings 
/// and application flags.
class LocalStorageService {
  final SharedPreferences _prefs;

  // Key names
  static const String _notifEnabledKey = 'notif_enabled';
  static const String _dailySummaryTimeKey = 'daily_summary_time'; // Stored as String "HH:MM"

  LocalStorageService(this._prefs);

  // --- Notification Enablement ---

  /// Reads the notification enabled status.
  /// Returns true if enabled, false if disabled, or false if never set.
  bool isNotificationsEnabled() {
    return _prefs.getBool(_notifEnabledKey) ?? false;
  }

  /// Sets the notification enabled status.
  Future<bool> setNotificationsEnabled(bool value) async {
    return await _prefs.setBool(_notifEnabledKey, value);
  }

  // --- Daily Summary Time ---

  /// Reads the daily summary time (e.g., "08:30").
  /// Returns null if not set.
  String? getDailySummaryTime() {
    return _prefs.getString(_dailySummaryTimeKey);
  }

  /// Sets the daily summary time (must be in "HH:MM" format).
  Future<bool> setDailySummaryTime(String time) async {
    return await _prefs.setString(_dailySummaryTimeKey, time);
  }
  
  // --- General Operations ---
  
  /// Clears all non-sensitive stored data (use cautiously).
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}