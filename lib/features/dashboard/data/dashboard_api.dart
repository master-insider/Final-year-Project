import 'dart:convert';
import 'package:flutter_application_1/core/network/api_client.dart';

class DashboardApi {
  static Future<Map<String, dynamic>> fetchDashboardStats() async {
    final res = await ApiClient.get("/dashboard/stats");

    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> fetchRecentExpenses() async {
    final res = await ApiClient.get("/dashboard/recent-expenses");

    return jsonDecode(res.body);
  }
}
