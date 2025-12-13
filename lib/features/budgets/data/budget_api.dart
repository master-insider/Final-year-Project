import 'package:flutter_application_1/config/api_constants.dart';
import 'package:flutter_application_1/core/network/api_client.dart';

import 'models/budget_model.dart';

class BudgetApi {
  final ApiClient apiClient;

  BudgetApi(this.apiClient);

  Future<BudgetModel?> getCurrentBudget() async {
    final response = await apiClient.get(ApiConstants.budget);
    if (response['data'] == null) return null;
    return BudgetModel.fromJson(response['data']);
  }

  Future<BudgetModel> createBudget(BudgetModel budget) async {
    final response =
        await apiClient.post(ApiConstants.budget, budget.toJson());
    return BudgetModel.fromJson(response['data']);
  }

  Future<BudgetModel> updateBudget(int id, BudgetModel budget) async {
    final response =
        await apiClient.put("${ApiConstants.budget}$id/", budget.toJson());
    return BudgetModel.fromJson(response['data']);
  }
}
