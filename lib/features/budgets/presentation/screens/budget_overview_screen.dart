import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import 'budget_setup_screen.dart';

class BudgetOverviewScreen extends StatelessWidget {
  const BudgetOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BudgetProvider>();

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final budget = provider.budget;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Overview"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BudgetSetupScreen()),
              );
            },
          ),
        ],
      ),
      body: budget == null
          ? Center(
              child: ElevatedButton(
                child: const Text("Set Budget"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BudgetSetupScreen(),
                    ),
                  );
                },
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Period: ${budget.period}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text("Limit: Ksh ${budget.limit}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text("Spent: Ksh ${budget.spent}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text("Remaining: Ksh ${budget.limit - budget.spent}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
    );
  }
}
