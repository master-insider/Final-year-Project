import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  Map<String, dynamic>? _user;

  Map<String, dynamic>? get user => _user;

  Future<void> loadProfile(Map<String, dynamic> authUser) async {
    _user = authUser;
    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    // Mock update
    if (_user != null) {
      _user = {..._user!, ...data};
      notifyListeners();
    }
  }
}