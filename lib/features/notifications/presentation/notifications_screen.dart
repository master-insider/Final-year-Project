// lib/features/notifications/presentation/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/notifications_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false).markAllAsRead();
            },
            tooltip: 'Mark All Read',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false).loadNotifications();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }
          if (provider.notifications.isEmpty) {
            return const Center(child: Text('You have no notifications.'));
          }

          return ListView.builder(
            itemCount: provider.notifications.length,
            itemBuilder: (context, index) {
              final notification = provider.notifications[index];
              return Dismissible(
                key: ValueKey(notification.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  provider.deleteNotification(notification.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${notification.title} dismissed')));
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  leading: Icon(
                    notification.isRead ? Icons.email_outlined : Icons.email,
                    color: notification.isRead ? Colors.grey : Theme.of(context).primaryColor,
                  ),
                  title: Text(notification.title, style: TextStyle(fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold)),
                  subtitle: Text(notification.message),
                  trailing: Text('${notification.timestamp.hour}:${notification.timestamp.minute}'),
                  onTap: () {
                    if (!notification.isRead) {
                      provider.markNotificationAsRead(notification.id);
                    }
                    // Implement navigation to related entity here (e.g., Budgets/Expenses)
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}