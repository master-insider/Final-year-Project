import 'package:flutter/material.dart';
import '../../../services/local_storage.dart';
import '../../../services/notifications_service.dart';

class NotificationsProvider with ChangeNotifier {
  final LocalStorageService _local = LocalStorageService();
  final NotificationsService _notif = NotificationsService();

  bool _enabled = true;
  String _dailyTime = '08:00'; // default

  bool get enabled => _enabled;
  String get dailyTime => _dailyTime;

  NotificationsProvider() {
    _load();
  }

  Future<void> _load() async {
    _enabled = await _local.isNotificationsEnabled();
    _dailyTime = (await _local.getDailySummaryTime()) ?? _dailyTime;
    notifyListeners();
  }

  Future<void> toggleEnabled(bool value) async {
    _enabled = value;
    await _local.setNotificationsEnabled(value);
    if (!value) {
      await _notif.cancelAll();
    } else {
      // schedule default daily summary
      final parts = _dailyTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      await scheduleDailySummary(hour, minute);
    }
    notifyListeners();
  }

  Future<void> scheduleDailySummary(int hour, int minute) async {
    _dailyTime = '${hour.toString().padLeft(2,'0')}:${minute.toString().padLeft(2,'0')}';
    await _local.setDailySummaryTime(_dailyTime);

    // Use id 1000 for daily summary so we can cancel/replace easily
    await _notif.scheduleDailyNotification(
      id: 1000,
      title: 'Daily Spending Summary',
      body: 'Tap to view today\'s spending summary.',
      hour: hour,
      minute: minute,
    );
    notifyListeners();
  }

  /// Initialize notification service (call from main after Firebase init if using push)
  Future<void> initNotificationService({bool enablePush = true}) async {
    await _notif.init(enablePush: enablePush);
  }

  Future<String?> getFcmToken() async {
    return await _notif.getFcmToken();
  }

  Future<void> showTestNotification() async {
    await _notif.showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'Test Notification',
      body: 'This is a test notification.',
    );
  }
}
