import 'package:flutter_application_1/config/api_constants.dart';
import 'package:flutter_application_1/core/network/api_client.dart';
import 'models/expense_model.dart';

class ExpenseApi {
  final ApiClient apiClient;

  ExpenseApi(this.apiClient);

  /// GET /api/expenses/
  Future<List<ExpenseModel>> getExpenses() async {
    final response = await apiClient.get(ApiConstants.expenses);

    final List data = response['data'];
    return data.map((e) => ExpenseModel.fromJson(e)).toList();
  }

  /// POST /api/expenses/
  Future<ExpenseModel> addExpense(ExpenseModel expense) async {
    final response = await apiClient.post(
      ApiConstants.expenses,
      expense.toJson(),
    );

    return ExpenseModel.fromJson(response['data']);
  }

  /// PUT /api/expenses/<id>/
  Future<ExpenseModel> updateExpense(int id, ExpenseModel expense) async {
    final response = await apiClient.put(
      "${ApiConstants.expenses}$id/",
      expense.toJson(),
    );

    return ExpenseModel.fromJson(response['data']);
  }

  /// DELETE /api/expenses/<id>/
  Future<void> deleteExpense(int id) async {
    await apiClient.delete("${ApiConstants.expenses}$id/");
  }
}
