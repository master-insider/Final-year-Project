// lib/features/profile/domain/profile_repository.dart (Abstract Contract)
import 'user.dart';
abstract class ProfileRepository {
  Future<User> fetchUserProfile(String userId);
  Future<User> updateProfile(User user);
  Future<void> changePassword(String currentPassword, String newPassword);
  // Authentication methods would typically live in a separate AuthRepository
}