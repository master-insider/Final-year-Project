// lib/features/auth/presentation/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../../domain/user.dart';
import '../../domain/auth_repository.dart';
import '../../../../core/exceptions/exceptions.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;
  
  User? _currentUser;
  
  // Renamed the existing field to private for better practice
  bool _isLoading = true; 
  String? errorMessage;
  
  // FIX 1: Rename the public getter to simply 'isLoading'
  // The Route Guard should now check 'auth.isLoading'
  bool get isLoading => _isLoading; 
  
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider({required this.repository});

  Future<void> checkAuthenticationStatus() async {
    // Use the private field
    _isLoading = true; 
    errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await repository.getProfile();
    } catch (e) {
      _currentUser = null;
      errorMessage = 'Session check failed.';
    } finally {
      // Use the private field
      _isLoading = false; 
      notifyListeners();
    }
  }

  Future<bool> loginUser(String email, String password) async {
    // Use the private field
    _isLoading = true; 
    errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await repository.login(email, password);
      return true;
    } on AppException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      // Use the private field
      _isLoading = false; 
      notifyListeners();
    }
  }
  
  Future<bool> registerUser(String email, String password, String fullName) async {
    // Use the private field
    _isLoading = true; 
    errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await repository.register(email, password, fullName);
      return true;
    } on AppException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      // Use the private field
      _isLoading = false; 
      notifyListeners();
    }
  }

  Future<void> logoutUser() async {
    await repository.logout();
    _currentUser = null;
    notifyListeners();
  }
}