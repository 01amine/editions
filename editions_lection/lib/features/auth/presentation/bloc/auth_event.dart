part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignupRequested extends AuthEvent {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String password;
  final String studyYear;
  final String specialite;
  final String area;

  const SignupRequested({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.studyYear,
    required this.specialite,
    required this.area,
  });

  @override
  List<Object> get props => [fullName, phoneNumber, email, password];
}

class GetCurrentUserEvent extends AuthEvent {}

class ForgetPasswordRequested extends AuthEvent {
  final String email;

  const ForgetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String code;
  final String newPassword;

  const ResetPasswordRequested({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  @override
  List<Object> get props => [email, code, newPassword];
}

class UpdateUserEvent extends AuthEvent {
  final Map<String, dynamic> userData;

  const UpdateUserEvent({required this.userData});

  @override
  List<Object> get props => [userData];
}
