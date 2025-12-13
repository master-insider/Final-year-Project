import '../../../config/api_constants.dart';
import '../../../core/network/api_client.dart';
import 'models/insights_model.dart';

class InsightsApi {
  final ApiClient apiClient;

  InsightsApi(this.apiClient);

  Future<InsightsModel> fetchInsights() async {
    final response = await apiClient.get(ApiConstants.insights);
    return InsightsModel.fromJson(response['data']);
  }
}
