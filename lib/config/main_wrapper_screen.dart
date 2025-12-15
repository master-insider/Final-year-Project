// lib/config/main_wrapper_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // Assuming you might use SVG icons

// Import all main screens that go in the Bottom Nav Bar
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/expenses/presentation/expense_screen.dart';
import '../features/budgets/presentation/budget_overview_screen.dart';
import '../features/insights/presentation/insights_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/notifications/presentation/providers/notifications_provider.dart';
import '../features/profile/presentation/profile_screen.dart'; // Added Profile for completeness

class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _currentIndex = 0;

  // List of screens corresponding to the bottom navigation items
  final List<Widget> _screens = const [
    DashboardScreen(),
    ExpenseScreen(),
    BudgetOverviewScreen(),
    InsightsScreen(),
    ReportsScreen(),
    // We can reserve one button for the Profile, or keep the profile separate
    // For now, let's include Profile as the last tab for easy access.
    ProfileScreen(), 
  ];

  @override
  void initState() {
    super.initState();
    
    // Immediately load any initial data needed globally, such as notifications.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // NOTE: This assumes the NotificationProvider is initialized and available
      Provider.of<NotificationProvider>(context, listen: false).loadNotifications();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the NotificationProvider for the unread count badge
    final notificationProvider = context.watch<NotificationProvider>();
    final unreadCount = notificationProvider.unreadCount;
    
    // We use an IndexedStack to keep the state of each screen alive
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Expenses',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budgets',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Insights',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            // Example of using a badge for notifications or profile alerts
            icon: Stack(
              children: [
                const Icon(Icons.person),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                      child: Text(
                        unreadCount > 99 ? '99+' : '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}