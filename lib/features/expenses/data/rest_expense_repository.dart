// lib/features/expenses/data/rest_expense_repository.dart
import '../domain/expense.dart';
import '../domain/expense_repository.dart';
import '../../../core/network/api_client.dart'; 

class RestExpenseRepository implements ExpenseRepository {
  final ApiClient apiClient;

  RestExpenseRepository({required this.apiClient});

  // Placeholder implementation for API mapping 
  List<Expense> _mapResponseToExpenses(dynamic response) {
    if (response is List) {
      return response.map((json) => Expense.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<List<Expense>> fetchAllExpenses() async {
    final response = await apiClient.get('/expenses');
    return _mapResponseToExpenses(response);
  }

  @override
  Future<Expense> createExpense(Expense expense) async {
    final expenseData = expense.toJson();
    final response = await apiClient.post('/expenses', body: expenseData);
    return Expense.fromJson(response); 
  }

  @override
  Future<Expense> updateExpense(Expense expense) async {
    final expenseData = expense.toJson();
    final response = await apiClient.put('/expenses/${expense.id}', body: expenseData);
    return Expense.fromJson(response); 
  }

  @override
  Future<void> deleteExpense(String id) async {
    await apiClient.delete('/expenses/$id');
  }

  @override
  Future<List<Expense>> fetchExpensesByCategory(String category) async {
    final response = await apiClient.get('/expenses?category=$category'); 
    return _mapResponseToExpenses(response);
  }

  @override
  Future<List<Expense>> fetchExpensesByDateRange(DateTime start, DateTime end) async {
    final startString = start.toIso8601String();
    final endString = end.toIso8601String();
    final response = await apiClient.get('/expenses?startDate=$startString&endDate=$endString');
    return _mapResponseToExpenses(response);
  }
}