import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/budget_model.dart';
import '../providers/budget_provider.dart';

class BudgetSetupScreen extends StatefulWidget {
  const BudgetSetupScreen({super.key});

  @override
  State<BudgetSetupScreen> createState() => _BudgetSetupScreenState();
}

class _BudgetSetupScreenState extends State<BudgetSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final limitCtrl = TextEditingController();
  String period = "Monthly";

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BudgetProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Setup Budget")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: limitCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Budget Limit"),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            DropdownButtonFormField(
              value: period,
              decoration: const InputDecoration(labelText: "Period"),
              items: ["Monthly", "Weekly", "Custom"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                setState(() => period = v!);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  provider.createBudget(
                    BudgetModel(
                      limit: double.parse(limitCtrl.text),
                      period: period,
                      startDate: DateTime.now(),
                      endDate: DateTime.now().add(const Duration(days: 30)),
                      spent: 0,
                    ),
                  );

                  Navigator.pop(context);
                }
              },
              child: const Text("Save Budget"),
            )
          ]),
        ),
      ),
    );
  }
}
