import 'package:editions_lection/core/errors/failure.dart';
import 'package:editions_lection/core/usecase/usecase.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';
import 'package:editions_lection/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';

class GetPolycopies extends UseCase<List<MaterialEntity>, NoParams> {
  final HomeRepository repository;

  GetPolycopies(this.repository);

  @override
  Future<Either<Failure, List<MaterialEntity>>> call(NoParams params) async {
    return await repository.getPolycopies();
  }
}