// lib/features/auth/domain/auth_repository.dart
import 'user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fullName);
  Future<void> logout();
  Future<User?> getProfile(); // Made nullable for initial check
  Future<String> refreshToken();
}