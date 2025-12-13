// Notification service: local scheduling + push (Firebase Messaging) handling.
// Caller should call NotificationsService().init() from main() after WidgetsFlutterBinding.ensureInitialized()
// and (if using Firebase) after Firebase.initializeApp().

import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:path_provider/path_provider.dart';

class NotificationsService {
  NotificationsService._privateConstructor();
  static final NotificationsService _instance = NotificationsService._privateConstructor();
  factory NotificationsService() => _instance;

  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // channel for Android
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'default_channel', // id
    'Default Notifications', // title
    description: 'General notifications for the app',
    importance: Importance.high,
  );

  Future<void> init({bool enablePush = true}) async {
    // initialize timezone package
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));

    // Local notifications initialization
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher'); // ensure launcher icon exists
    const iosInit = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _local.initialize(initSettings, onDidReceiveNotificationResponse: _onLocalNotificationClicked);

    // Create Android channel (for api >= 26)
    if (Platform.isAndroid) {
      await _local
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }

    // Firebase Cloud Messaging (Push)
    if (enablePush) {
      // Request permissions on iOS
      if (Platform.isIOS) {
        await _fcm.requestPermission();
      }

      // foreground handler
      FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
        _handleRemoteMessageForeground(msg);
      });

      // background & terminated message handling requires configuration in native code
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
        debugPrint('onMessageOpenedApp: ${msg.data}');
        // You can route user to a screen based on payload here
      });

      // get initial message when app opened from terminated state
      // handled by caller if needed: FirebaseMessaging.instance.getInitialMessage()
    }
  }

  // Show a simple immediate local notification
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
    );

    final iOSDetails = DarwinNotificationDetails();

    await _local.show(
      id,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iOSDetails),
      payload: payload,
    );
  }

  // Schedule daily notification at HH:mm (24-hour)
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _local.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_summary',
    );
  }

  Future<void> cancelNotification(int id) async {
    await _local.cancel(id);
  }

  Future<void> cancelAll() async {
    await _local.cancelAll();
  }

  // Handle foreground FCM messages and convert to local notifications
  void _handleRemoteMessageForeground(RemoteMessage message) {
    final title = message.notification?.title ?? 'Notification';
    final body = message.notification?.body ?? message.data['body'] ?? '';
    showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      payload: message.data['payload']?.toString(),
    );
  }

  // Called when user taps a local notification
  void _onLocalNotificationClicked(NotificationResponse response) {
    debugPrint('local notification clicked: ${response.payload}');
    // handle navigation via payload if desired (expose a stream or callback)
  }

  /// Register FCM token - you'll send this token to your backend for push targeting
  Future<String?> getFcmToken() async {
    try {
      final token = await _fcm.getToken();
      return token;
    } catch (e) {
      debugPrint('getFcmToken error: $e');
      return null;
    }
  }

  /// Utility: save a small file in temporary directory (if needed for attachments)
  Future<String> writeTempFile(String filename, List<int> bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }
}
