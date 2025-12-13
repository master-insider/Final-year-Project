import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../data/models/report_model.dart';

class ReportPdfGenerator {
  static Future<File> generatePdf(ReportModel report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Financial Report - ${report.period}",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    )),

                pw.SizedBox(height: 24),

                pw.Text("Total Spent: Ksh ${report.totalSpent}",
                    style: const pw.TextStyle(fontSize: 18)),

                pw.SizedBox(height: 12),

                pw.Text("Highest Category: ${report.highestCategoryName}"),
                pw.Text("Amount: Ksh ${report.highestCategoryValue}"),

                pw.SizedBox(height: 24),

                pw.Text("Category Breakdown:",
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),

                pw.SizedBox(height: 12),

                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: report.categoryBreakdown.entries.map((e) {
                    return pw.Text("${e.key}: Ksh ${e.value}");
                  }).toList(),
                ),

                pw.SizedBox(height: 24),
                pw.Divider(),

                pw.Text(
                  "Generated on: ${report.generatedAt.toLocal()}",
                  style: const pw.TextStyle(fontSize: 12),
                )
              ],
            ),
          );
        },
      ),
    );

    final outputDir = await getTemporaryDirectory();
    final file = File("${outputDir.path}/report_${report.period}.pdf");

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}
