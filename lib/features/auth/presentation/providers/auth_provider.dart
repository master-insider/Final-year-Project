import 'package:flutter/material.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
}

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unauthenticated;
  Map<String, dynamic>? _user;

  AuthStatus get status => _status;
  Map<String, dynamic>? get user => _user;

  // Mock login method for now
  Future<void> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Mock API call

    _user = {
      'id': 1,
      'name': 'John Doe',
      'email': email,
    };
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  // Mock register method for now
  Future<void> register(String name, String email, String password) async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Mock API call

    _user = {
      'id': 1,
      'name': name,
      'email': email,
    };
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // Mock factory method
  static AuthProvider create() => AuthProvider();
  Future<void> loadFromStorage() async {
    // Mock storage load
    await Future.delayed(const Duration(milliseconds: 100));
  }
}