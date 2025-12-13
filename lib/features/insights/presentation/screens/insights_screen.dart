import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/insights_provider.dart';
import '../charts/pie_chart.dart';
import '../charts/line_chart.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InsightsProvider>();

    if (provider.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final insights = provider.insights;

    if (insights == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Insights")),
        body: Center(
          child: ElevatedButton(
            onPressed: () => provider.loadInsights(),
            child: const Text("Load Insights"),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Spending Insights")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(insights.message,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            // CATEGORY PIE CHART
            SizedBox(
              height: 250,
              child: CategoryPieChart(data: insights.categoryTotals),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // LINE CHART (MONTHLY TREND)
            const Text(
              "Spending Trend",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 250,
              child: SpendingLineChart(
                monthlyTotals: insights.monthlyTotals,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
