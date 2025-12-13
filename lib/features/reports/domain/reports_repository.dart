import '../data/reports_api.dart';
import '../data/models/report_model.dart';

class ReportsRepository {
  final ReportsApi api;

  ReportsRepository(this.api);

  Future<ReportModel> generate(String period) {
    return api.generateReport(period);
  }
}
