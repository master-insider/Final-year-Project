// lib/features/insights/domain/insights_repository.dart

import 'category_summary.dart';

abstract class InsightsRepository {
  
  /// Fetches a spending summary broken down by category, optionally filtered by a date range.
  Future<List<CategorySummary>> fetchSpendingSummary({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Fetches the total spending for each month in a given year, useful for trend charts.
  /// The returned map typically contains 'MonthName': total_amount.
  Future<Map<String, double>> fetchMonthlySpendingTrend(int year);

  // Optional: You could add other insights methods here, such as:
  // Future<double> fetchAverageDailySpending();
  // Future<Map<String, double>> fetchLargestExpenses(); 
}