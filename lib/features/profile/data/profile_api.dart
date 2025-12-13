import 'dart:convert';
import 'package:flutter_application_1/core/network/api_client.dart';

class ProfileApi {
  static Future<Map<String, dynamic>> fetchProfile() async {
    final res = await ApiClient.get("/auth/profile");
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final res = await ApiClient.put("/auth/profile/update", body: data);
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> updatePassword(Map<String, dynamic> data) async {
    final res = await ApiClient.put("/auth/password/change", body: data);
    return jsonDecode(res.body);
  }
}
