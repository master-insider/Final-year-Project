import 'package:flutter/material.dart';
import '../../domain/reports_repository.dart';
import '../../data/models/report_model.dart';

class ReportsProvider with ChangeNotifier {
  final ReportsRepository repository;

  ReportsProvider({required this.repository});

  ReportModel? _currentReport;
  bool _loading = false;

  ReportModel? get report => _currentReport;
  bool get isLoading => _loading;

  Future<void> generate(String period) async {
    _loading = true;
    notifyListeners();

    try {
      _currentReport = await repository.generate(period);
    } catch (e) {
      debugPrint("Report generation error: $e");
    }

    _loading = false;
    notifyListeners();
  }
}
