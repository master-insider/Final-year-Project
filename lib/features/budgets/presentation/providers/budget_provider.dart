// lib/features/budgets/presentation/providers/budget_provider.dart
import 'package:flutter/material.dart';
import '../../domain/budget.dart';
import '../../domain/budget_repository.dart';
import '../../../../core/exceptions/exceptions.dart'; 

class BudgetProvider extends ChangeNotifier {
  final BudgetRepository repository;
  
  List<Budget> _budgets = [];
  bool isLoading = false;
  String? errorMessage;
  
  List<Budget> get budgets => _budgets;

  BudgetProvider({required this.repository});

  Future<void> loadBudgets() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _budgets = await repository.fetchAllBudgets();
    } on AppException catch (e) {
      errorMessage = 'Failed to load budgets: ${e.message}';
      _budgets = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createOrUpdateBudget(Budget budget) async {
    try {
      if (budget.id.isEmpty) {
        await repository.createBudget(budget);
      } else {
        await repository.updateBudget(budget);
      }
      // Reload list after action
      await loadBudgets(); 
    } on AppException catch (e) {
      errorMessage = 'Failed to save budget: ${e.message}';
      notifyListeners();
    }
  }
}