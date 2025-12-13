class ReportModel {
  final String period;
  final double totalSpent;
  final Map<String, double> categoryBreakdown;
  final double highestCategoryValue;
  final String highestCategoryName;
  final List<double> trendData;
  final DateTime generatedAt;

  ReportModel({
    required this.period,
    required this.totalSpent,
    required this.categoryBreakdown,
    required this.highestCategoryValue,
    required this.highestCategoryName,
    required this.trendData,
    required this.generatedAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      period: json["period"],
      totalSpent: json["total_spent"].toDouble(),
      categoryBreakdown:
          Map<String, double>.from(json["category_breakdown"]),
      highestCategoryValue:
          json["highest_category_value"].toDouble(),
      highestCategoryName: json["highest_category_name"],
      trendData: List<double>.from(
          json["trend_data"].map((e) => e.toDouble())),
      generatedAt: DateTime.parse(json["generated_at"]),
    );
  }
}
