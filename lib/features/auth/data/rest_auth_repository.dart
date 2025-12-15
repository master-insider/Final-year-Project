// lib/features/auth/data/rest_auth_repository.dart
import 'dart:convert';
import '../domain/user.dart';
import '../domain/auth_repository.dart';
import '../../../core/network/api_client.dart'; 
import '../../../core/exceptions/exceptions.dart';

class RestAuthRepository implements AuthRepository {
  final ApiClient apiClient;

  RestAuthRepository({required this.apiClient});

  @override
  Future<User> login(String email, String password) async {
    final response = await apiClient.post('/auth/login', body: {
      'email': email,
      'password': password,
    });
    return User.fromJson(response); 
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    final response = await apiClient.post('/auth/register', body: {
      'email': email,
      'password': password,
      'fullName': fullName,
    });
    return User.fromJson(response);
  }

  @override
  Future<void> logout() async {
    // Implement token invalidation/local token clearing
    // await localStorage.clearToken(); 
    await apiClient.post('/auth/logout');
  }
  
  @override
  Future<User?> getProfile() async {
    try {
      final response = await apiClient.get('/auth/profile');
      return User.fromJson(response);
    } on UnauthorizedException {
      // If the token is invalid or missing, return null instead of throwing
      return null; 
    }
  }
  
  @override
  Future<String> refreshToken() async {
    final response = await apiClient.post('/auth/refresh', body: {});
    final newToken = response['token'] as String;
    return newToken;
  }
}