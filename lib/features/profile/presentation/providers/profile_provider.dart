import 'package:flutter/material.dart';
import '../../domain/user.dart';
import '../../domain/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository repository;

  // State variables
  User? currentUser;
  bool isLoading = false;
  String? errorMessage;

  ProfileProvider({required this.repository});

  // 1. Fetch User Profile
  Future<void> loadUserProfile(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentUser = await repository.fetchUserProfile(userId);
    } catch (e) {
      errorMessage = 'Failed to load profile: $e';
      currentUser = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 2. Update User Details
  Future<bool> updateUserDetails({
    String? firstName,
    String? lastName,
    String? currency,
  }) async {
    if (currentUser == null) {
      errorMessage = 'Cannot update. User profile is not loaded.';
      notifyListeners();
      return false;
    }

    // Create a new User object using copyWith with only the fields that changed
    final updatedUser = currentUser!.copyWith(
      firstName: firstName,
      lastName: lastName,
      currencyPreference: currency,
    );

    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      // Send the updated User object to the repository
      currentUser = await repository.updateProfile(updatedUser);
      return true; // Success
    } catch (e) {
      errorMessage = 'Failed to save profile changes: $e';
      return false; // Failure
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 3. Change Password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await repository.changePassword(currentPassword, newPassword);
      errorMessage = null; // Clear error on success
      return true;
    } catch (e) {
      errorMessage = 'Failed to change password: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}