import '../domain/category_summary.dart';
import '../domain/insights_repository.dart';
import '../../../core/network/api_client.dart'; 
import 'dart:convert'; 

class RestInsightsRepository implements InsightsRepository {
  final ApiClient apiClient;

  RestInsightsRepository({required this.apiClient});

  // Helper method to construct the URL with query parameters
  String _buildUrlWithQuery(String path, Map<String, dynamic> params) {
    if (params.isEmpty) return path;
    
    // Convert Map<String, dynamic> to Map<String, String> for URI encoding
    final stringParams = params.map((key, value) => MapEntry(key, value.toString()));
    
    final uri = Uri.parse(path).replace(queryParameters: stringParams);
    return uri.toString();
  }

  @override
  Future<List<CategorySummary>> fetchSpendingSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // 1. Construct query parameters
    final queryParams = {
      if (startDate != null) 'start': startDate.toIso8601String(),
      if (endDate != null) 'end': endDate.toIso8601String(),
    };
    
    // 2. Build the full URL path
    final path = _buildUrlWithQuery('/insights/summary', queryParams);
    
    // 3. API call using the corrected path
    final response = await apiClient.get(path);
    
    // Placeholder return:
    return [
      CategorySummary.fromJson({'category': 'Food', 'totalSpent': 450.0, 'budgetLimit': 500.0}),
      CategorySummary.fromJson({'category': 'Housing', 'totalSpent': 1200.0, 'budgetLimit': 1000.0}), 
    ];
  }

  @override
  Future<Map<String, double>> fetchMonthlySpendingTrend(int year) async {
    // 1. Construct query parameters
    final queryParams = {'year': year.toString()};
    
    // 2. Build the full URL path
    final path = _buildUrlWithQuery('/insights/spending-trend', queryParams);

    // 3. API call using the corrected path
    final response = await apiClient.get(path);
    
    // Placeholder return: Month-Name to Amount (e.g., for charting)
    return {
      'Jan': 1500.0,
      'Feb': 1650.0,
      'Mar': 1400.0,
    };
  }
}