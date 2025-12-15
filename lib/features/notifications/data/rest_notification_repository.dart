import '../domain/notification.dart'; // Corrected import for AppNotification and NotificationType
import '../domain/notification_repository.dart';
import '../../../core/network/api_client.dart'; 
import 'dart:convert';

class RestNotificationRepository implements NotificationRepository {
  final ApiClient apiClient;

  RestNotificationRepository({required this.apiClient});

  @override
  Future<List<AppNotification>> fetchNotifications() async {
    final response = await apiClient.get('/notifications');
    
    // --- Actual Mapping Logic (Replace placeholder later) ---
    // final List<dynamic> jsonList = jsonDecode(response.body);
    // return jsonList.map((json) => AppNotification.fromJson(json)).toList();

    // Placeholder return (FIXED: Using NotificationType enum)
    return [
      AppNotification(
        id: 'n1', title: 'Budget Alert', message: 'You spent 90% of your Food budget.', 
        timestamp: DateTime.now().subtract(const Duration(hours: 1)), 
        isRead: false, 
        type: NotificationType.budgetAlert, // FIXED: Using enum
        relatedEntityId: 'b-food-id',
      ),
      AppNotification(
        id: 'n2', title: 'Report Ready', message: 'Your monthly report is available.', 
        timestamp: DateTime.now().subtract(const Duration(days: 1)), 
        isRead: true, 
        type: NotificationType.systemUpdate, // FIXED: Using enum
      ),
    ];
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    // API call to update the status on the server
    await apiClient.patch('/notifications/$id/read', body: {'isRead': true});
  }
  
  @override
  Future<void> markAllAsRead() async {
    // API call to mark all notifications as read
    await apiClient.post('/notifications/mark-all-read');
  }

  @override
  Future<void> deleteNotification(String id) async {
    await apiClient.delete('/notifications/$id');
  }
}