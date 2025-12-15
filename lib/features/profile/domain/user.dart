import 'package:flutter/foundation.dart';

@immutable // Mark as immutable for better state management practices
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String currencyPreference;
  final DateTime memberSince;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.currencyPreference,
    required this.memberSince,
  });

  // --- 1. CONSTRUCTOR FOR API DATA (from JSON) ---
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      currencyPreference: json['currencyPreference'] as String,
      // Ensure date strings are parsed correctly
      memberSince: DateTime.parse(json['memberSince'] as String), 
    );
  }

  // --- 2. METHOD FOR API REQUESTS (to JSON) ---
  Map<String, dynamic> toJson() { // <--- THIS IS THE METHOD YOU NEEDED!
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'currencyPreference': currencyPreference,
      'memberSince': memberSince.toIso8601String(), // Convert DateTime to string
    };
  }

  // --- 3. HELPER FOR STATE MANAGEMENT (Immutability) ---
  User copyWith({
    String? firstName,
    String? lastName,
    String? currencyPreference,
  }) {
    return User(
      id: id,
      email: email,
      memberSince: memberSince,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      currencyPreference: currencyPreference ?? this.currencyPreference,
    );
  }
}