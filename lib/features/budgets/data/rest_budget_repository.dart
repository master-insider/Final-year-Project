// lib/features/budgets/data/rest_budget_repository.dart
import '../domain/budget.dart';
import '../domain/budget_repository.dart';
import '../../../core/network/api_client.dart'; 

class RestBudgetRepository implements BudgetRepository {
  final ApiClient apiClient;

  RestBudgetRepository({required this.apiClient});

  List<Budget> _mapResponseToBudgets(dynamic response) {
    if (response is List) {
      return response.map((json) => Budget.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<List<Budget>> fetchAllBudgets() async {
    final response = await apiClient.get('/budgets');
    // return _mapResponseToBudgets(response);
    
    // Placeholder return:
    return [
      Budget(id: 'b1', category: 'Food', limit: 500.0, currentSpend: 400.0, startDate: DateTime.now().subtract(const Duration(days: 15)), endDate: DateTime.now().add(const Duration(days: 15))),
      Budget(id: 'b2', category: 'Housing', limit: 1200.0, currentSpend: 1300.0, startDate: DateTime.now().subtract(const Duration(days: 30)), endDate: DateTime.now().add(const Duration(days: 0))),
    ];
  }
  
  @override
  Future<Budget> fetchBudgetById(String id) async {
    final response = await apiClient.get('/budgets/$id');
    return Budget.fromJson(response);
  }

  @override
  Future<Budget> createBudget(Budget budget) async {
    final response = await apiClient.post('/budgets', body: budget.toJson());
    return Budget.fromJson(response);
  }

  @override
  Future<Budget> updateBudget(Budget budget) async {
    final response = await apiClient.put('/budgets/${budget.id}', body: budget.toJson());
    return Budget.fromJson(response);
  }

  @override
  Future<void> deleteBudget(String id) async {
    await apiClient.delete('/budgets/$id');
  }
}