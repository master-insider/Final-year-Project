// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'core/network/api_client.dart';
import 'config/app_routes.dart';
import 'config/main_wrapper_screen.dart'; // Assuming this holds the BottomNav

// Auth Feature
import 'features/auth/domain/auth_repository.dart';
import 'features/auth/data/rest_auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';

// Expenses Feature
import 'features/expenses/domain/expense_repository.dart';
import 'features/expenses/data/rest_expense_repository.dart';
import 'features/expenses/presentation/providers/expense_provider.dart';

// Notifications Feature
import 'features/notifications/domain/notification_repository.dart';
import 'features/notifications/data/rest_notification_repository.dart';
import 'features/notifications/presentation/providers/notifications_provider.dart';

// --- (You would add Budget and other feature dependencies here) ---

void main() {
  // 1. Initialize Core Services
  final apiClient = ApiClient(baseUrl: 'https://api.yourbudgetapp.com');

  // 2. Initialize Repositories (Data Layer)
  final authRepository = RestAuthRepository(apiClient: apiClient);
  final expenseRepository = RestExpenseRepository(apiClient: apiClient);
  final notificationRepository = RestNotificationRepository(apiClient: apiClient);
  
  runApp(
    MultiProvider(
      providers: [
        // Core Provider (if any, e.g., Network Status)

        // Auth Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(repository: authRepository)..checkAuthenticationStatus(),
        ),

        // Expense Provider
        ChangeNotifierProvider(
          create: (context) => ExpenseProvider(repository: expenseRepository)..loadExpenses(),
        ),

        // Notification Provider
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(repository: notificationRepository)..loadNotifications(),
        ),
        
        // --- (Budget Provider, etc., would go here) ---
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      // Use the AuthProvider to determine the initial screen
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isLoading) {
            // Show a simple splash/loading screen while checking auth status
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (authProvider.isAuthenticated) {
            return const MainWrapperScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}