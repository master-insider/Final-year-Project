import 'package:flutter/material.dart';
import '../../domain/budget_repository.dart';
import '../../data/models/budget_model.dart';

class BudgetProvider with ChangeNotifier {
  final BudgetRepository repository;

  BudgetProvider({required this.repository});

  BudgetModel? _budget;
  bool _isLoading = false;

  BudgetModel? get budget => _budget;
  bool get isLoading => _isLoading;

  Future<void> loadBudget() async {
    _isLoading = true;
    notifyListeners();

    try {
      _budget = await repository.fetchCurrentBudget();
    } catch (e) {
      debugPrint("Load Budget Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createBudget(BudgetModel budget) async {
    try {
      _budget = await repository.createBudget(budget);
      notifyListeners();
    } catch (e) {
      debugPrint("Create Budget Error: $e");
    }
  }

  Future<void> updateBudget(int id, BudgetModel updated) async {
    try {
      _budget = await repository.updateBudget(id, updated);
      notifyListeners();
    } catch (e) {
      debugPrint("Update Budget Error: $e");
    }
  }
}
