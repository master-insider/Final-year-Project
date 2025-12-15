import '../domain/user.dart';
import '../domain/profile_repository.dart';
import '../../../core/network/api_client.dart'; 

class RestProfileRepository implements ProfileRepository {
  final ApiClient apiClient;

  RestProfileRepository({required this.apiClient});

  @override
  Future<User> fetchUserProfile(String userId) async {
    final response = await apiClient.get('/users/$userId/profile');
    
    // Process response and return the User model
    // return User.fromJson(response);
    
    // Placeholder return:
    return User(
      id: userId,
      email: 'user@example.com',
      firstName: 'John',
      lastName: 'Doe',
      currencyPreference: 'USD',
      memberSince: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  @override
  Future<User> updateProfile(User user) async {
    final userData = user.toJson(); // Assuming you implement a toJson() method
    final response = await apiClient.put('/users/${user.id}/profile', body: userData);
    
    // Return the updated User object from the server response
    // return User.fromJson(response);
    return user; // Placeholder return
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final body = {'currentPassword': currentPassword, 'newPassword': newPassword};
    await apiClient.post('/auth/change-password', body: body);
  }
}