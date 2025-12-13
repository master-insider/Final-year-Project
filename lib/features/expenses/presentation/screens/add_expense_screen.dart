import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/expense_model.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  String category = "General";
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ExpenseProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              DropdownButtonFormField(
                value: category,
                items: ["General", "Food", "Transport", "Bills", "Other"]
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  setState(() => category = v!);
                },
              ),
              TextFormField(
                controller: notesCtrl,
                decoration: const InputDecoration(labelText: "Notes (optional)"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Save"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    provider.addExpense(
                      ExpenseModel(
                        title: titleCtrl.text,
                        category: category,
                        amount: double.parse(amountCtrl.text),
                        date: selectedDate,
                        notes: notesCtrl.text,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
