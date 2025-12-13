import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpendingLineChart extends StatelessWidget {
  final List<double> monthlyTotals;

  const SpendingLineChart({super.key, required this.monthlyTotals});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              monthlyTotals.length,
              (i) => FlSpot(i.toDouble(), monthlyTotals[i]),
            ),
            isCurved: true,
            barWidth: 3,
          )
        ],
      ),
    );
  }
}
