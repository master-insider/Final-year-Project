class InsightsModel {
  final Map<String, double> categoryTotals;
  final List<double> monthlyTotals;
  final double averageSpending;
  final String message;

  InsightsModel({
    required this.categoryTotals,
    required this.monthlyTotals,
    required this.averageSpending,
    required this.message,
  });

  factory InsightsModel.fromJson(Map<String, dynamic> json) {
    return InsightsModel(
      categoryTotals: Map<String, double>.from(json['category_totals']),
      monthlyTotals:
          (json['monthly_totals'] as List).map((e) => (e as num).toDouble()).toList(),
      averageSpending: json['average_spending'].toDouble(),
      message: json['message'],
    );
  }
}
