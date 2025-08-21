

import '../../domain/entities/notification.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.message,
    required super.createdAt,
    required super.isSent,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String,
      message: json['message'] as String,
      
      createdAt: DateTime.parse(json['created_at'] as String),
      isSent: json['issent'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'message': message,
      
      'created_at': createdAt.toIso8601String(),
      'issent': isSent,
    };
  }
}