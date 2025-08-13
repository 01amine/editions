import '../../domain/entities/auth_response.dart';

class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required super.token,
    
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['access_token'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': token,
    };
  }
}
