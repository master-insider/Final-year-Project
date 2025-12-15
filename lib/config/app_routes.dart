import 'package:flutter/material.dart';

// Import all main screens from their feature folders
import '../features/dashboard/presentation/dashboard_screen.dart'; 
import '../features/expenses/presentation/expense_screen.dart';
import '../features/budgets/presentation/budget_overview_screen.dart';
import '../features/insights/presentation/insights_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/profile/presentation/profile_screen.dart';

// Import detail/setup screens
import '../features/budgets/presentation/budget_setup_screen.dart';
import '../features/expenses/presentation/expense_create_screen.dart';

// --- NEW AUTH IMPORTS ---
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
// ------------------------

import 'main_wrapper_screen.dart';

class AppRoutes {
  // Main Navigation Routes (Used in BottomNavigationBar)
  static const String home = '/'; 
  static const String dashboard = '/dashboard'; 
  static const String expenses = '/expenses';
  static const String budgets = '/budgets';
  static const String insights = '/insights';
  static const String reports = '/reports';
  static const String notifications = '/notifications';

  // Sub-Routes / Detail / Setup Screens
  static const String profile = '/profile';
  static const String expenseCreate = '/expenses/create';
  static const String budgetSetup = '/budgets/setup';
  
  // --- NEW AUTH ROUTES ---
  static const String login = '/login'; 
  static const String register = '/register';
  // -----------------------

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // --- Main Screens ---
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainWrapperScreen());
      
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen()); 

      case AppRoutes.expenses:
        return MaterialPageRoute(builder: (_) => const ExpenseScreen());

      case AppRoutes.budgets:
        return MaterialPageRoute(builder: (_) => const BudgetOverviewScreen());

      case AppRoutes.insights:
        return MaterialPageRoute(builder: (_) => const InsightsScreen());
        
      case AppRoutes.reports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());

      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      // --- Detail/Setup Screens ---

      case AppRoutes.expenseCreate:
        // Correctly casts arguments to String? for expenseId
        final expenseId = settings.arguments as String?; 
        return MaterialPageRoute(
          builder: (_) => ExpenseCreateScreen(expenseId: expenseId),
        );
      
      case AppRoutes.budgetSetup:
        // Correctly casts arguments to String? for budgetId
        final budgetId = settings.arguments as String?; 
        return MaterialPageRoute(
          // FIX: Removed 'key: settings.key' as RouteSettings does not expose the key.
          builder: (_) => BudgetSetupScreen(budgetId: budgetId), 
        );

      // --- NEW AUTH ROUTES HANDLER ---
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      // -------------------------------

      // --- Default/Error Route ---
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('404: Route Not Found'),
        ),
      ),
    );
  }
}