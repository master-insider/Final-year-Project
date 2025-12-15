// lib/features/dashboard/data/rest_dashboard_repository.dart

import '../domain/dashboard_repository.dart'; 
import '../../../core/network/api_client.dart'; // Re-use your core client
import '../domain/dashboard_stats.dart'; 
import '../../expenses/domain/expense.dart'; // Assuming you have an Expense model

// This concrete class implements the abstract contract
class RestDashboardRepository implements DashboardRepository {
  // Inject the core ApiClient service
  final ApiClient apiClient; 

  RestDashboardRepository({required this.apiClient});

  // METHOD NAME CHANGED TO MATCH ABSTRACT CONTRACT
  @override
  Future<DashboardStats> fetchDashboardStats() async {
    final res = await apiClient.get('/dashboard/stats');
    // You must implement the logic to decode and map res.body to DashboardStats.
    // Example: return DashboardStats.fromJson(jsonDecode(res.body));
    
    // Placeholder return:
    return DashboardStats(totalSpent: 1500.0, income: 4000.0, budgetRemaining: 2500.0); 
  }

  // METHOD NAME CHANGED TO MATCH ABSTRACT CONTRACT
  @override
  Future<List<Expense>> fetchRecentExpenses() async {
    final res = await apiClient.get('/dashboard/recent-expenses');
    // You must decode and map the list of items to List<Expense>.
    
    // Placeholder return:
    return [ 
      // Example Placeholder to align with the DashboardScreen display:
      Expense(id: '1', amount: 45.0, category: 'Food', description: 'Coffee', date: DateTime.now()),
      Expense(id: '2', amount: 90.0, category: 'Transport', description: 'Gas refill', date: DateTime.now()),
    ]; 
  }
}