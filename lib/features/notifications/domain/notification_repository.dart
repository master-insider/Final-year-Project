// lib/features/notifications/domain/notification_repository.dart

import 'notification.dart';

abstract class NotificationRepository {
  
  // Fetch a list of all notifications (read and unread)
  Future<List<AppNotification>> fetchNotifications();

  // Update a single notification status to read
  Future<void> markNotificationAsRead(String id);

  // Update the status of all current notifications to read
  Future<void> markAllAsRead();

  // Permanently remove a notification
  Future<void> deleteNotification(String id);
  
  // Optional: Fetch only unread count/list (Could also be handled in the Provider)
  // Future<int> getUnreadCount(); 
}