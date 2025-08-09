import 'package:editions_lection/core/errors/failure.dart';
import 'package:editions_lection/core/usecase/usecase.dart';
import 'package:editions_lection/features/auth/domain/entities/user.dart';
import 'package:editions_lection/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class GetCurrentUser implements UseCase<User, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}