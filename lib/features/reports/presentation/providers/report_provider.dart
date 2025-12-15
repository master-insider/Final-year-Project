import 'package:flutter/material.dart';
import '../../domain/report_document.dart';
import '../../domain/report_repository.dart';

class ReportProvider extends ChangeNotifier {
  final ReportRepository repository;
  
  // State variables
  List<ReportDocument> reports = [];
  bool isLoading = false;
  String? errorMessage;
  bool isGenerating = false;
  String? downloadStatus;

  ReportProvider({required this.repository});

  Future<void> loadReports() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      reports = await repository.fetchAllReports();
    } catch (e) {
      errorMessage = 'Failed to load reports: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generateNewReport(String type, DateTime start, DateTime end) async {
    isGenerating = true;
    errorMessage = null;
    notifyListeners();
    try {
      final newReport = await repository.generateReport(
          reportType: type, startDate: start, endDate: end);
      
      // Add the new report to the list and notify
      reports.insert(0, newReport); 

    } catch (e) {
      errorMessage = 'Failed to start report generation: $e';
    } finally {
      isGenerating = false;
      notifyListeners();
    }
  }

  Future<bool> downloadReport(ReportDocument report) async {
    downloadStatus = 'Starting download for ${report.title}...';
    notifyListeners();
    try {
      // Get the raw file data
      final fileBytes = await repository.downloadReportFile(report.downloadUrl);
      
      // Logic to save file to user's device goes here (e.g., using path_provider and file system)
      // Example: final savedPath = await saveFileToDevice(fileBytes, report.title);
      
      downloadStatus = 'Download complete!';
      return true;
    } catch (e) {
      downloadStatus = 'Download failed: $e';
      return false;
    } finally {
      notifyListeners();
    }
  }
}