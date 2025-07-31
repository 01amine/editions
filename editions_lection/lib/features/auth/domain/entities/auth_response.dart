import 'package:equatable/equatable.dart';

import 'user.dart';

class AuthResponse extends Equatable {
  final String token;
  final User user;

  const AuthResponse({required this.token, required this.user});

  @override
  List<Object> get props => [token, user];
}