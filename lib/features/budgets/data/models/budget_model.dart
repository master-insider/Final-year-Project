class BudgetModel {
  final int? id;
  final double limit;
  final String period; // e.g. "Monthly", "Weekly", or custom
  final DateTime startDate;
  final DateTime endDate;
  final double spent;

  BudgetModel({
    this.id,
    required this.limit,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.spent,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'],
      limit: double.parse(json['limit'].toString()),
      period: json['period'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      spent: double.parse(json['spent'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "limit": limit,
      "period": period,
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "spent": spent,
    };
  }
}
