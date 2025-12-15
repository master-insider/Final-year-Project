// lib/features/budgets/domain/budget.dart
import 'package:flutter/foundation.dart';

@immutable
class Budget {
  final String id;
  final String category;
  final double limit;
  final double currentSpend; // Current amount spent in this budget period
  final DateTime startDate;
  final DateTime endDate;

  const Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.currentSpend,
    required this.startDate,
    required this.endDate,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      category: json['category'] as String,
      limit: (json['limit'] as num).toDouble(),
      currentSpend: (json['currentSpend'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'limit': limit,
      'currentSpend': currentSpend,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
  
  Budget copyWith({
    String? id,
    String? category,
    double? limit,
    double? currentSpend,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      limit: limit ?? this.limit,
      currentSpend: currentSpend ?? this.currentSpend,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}