import 'package:flutter/material.dart';
import '../../domain/dashboard_repository.dart';
import '../../domain/dashboard_stats.dart'; // Assuming this is your stats model
import '../../../expenses/domain/expense.dart'; // Assuming you reuse the Expense model for recent expenses

// Provider only depends on the abstract contract
class DashboardProvider extends ChangeNotifier {
  final DashboardRepository repository;

  DashboardProvider({required this.repository});

  // --- State Variables ---
  DashboardStats? stats;
  List<Expense> recentExpenses = [];
  bool isLoading = false;
  String? errorMessage;

  // --- Methods ---

  Future<void> loadDashboardData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // 1. Fetch Stats and Recent Expenses concurrently
      final statsFuture = repository.fetchDashboardStats();
      final expensesFuture = repository.fetchRecentExpenses();

      final results = await Future.wait([statsFuture, expensesFuture]);

      // 2. Update state with results
      stats = results[0] as DashboardStats;
      recentExpenses = results[1] as List<Expense>;
      
    } catch (e) {
      // Handle any error from the repository calls
      errorMessage = 'Failed to load dashboard data: $e';
      stats = null; // Clear previous data on error
      recentExpenses = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // You can add more methods here, like refreshData() or setDateRange().
}