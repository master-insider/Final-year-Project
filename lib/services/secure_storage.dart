// // wrapper around flutter_secure_storage for simple usage across app
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class SecureStorageService {
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();

//   Future<void> write(String key, String value) async {
//     await _storage.write(key: key, value: value);
//   }

//   Future<String?> read(String key) async {
//     return await _storage.read(key: key);
//   }

//   Future<void> delete(String key) async {
//     await _storage.delete(key: key);
//   }

//   Future<void> deleteAll() async {
//     await _storage.deleteAll();
//   }
// }

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class SecureStorage {
//   static const FlutterSecureStorage _storage = FlutterSecureStorage();

//   static const String _tokenKey = "accessToken";
//   static const String _refreshKey = "refreshToken";

//   static Future<void> saveTokens(String access, String refresh) async {
//     await _storage.write(key: _tokenKey, value: access);
//     await _storage.write(key: _refreshKey, value: refresh);
//   }

//   static Future<String?> readToken() async {
//     return await _storage.read(key: _tokenKey);
//   }

//   static Future<String?> readRefreshToken() async {
//     return await _storage.read(key: _refreshKey);
//   }

//   static Future<void> clear() async {
//     await _storage.deleteAll();
//   }
// }

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: "access_token", value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: "access_token");
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
