// lib/features/budgets/presentation/budget_overview_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/budget_provider.dart';
import '../../../config/app_routes.dart';

class BudgetOverviewScreen extends StatelessWidget {
  const BudgetOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to setup screen for creation (passing null ID)
              Navigator.of(context).pushNamed(AppRoutes.budgetSetup);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<BudgetProvider>(context, listen: false).loadBudgets();
            },
          ),
        ],
      ),
      body: Consumer<BudgetProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }
          if (provider.budgets.isEmpty) {
            return const Center(child: Text('No budgets defined. Tap + to create one.'));
          }

          return ListView.builder(
            itemCount: provider.budgets.length,
            itemBuilder: (context, index) {
              final budget = provider.budgets[index];
              final percentUsed = (budget.currentSpend / budget.limit).clamp(0.0, 1.0);
              final color = percentUsed >= 0.8 ? Colors.red : (percentUsed > 1.0 ? Colors.deepOrange : Colors.green);
              
              return ListTile(
                title: Text(budget.category),
                subtitle: LinearProgressIndicator(
                  value: percentUsed,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                trailing: Text('\$${budget.currentSpend.toStringAsFixed(2)} / \$${budget.limit.toStringAsFixed(2)}'),
                onTap: () {
                  // Navigate to setup screen for editing (passing ID)
                  Navigator.of(context).pushNamed(AppRoutes.budgetSetup, arguments: budget.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}