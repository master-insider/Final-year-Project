import '../domain/dashboard_stats.dart'; // Import the stats model
import '../../expenses/domain/expense.dart'; // Import the Expense model

// The abstract contract (Interface)
abstract class DashboardRepository {
  // Method to fetch aggregated statistics
  // Changed from getStats() to match the Provider's expectation
  Future<DashboardStats> fetchDashboardStats();
  
  // Method to fetch recent transaction list
  // Changed from getRecentExpenses() to match the Provider's expectation
  Future<List<Expense>> fetchRecentExpenses();
}