import 'dart:convert';
import 'package:editions_lection/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../models/auth_response_model.dart';
import 'remote_data.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  AuthRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['message'] ?? 'Failed to log in');
    }
  }

  @override
  Future<AuthResponseModel> signup({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
    required String studyYear,
    required String specialite,
    required String area,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'full_name': fullName,
        'phone_number': phoneNumber,
        'email': email,
        'password': password,
        'study_year': studyYear,
        'specialite': specialite,
        'area': area,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
          message:
              json.decode(response.body)['message'] ?? 'Failed to sign up');
    }
  }

  @override
  Future<UserModel> getCurrentUser(String token) async {
    final uri = Uri.parse('$baseUrl/users/me');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Log the request details for debugging
    print('Sending GET request to: $uri');
    print('Headers: $headers');

    final response = await client.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Response data: $data');
      return UserModel.fromJson(data);
    } else {
      print('Error fetching user: ${response.statusCode}, ${response.body}');
      throw ServerException(
        message: json.decode(response.body)['message'] ??
            'Failed to fetch user data',
      );
    }
  }
  @override
  Future<void> forgetPassword({required String email}) async {
    final response = await client.post(
      Uri.parse('$baseUrl/users/forget-password?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(
          message: json.decode(response.body)['message'] ??
              'Failed to send password reset email');
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/users/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'code': code,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException(
          message: json.decode(response.body)['message'] ??
              'Failed to reset password');
    }
  }
}
