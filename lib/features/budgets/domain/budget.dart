// lib/features/budgets/domain/budget.dart

class Budget {
  final String id;
  final String category; // e.g., 'Groceries', 'Rent'
  final double limit;
  final double spent;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.spent,
    required this.startDate,
    required this.endDate,
  });

  // Method to create an object from JSON (for API responses)
  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      category: json['category'] as String,
      limit: (json['limit'] as num).toDouble(),
      spent: (json['spent'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }
}