import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/clear_token.dart';
import '../../domain/usecases/foget_password.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/signup_user.dart';
import '../../domain/usecases/save_token.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final LoginUser loginUser;
  final SignupUser signupUser;
  final SaveToken saveToken;
  final ClearToken clearToken;
  final GetCurrentUser getCurrentUser;
  final ForgetPasswordUser forgetPasswordUser;
  final ResetPasswordUser resetPasswordUser;

  AuthBloc({
    required this.authRepository,
    required this.loginUser,
    required this.signupUser,
    required this.saveToken,
    required this.clearToken,
    required this.getCurrentUser,
    required this.forgetPasswordUser,
    required this.resetPasswordUser,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<GetCurrentUserEvent>((event, emit) async {
      final result = await getCurrentUser(NoParams());
      result.fold(
        (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
        (user) => emit(UserLoaded(user)),
      );
    });
    on<ForgetPasswordRequested>(_onForgetPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<UpdateUserEvent>((event, emit) async {
      if (state is UserLoaded) {
        final currentUser = (state as UserLoaded).user;

        emit(AuthLoading());

        final result = await authRepository.updateUser(
          userId: currentUser.id,
          data: event.userData,
        );

        result.fold(
          (failure) => emit(AuthError(message: "failure message")),
          (_) {
            add(GetCurrentUserEvent());
          },
        );
      }
    });
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUser(
      LoginParams(email: event.email, password: event.password),
    );

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null);
      emit(AuthError(message: _mapFailureToMessage(failure!)));
    } else {
      final authResponse = result.fold((l) => null, (r) => r);
      await saveToken(authResponse!.token);
      emit(AuthSuccess(authResponse: authResponse));
    }
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signupUser(
      SignupParams(
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
        email: event.email,
        password: event.password,
        studyYear: event.studyYear,
        specialite: event.specialite,
        area: event.area,
      ),
    );

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null);
      emit(AuthError(message: _mapFailureToMessage(failure!)));
    } else {
      final authResponse = result.fold((l) => null, (r) => r);

      await saveToken(authResponse!.token);

      emit(AuthSuccess(authResponse: authResponse));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await clearToken(NoParams());
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(AuthInitial()),
    );
  }

  Future<void> _onForgetPasswordRequested(
    ForgetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await forgetPasswordUser(event.email);
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(PasswordResetCodeSent()),
    );
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await resetPasswordUser(ResetPasswordParams(
        email: event.email, code: event.code, newPassword: event.newPassword));
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(PasswordResetSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return 'Cache Error';
    } else {
      return 'Unexpected Error';
    }
  }
}
