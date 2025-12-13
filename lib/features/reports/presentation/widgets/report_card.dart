import 'package:flutter/material.dart';
import '../../data/models/report_model.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;

  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Report - ${report.period}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Text("Total Spent: Ksh ${report.totalSpent}"),
            Text("Highest Category: ${report.highestCategoryName}"),
            const SizedBox(height: 10),
            Text(
              "Generated on: ${report.generatedAt.toLocal()}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
