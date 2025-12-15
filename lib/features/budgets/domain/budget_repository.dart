// lib/features/budgets/domain/budget_repository.dart
import 'budget.dart';

abstract class BudgetRepository {
  Future<List<Budget>> fetchAllBudgets();
  Future<Budget> fetchBudgetById(String id);

  Future<Budget> createBudget(Budget budget); 
  Future<Budget> updateBudget(Budget budget); 
  Future<void> deleteBudget(String id);
}