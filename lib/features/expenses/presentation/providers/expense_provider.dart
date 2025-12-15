// lib/features/expenses/presentation/providers/expense_provider.dart
import 'package:flutter/material.dart';
import '../../domain/expense.dart';
import '../../domain/expense_repository.dart';
import '../../../../core/exceptions/exceptions.dart'; 

class ExpenseProvider extends ChangeNotifier {
  final ExpenseRepository repository;

  // --- State Variables ---
  List<Expense> _expenses = [];
  bool isLoading = false;
  String? errorMessage;

  List<Expense> get expenses => _expenses;

  ExpenseProvider({required this.repository});

  // --- Read (Load) Operations ---

  /// Fetches all expenses and updates the state.
  Future<void> loadExpenses() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _expenses = await repository.fetchAllExpenses();
      // Sort by date (newest first)
      _expenses.sort((a, b) => b.date.compareTo(a.date)); 
    } on AppException catch (e) {
      errorMessage = 'Failed to load expenses: ${e.message}';
      _expenses = [];
    } catch (e) {
      errorMessage = 'An unexpected error occurred.';
      _expenses = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --- Create/Update Operations ---

  /// Handles both creating a new expense (if id is empty) and updating an existing one.
  Future<void> createOrUpdateExpense(Expense expense) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      if (expense.id.isEmpty) {
        // Create new expense
        final newExpense = await repository.createExpense(expense);
        _expenses.add(newExpense);
        
      } else {
        // Update existing expense
        final updatedExpense = await repository.updateExpense(expense);
        
        // Find and replace the old expense in the local list
        final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
        if (index != -1) {
          _expenses[index] = updatedExpense;
        }
      }
      
      // Ensure the list is sorted after any modification
      _expenses.sort((a, b) => b.date.compareTo(a.date)); 

    } on AppException catch (e) {
      errorMessage = 'Failed to save expense: ${e.message}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --- Delete Operation ---

  /// Deletes an expense by ID.
  Future<void> deleteExpense(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      await repository.deleteExpense(id);
      
      // Remove from local list
      _expenses.removeWhere((e) => e.id == id);
      
    } on AppException catch (e) {
      errorMessage = 'Failed to delete expense: ${e.message}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}