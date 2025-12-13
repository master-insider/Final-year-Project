
abstract class BudgetRepository {
  // Method signatures that the data layer must implement
  Future<List<Budget>> fetchBudgets();
  Future<void> saveBudget(Budget budget);
}