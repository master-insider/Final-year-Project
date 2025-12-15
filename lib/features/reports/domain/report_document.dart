// lib/features/reports/domain/report_document.dart (Model)

class ReportDocument {
  final String id;
  final String title;
  final String type; // e.g., 'Monthly Summary', 'Annual Expense Breakdown'
  final DateTime generatedDate;
  final String downloadUrl;

  ReportDocument({
    required this.id,
    required this.title,
    required this.type,
    required this.generatedDate,
    required this.downloadUrl,
  });

  factory ReportDocument.fromJson(Map<String, dynamic> json) {
    return ReportDocument(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      generatedDate: DateTime.parse(json['generatedDate'] as String),
      downloadUrl: json['downloadUrl'] as String,
    );
  }
}