// lib/features/expenses/presentation/expense_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/providers/expense_provider.dart';
import '../../../config/app_routes.dart'; // Import the correct routes

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We assume the ExpenseProvider handles loading the list of expenses on init
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              expenseProvider.loadExpenses();
            },
            tooltip: 'Refresh Expenses',
          ),
        ],
      ),
      
      // Floating Action Button to navigate to the creation screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // FIX: Use the correct static constant name 'expenseCreate'
          // from the AppRoutes class.
          Navigator.of(context).pushNamed(AppRoutes.expenseCreate); 
        },
        child: const Icon(Icons.add),
      ),
      
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }
          if (provider.expenses.isEmpty) {
            return const Center(child: Text('No expenses recorded. Tap + to add one.'));
          }

          return ListView.builder(
            itemCount: provider.expenses.length,
            itemBuilder: (context, index) {
              final expense = provider.expenses[index];
              return ListTile(
                leading: const Icon(Icons.payments),
                title: Text(expense.description),
                subtitle: Text(expense.category),
                trailing: Text(
                  '-\$${expense.amount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Navigate to the creation/edit screen, passing the expense ID for editing
                  Navigator.of(context).pushNamed(AppRoutes.expenseCreate, arguments: expense.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}