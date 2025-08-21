import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String message;
  final DateTime createdAt;
  final bool isSent;

  const NotificationEntity({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.isSent,
  });

  @override
  List<Object?> get props => [id, message, createdAt, isSent];

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['_id'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isSent: json['issent'] as bool,
    );
  }
}
