import 'package:flutter/material.dart';
import '../../domain/expense_repository.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseRepository repository;
  
  ExpenseProvider({required this.repository});
  
  Future<void> loadExpenses() async {
    // Implementation
  }
}