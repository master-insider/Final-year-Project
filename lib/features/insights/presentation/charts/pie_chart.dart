import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> data;

  const CategoryPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final sections = data.entries.map((e) {
      final value = e.value;
      return PieChartSectionData(
        value: value,
        title: "${e.key}\n${value.toStringAsFixed(0)}",
        radius: 70,
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
      ),
    );
  }
}
