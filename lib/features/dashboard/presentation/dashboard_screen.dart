// lib/features/dashboard/presentation/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../notifications/presentation/providers/notifications_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Welcome back, ${authProvider.currentUser?.fullName ?? 'User'}'),
            floating: true,
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      // Navigate to notifications screen
                    },
                  ),
                  if (notificationProvider.unreadCount > 0)
                    Positioned(
                      right: 11,
                      top: 11,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                        child: Text(
                          '${notificationProvider.unreadCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ],
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  authProvider.logoutUser();
                  // AppRoutes handles redirect to LoginScreen via the Consumer in main.dart
                },
              ),
            ],
          ),
          
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  // --- Placeholder for Quick Spending Card ---
                  Card(child: ListTile(title: Text('Total Spent This Month'), trailing: Text('\$1,850.00'))),
                  SizedBox(height: 20),
                  Text('Budget Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  // --- Placeholder for Budget Gauges ---
                  Card(child: ListTile(title: Text('Food Budget'), trailing: Text('80% Used'))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}