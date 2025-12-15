// lib/features/insights/presentation/providers/insights_provider.dart
import 'package:flutter/material.dart';
import '../../domain/category_summary.dart';
import '../../domain/insights_repository.dart';
import '../../../../core/exceptions/exceptions.dart'; 

class InsightsProvider extends ChangeNotifier {
  final InsightsRepository repository;

  // --- State Variables ---
  List<CategorySummary> _spendingSummary = [];
  Map<String, double> _monthlyTrend = {};
  bool isLoadingSummary = false;
  bool isLoadingTrend = false;
  String? summaryErrorMessage;
  String? trendErrorMessage;

  List<CategorySummary> get spendingSummary => _spendingSummary;
  Map<String, double> get monthlyTrend => _monthlyTrend;

  InsightsProvider({required this.repository});

  // --- Core Methods ---

  Future<void> loadSpendingSummary({DateTime? start, DateTime? end}) async {
    isLoadingSummary = true;
    summaryErrorMessage = null;
    notifyListeners();

    try {
      _spendingSummary = await repository.fetchSpendingSummary(
        startDate: start,
        endDate: end,
      );
    } on AppException catch (e) {
      summaryErrorMessage = 'Failed to load summary: ${e.message}';
      _spendingSummary = [];
    } catch (e) {
      summaryErrorMessage = 'An unexpected error occurred.';
      _spendingSummary = [];
    } finally {
      isLoadingSummary = false;
      notifyListeners();
    }
  }

  Future<void> loadMonthlySpendingTrend(int year) async {
    isLoadingTrend = true;
    trendErrorMessage = null;
    notifyListeners();

    try {
      _monthlyTrend = await repository.fetchMonthlySpendingTrend(year);
    } on AppException catch (e) {
      trendErrorMessage = 'Failed to load spending trend: ${e.message}';
      _monthlyTrend = {};
    } catch (e) {
      trendErrorMessage = 'An unexpected error occurred.';
      _monthlyTrend = {};
    } finally {
      isLoadingTrend = false;
      notifyListeners();
    }
  }
  
  // Example UI Helper: Calculates the percentage of total spending for a chart legend
  double calculateTotalSpending() {
    return _spendingSummary.fold(0.0, (sum, item) => sum + item.totalSpent);
  }
}