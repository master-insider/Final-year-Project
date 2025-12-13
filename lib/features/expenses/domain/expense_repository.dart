// lib/features/expenses/domain/expense_repository.dart (The Contract)

abstract class ExpenseRepository {
  Future<List<Expense>> fetchExpensesByDateRange(DateTime start, DateTime end);
  Future<List<Expense>> fetchExpensesByCategory(String category);
  Future<void> createExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
}