import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reports_provider.dart';
import '../widgets/report_card.dart';
import 'package:share_plus/share_plus.dart';
import '../../presentation/utils/report_pdf_generator.dart';

body: Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      DropdownButtonFormField(
        decoration: const InputDecoration(
          labelText: "Select Report Period",
        ),
        items: const [
          DropdownMenuItem(value: "weekly", child: Text("Weekly")),
          DropdownMenuItem(value: "monthly", child: Text("Monthly")),
          DropdownMenuItem(value: "yearly", child: Text("Yearly")),
        ],
        onChanged: (value) {
          if (value != null) {
            provider.generate(value);
          }
        },
      ),
      const SizedBox(height: 20),

      if (provider.isLoading)
        const CircularProgressIndicator(),

      if (provider.report != null)
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ReportCard(report: provider.report!),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Generate PDF"),
                  onPressed: () async {
                    final pdfFile = await ReportPdfGenerator
                        .generatePdf(provider.report!);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("PDF Generated: ${pdfFile.path}")),
                    );
                  },
                ),

                const SizedBox(height: 10),

                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text("Download / Share"),
                  onPressed: () async {
                    final pdfFile = await ReportPdfGenerator
                        .generatePdf(provider.report!);

                    await Share.shareXFiles(
                      [XFile(pdfFile.path)],
                      text: "Financial Report - ${provider.report!.period}",
                    );
                  },
                ),
              ],
            ),
          ),
        ),
    ],
  ),
),
