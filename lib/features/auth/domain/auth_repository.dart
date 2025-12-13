// // lib/features/auth/domain/auth_repository.dart

// import '../../features/auth/data/models/user_model.dart';
// import '../../features/auth/data/auth_api.dart';

// class AuthRepository {
//   final AuthApi api;

//   AuthRepository({required this.api});

//   Future<UserModel> login(String email, String password) {
//     return api.login(email: email, password: password);
//   }

//   Future<UserModel> register(String email, String password, {String? name}) {
//     return api.register(email: email, password: password, name: name);
//   }

//   Future<UserModel> fetchProfile(String token) {
//     return api.fetchProfile(token: token);
//   }
// }

import '../data/auth_api.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password) async {
    return await AuthApi.login({
      "email": email,
      "password": password,
    });
  }

  Future<Map<String, dynamic>> register(
      String email, String password, String name) async {
    return await AuthApi.register({
      "email": email,
      "password": password,
      "name": name,
    });
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    return await AuthApi.getProfile();
  }
}
