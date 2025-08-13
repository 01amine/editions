import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/material.dart';
import '../repositories/home_repository.dart';

class SearchMaterials extends UseCase<List<MaterialEntity>, String> {
  final HomeRepository repository;

  SearchMaterials(this.repository);

  @override
  Future<Either<Failure, List<MaterialEntity>>> call(String params) async {
    return await repository.searchMaterialsByTitle(params);
  }
}