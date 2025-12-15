// lib/features/budgets/presentation/budget_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../budgets/domain/budget.dart';
import '../presentation/providers/budget_provider.dart';

class BudgetSetupScreen extends StatefulWidget {
  // budgetId is optional: null for creation, string for editing
  final String? budgetId;
  
  const BudgetSetupScreen({super.key, this.budgetId});

  @override
  State<BudgetSetupScreen> createState() => _BudgetSetupScreenState();
}

class _BudgetSetupScreenState extends State<BudgetSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  
  // State for the dates
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  
  // Holds the original budget object if we are editing
  Budget? _initialBudget;
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    _isEditing = widget.budgetId != null;
    
    // If editing, try to pre-fill the form data
    if (_isEditing) {
      // NOTE: For a complex app, you'd fetch the budget by ID here
      // For this example, we assume the data is available in the provider or fetched.
      _loadInitialBudget();
    }
  }

  void _loadInitialBudget() {
    final provider = Provider.of<BudgetProvider>(context, listen: false);
    // Find the budget in the current provider state
    _initialBudget = provider.budgets.firstWhere(
      (b) => b.id == widget.budgetId,
      // If not found (API issue), treat it as a new budget
      orElse: () => Budget(
        id: '', // Empty ID signifies a new budget if found
        category: '', limit: 0, currentSpend: 0, 
        startDate: DateTime.now(), endDate: DateTime.now().add(const Duration(days: 30))
      )
    );
    
    if (_initialBudget != null && _initialBudget!.id.isNotEmpty) {
      _categoryController.text = _initialBudget!.category;
      _limitController.text = _initialBudget!.limit.toStringAsFixed(2);
      _startDate = _initialBudget!.startDate;
      _endDate = _initialBudget!.endDate;
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final provider = Provider.of<BudgetProvider>(context, listen: false);
      
      final newOrUpdatedBudget = Budget(
        id: widget.budgetId ?? '', // Retain ID if editing, empty if new
        category: _categoryController.text.trim(),
        limit: double.parse(_limitController.text),
        // When creating, currentSpend is 0. When editing, keep the original spend.
        currentSpend: _initialBudget?.currentSpend ?? 0.0, 
        startDate: _startDate,
        endDate: _endDate,
      );
      
      await provider.createOrUpdateBudget(newOrUpdatedBudget);
      
      if (provider.errorMessage == null) {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage!)),
        );
      }
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Budget' : 'Create New Budget'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Input
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category (e.g., Food, Travel)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Category is required' : null,
              ),
              const SizedBox(height: 20),
              
              // Limit Input
              TextFormField(
                controller: _limitController,
                decoration: const InputDecoration(
                  labelText: 'Budget Limit (\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Limit is required';
                  if (double.tryParse(value) == null) return 'Must be a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Date Pickers
              Text('Budget Period', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              
              // Start Date Row
              ListTile(
                title: const Text('Start Date'),
                subtitle: Text('${_startDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(true),
              ),
              
              // End Date Row
              ListTile(
                title: const Text('End Date'),
                subtitle: Text('${_endDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(false),
              ),
              
              const SizedBox(height: 40),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: Provider.of<BudgetProvider>(context).isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    Provider.of<BudgetProvider>(context).isLoading
                        ? 'Saving...'
                        : (_isEditing ? 'Save Changes' : 'Create Budget'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}