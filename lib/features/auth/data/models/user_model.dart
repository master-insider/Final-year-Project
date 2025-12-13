// lib/features/auth/data/models/user_model.dart

class UserModel {
  final int? id;
  final String email;
  final String? name;
  final String? token;

  UserModel({
    this.id,
    required this.email,
    this.name,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      email: json['email'] ?? '',
      name: json['name'] ?? json['username'] ?? null,
      token: json['token'] ?? json['auth_token'] ?? null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'email': email,
        if (name != null) 'name': name,
        if (token != null) 'token': token,
      };
}
