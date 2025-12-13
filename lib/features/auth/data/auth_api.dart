// // lib/features/auth/data/auth_api.dart
// import 'dart:convert';

// import '../../../core/network/api_client.dart';
// import '../models/user_model.dart';

// class AuthApi {
//   final ApiClient client;

//   AuthApi({required this.client});

//   /// Call Django endpoint for login.
//   /// Expected to return JSON including token and user data.
//   Future<UserModel> login({required String email, required String password}) async {
//     final body = {'email': email, 'password': password};
//     final res = await client.post('auth/login/', body: body);
//     // res = {'status': xxx, 'body': decoded}
//     final payload = res['body'];
//     // adapt to your Django response structure
//     if (payload is Map<String, dynamic>) {
//       // If token is at payload['token']
//       return UserModel.fromJson(payload);
//     } else {
//       throw Exception('Unexpected response structure from login');
//     }
//   }

//   /// Call Django endpoint for registration.
//   Future<UserModel> register({
//     required String email,
//     required String password,
//     String? name,
//   }) async {
//     final body = {'email': email, 'password': password, if (name != null) 'name': name};
//     final res = await client.post('auth/register/', body: body);
//     final payload = res['body'];
//     if (payload is Map<String, dynamic>) {
//       return UserModel.fromJson(payload);
//     } else {
//       throw Exception('Unexpected response structure from register');
//     }
//   }

//   /// Optional: fetch profile using token
//   Future<UserModel> fetchProfile({required String token}) async {
//     final res = await client.get('auth/profile/', token: token);
//     final payload = res['body'];
//     if (payload is Map<String, dynamic>) {
//       return UserModel.fromJson(payload);
//     } else {
//       throw Exception('Unexpected response structure from profile');
//     }
//   }
// }

import 'dart:convert';
import '../../../core/network/api_client.dart';

class AuthApi {
  static Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    final res = await ApiClient.post("/auth/login/", body);
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> body) async {
    final res = await ApiClient.post("/auth/register/", body);
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final res = await ApiClient.get("/auth/profile/");
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> refreshToken(
      Map<String, dynamic> body) async {
    final res = await ApiClient.post("/auth/refresh/", body);
    return jsonDecode(res.body);
  }
}
