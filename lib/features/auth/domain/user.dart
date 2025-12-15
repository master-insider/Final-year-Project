// lib/features/auth/domain/user.dart
import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String email;
  final String? fullName;
  final String? token;

  const User({
    required this.id,
    required this.email,
    this.fullName,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'token': token,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      token: token ?? this.token,
    );
  }
}