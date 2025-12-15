// lib/features/expenses/domain/expense_repository.dart
import 'expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> fetchAllExpenses(); 
  Future<List<Expense>> fetchExpensesByDateRange(DateTime start, DateTime end);
  Future<List<Expense>> fetchExpensesByCategory(String category);

  Future<Expense> createExpense(Expense expense); 
  Future<Expense> updateExpense(Expense expense); 
  Future<void> deleteExpense(String id);
}