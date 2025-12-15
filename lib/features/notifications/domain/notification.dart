import 'package:flutter/foundation.dart';

enum NotificationType {
  budgetAlert,    // e.g., 80% of budget reached
  goalReached,    // e.g., Savings goal met
  systemUpdate,   // e.g., New feature available
  transactionAlert, // e.g., Large expense detected
}

@immutable
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;
  final String? relatedEntityId; // e.g., the ID of the budget that was breached

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.type = NotificationType.systemUpdate,
    this.relatedEntityId,
  });

  // --- FROM JSON (API Read) ---
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool,
      // Map the string from the API to the Dart enum
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.systemUpdate,
      ),
      relatedEntityId: json['relatedEntityId'] as String?,
    );
  }

  // --- TO JSON (API Write) ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      // Convert the enum to its string name
      'type': type.toString().split('.').last, 
      'relatedEntityId': relatedEntityId,
    };
  }

  // --- COPY WITH (Immutability for updates like marking as read) ---
  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
    String? relatedEntityId,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
    );
  }
}