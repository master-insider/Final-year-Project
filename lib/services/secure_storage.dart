// lib/services/secure_storage.dart
import 'package:flutter/material.dart'; // Needed for debugPrint
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A secure service wrapper for storing sensitive user data like authentication tokens.
/// This service utilizes the platform-specific secure storage (e.g., Keychain on iOS, KeyStore on Android).
class SecureStorageService {
  // Create storage instance (must be initialized once)
  final FlutterSecureStorage _storage;

  // Key names for data stored securely
  static const String _authTokenKey = 'auth_token';

  SecureStorageService() : _storage = const FlutterSecureStorage();

  // --- Token Operations ---

  /// Reads the authentication token from secure storage.
  /// Used primarily by the AuthRepository when checking the session on app startup.
  Future<String?> readAuthToken() async {
    try {
      return await _storage.read(key: _authTokenKey);
    } catch (e) {
      // Log error for debugging, but return null if failed to read
      debugPrint('Error reading auth token from secure storage: $e');
      return null;
    }
  }

  /// Writes the authentication token to secure storage after login/registration.
  Future<void> writeAuthToken(String token) async {
    try {
      await _storage.write(key: _authTokenKey, value: token);
    } catch (e) {
      debugPrint('Error writing auth token to secure storage: $e');
    }
  }

  /// Deletes the authentication token, typically on user logout.
  Future<void> deleteAuthToken() async {
    try {
      await _storage.delete(key: _authTokenKey);
    } catch (e) {
      debugPrint('Error deleting auth token from secure storage: $e');
    }
  }

  // --- General Operations ---
  
  /// Clears all stored secure data (e.g., for full app reset).
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}