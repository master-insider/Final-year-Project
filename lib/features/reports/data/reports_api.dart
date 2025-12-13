import '../../../config/api_constants.dart';
import '../../../core/network/api_client.dart';
import 'models/report_model.dart';

class ReportsApi {
  final ApiClient apiClient;

  ReportsApi(this.apiClient);

  Future<ReportModel> generateReport(String period) async {
    final response = await apiClient.get("${ApiConstants.reports}?period=$period");
    return ReportModel.fromJson(response['data']);
  }
}
