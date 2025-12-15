// lib/features/expenses/presentation/expense_create_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../expenses/domain/expense.dart';
import '../presentation/providers/expense_provider.dart';

class ExpenseCreateScreen extends StatefulWidget {
  // FIX: This parameter must be defined in the constructor!
  final String? expenseId;
  
  const ExpenseCreateScreen({super.key, this.expenseId});

  @override
  State<ExpenseCreateScreen> createState() => _ExpenseCreateScreenState();
}

class _ExpenseCreateScreenState extends State<ExpenseCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  // Example data for category selection (In a real app, this comes from API/Provider)
  final List<String> _categories = ['Food', 'Transport', 'Housing', 'Utilities', 'Other'];
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  
  bool _isEditing = false;
  Expense? _initialExpense;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.expenseId != null;
    
    if (_isEditing) {
      // Load initial data if editing
      _loadInitialExpenseData();
    } else {
      // Set a default category for a new expense
      _selectedCategory = _categories.first;
    }
  }

  // --- Logic to load existing expense data ---
  void _loadInitialExpenseData() {
    // NOTE: This approach assumes the expense list is already loaded in the provider.
    final provider = Provider.of<ExpenseProvider>(context, listen: false);
    try {
      _initialExpense = provider.expenses.firstWhere((e) => e.id == widget.expenseId);
      
      // Pre-fill the form fields
      _amountController.text = _initialExpense!.amount.toStringAsFixed(2);
      _descriptionController.text = _initialExpense!.description;
      _selectedCategory = _initialExpense!.category;
      _selectedDate = _initialExpense!.date;
    } catch (e) {
      // Handle case where expense ID is invalid or not found (e.g., redirect/show error)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Expense not found.')),
        );
        Navigator.of(context).pop();
      });
    }
  }

  // --- Date Picker Helper ---
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(), // Expenses typically in the past or today
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // --- Submission Handler ---
  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      _formKey.currentState!.save();
      
      final provider = Provider.of<ExpenseProvider>(context, listen: false);
      
      final expenseToSave = Expense(
        // Use existing ID if editing, otherwise assign empty string (API will generate)
        id: widget.expenseId ?? '', 
        amount: double.parse(_amountController.text),
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        date: _selectedDate,
      );
      
      await provider.createOrUpdateExpense(expenseToSave);
      
      if (provider.errorMessage == null) {
        // Success: pop back to the list screen
        Navigator.of(context).pop();
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage!)),
        );
      }
    } else if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category.')),
        );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the provider to disable the button while saving
    final provider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Expense' : 'New Expense'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                if (widget.expenseId != null) {
                  await provider.deleteExpense(widget.expenseId!);
                  if (provider.errorMessage == null) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Input
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (\$)',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Enter a valid amount.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: provider.isLoading ? null : (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) => value == null ? 'Select a category' : null,
              ),
              const SizedBox(height: 20),

              // Description Input
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (e.g., Coffee, Bus fare)',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLength: 100,
                validator: (value) => value!.isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 20),

              // Date Picker
              ListTile(
                title: const Text('Date'),
                subtitle: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                leading: const Icon(Icons.calendar_today),
                trailing: const Icon(Icons.edit),
                onTap: provider.isLoading ? null : _pickDate,
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: provider.isLoading
                      ? const SizedBox(
                          height: 20, 
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(_isEditing ? 'Update Expense' : 'Record Expense'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}