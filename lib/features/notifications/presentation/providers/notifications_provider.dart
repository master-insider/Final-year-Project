// lib/features/notifications/presentation/providers/notification_provider.dart
import 'package:flutter/material.dart';
import '../../domain/notification.dart';
import '../../domain/notification_repository.dart';
import '../../../../core/exceptions/exceptions.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository repository;

  // --- State Variables ---
  List<AppNotification> _notifications = [];
  bool isLoading = false;
  String? errorMessage;

  List<AppNotification> get notifications => _notifications;
  List<AppNotification> get unreadNotifications => 
      _notifications.where((n) => !n.isRead).toList();
  int get unreadCount => unreadNotifications.length;

  NotificationProvider({required this.repository});

  // --- Core Methods ---

  Future<void> loadNotifications() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _notifications = await repository.fetchNotifications();
    } on AppException catch (e) {
      errorMessage = 'Failed to load notifications: ${e.message}';
      _notifications = [];
    } catch (e) {
      errorMessage = 'An unexpected error occurred.';
      _notifications = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markNotificationAsRead(String id) async {
    try {
      await repository.markNotificationAsRead(id);
      
      // Update local state without a full reload
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
      }
    } on AppException catch (e) {
      errorMessage = 'Failed to mark as read: ${e.message}';
      notifyListeners();
    }
  }
  
  Future<void> markAllAsRead() async {
    try {
      await repository.markAllAsRead();
      
      // Update all notifications in local state
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
      notifyListeners();
    } on AppException catch (e) {
      errorMessage = 'Failed to mark all as read: ${e.message}';
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await repository.deleteNotification(id);
      
      // Remove from local state
      _notifications.removeWhere((n) => n.id == id);
      notifyListeners();
    } on AppException catch (e) {
      errorMessage = 'Failed to delete: ${e.message}';
      notifyListeners();
    }
  }
}