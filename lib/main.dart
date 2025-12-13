import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/config/app_routes.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/expenses/presentation/providers/expense_provider.dart';
import 'features/budgets/presentation/providers/budget_provider.dart';
import 'features/insights/presentation/providers/insights_provider.dart';
import 'features/profile/presentation/providers/profile_provider.dart';

// Import repositories
import 'features/expenses/domain/expense_repository.dart';
import 'features/budgets/domain/budget_repository.dart';
import 'features/insights/domain/insights_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider.create()..loadFromStorage(),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(
            repository: ExpenseRepository(api: null), // Pass a repository instance
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => BudgetProvider(
            repository: BudgetRepository(api: null), // Pass a repository instance
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => InsightsProvider(
            repository: InsightsRepository(api: null), // Pass a repository instance
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}