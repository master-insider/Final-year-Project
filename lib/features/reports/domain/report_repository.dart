// lib/features/reports/domain/report_repository.dart (Abstract Contract)
import 'report_document.dart';

abstract class ReportRepository {
  // Lists all previously generated reports
  Future<List<ReportDocument>> fetchAllReports();
  
  // Triggers the server to generate a new report (returns the document details)
  Future<ReportDocument> generateReport({
    required String reportType,
    required DateTime startDate,
    required DateTime endDate,
  });
  
  // Fetches the raw file data (for saving/displaying)
  Future<List<int>> downloadReportFile(String downloadUrl);
}