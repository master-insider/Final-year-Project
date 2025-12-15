// lib/features/dashboard/domain/dashboard_stats.dart

class DashboardStats {
  final double totalSpent;
  final double income;
  final double budgetRemaining;

  DashboardStats({
    required this.totalSpent,
    required this.income,
    required this.budgetRemaining,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalSpent: (json['totalSpent'] as num).toDouble(),
      income: (json['income'] as num).toDouble(),
      budgetRemaining: (json['budgetRemaining'] as num).toDouble(),
    );
  }
}