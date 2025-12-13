import '../data/profile_api.dart';

class ProfileRepository {
  Future<Map<String, dynamic>> getProfile() {
    return ProfileApi.fetchProfile();
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) {
    return ProfileApi.updateProfile(data);
  }

  Future<Map<String, dynamic>> changePassword(Map<String, dynamic> data) {
    return ProfileApi.updatePassword(data);
  }
}
