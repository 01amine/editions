// notification_remote_data_source.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(String token);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  NotificationRemoteDataSourceImpl(
      {required this.client, required this.baseUrl});

  @override
  Future<List<NotificationModel>> getNotifications(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/notifications/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response status: ${response.body}');
    if (response.statusCode == 200) {
      final notifications = (json.decode(response.body) as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
      return notifications;
    } else {
      throw ServerException(
          message: json.decode(response.body)['message'] ?? 'Server Error');
    }
  }
}
