import 'package:flutter/material.dart';
import '../../data/models/expense_model.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseDetailsScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(expense.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Category: ${expense.category}"),
            Text("Amount: Ksh ${expense.amount}"),
            Text("Date: ${expense.date.toLocal()}"),
            const SizedBox(height: 15),
            Text("Notes: ${expense.notes ?? 'none'}"),
          ],
        ),
      ),
    );
  }
}
