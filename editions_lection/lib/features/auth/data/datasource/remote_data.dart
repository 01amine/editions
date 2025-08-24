import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(
      {required String email, required String password});
  Future<AuthResponseModel> signup({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
    required String studyYear,
    required String specialite,
    required String area,
  });
  Future<UserModel> getCurrentUser(String token);
  Future<void> forgetPassword({required String email});

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
  Future<void> updateUser(
      {required String userId,
      required Map<String, dynamic> data,
      required String token});
}
