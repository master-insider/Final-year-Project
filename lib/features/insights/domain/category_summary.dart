// lib/features/insights/domain/category_summary.dart
import 'package:flutter/foundation.dart';

@immutable
class CategorySummary {
  final String category;
  final double totalSpent;
  final double budgetLimit;
  final bool isOverBudget;

  const CategorySummary({
    required this.category,
    required this.totalSpent,
    required this.budgetLimit,
  }) : isOverBudget = totalSpent > budgetLimit; // Derived property

  // --- FROM JSON (API Read) ---
  // Note: We assume the API provides 'category', 'totalSpent', and 'budgetLimit'.
  factory CategorySummary.fromJson(Map<String, dynamic> json) {
    // Ensure all numeric values are handled correctly
    final totalSpent = (json['totalSpent'] as num).toDouble();
    final budgetLimit = (json['budgetLimit'] as num).toDouble();

    return CategorySummary(
      category: json['category'] as String,
      totalSpent: totalSpent,
      budgetLimit: budgetLimit,
      // isOverBudget is automatically calculated in the constructor
    );
  }

  // --- TO JSON (Less likely to be used for read-only summaries, but good for completeness) ---
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'totalSpent': totalSpent,
      'budgetLimit': budgetLimit,
    };
  }

  // --- COPY WITH (Immutability) ---
  CategorySummary copyWith({
    String? category,
    double? totalSpent,
    double? budgetLimit,
  }) {
    return CategorySummary(
      category: category ?? this.category,
      totalSpent: totalSpent ?? this.totalSpent,
      budgetLimit: budgetLimit ?? this.budgetLimit,
    );
  }
}