// home_repository_impl.dart

import 'package:editions_lection/features/home/data/datasource/remote_data.dart';
import 'package:editions_lection/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:editions_lection/core/errors/failure.dart';
import 'package:editions_lection/core/errors/exceptions.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MaterialEntity>>> getBooks() async {
    try {
      final materials = await remoteDataSource.getBooks();
      return Right(materials);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<MaterialEntity>>> getPolycopies() async {
    try {
      final materials = await remoteDataSource.getPolycopies();
      return Right(materials);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, List<MaterialEntity>>> searchMaterialsByTitle(String title) async {
    try {
      final materials = await remoteDataSource.searchMaterialsByTitle(title);
      return Right(materials);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, bool>> createOrder(List<String> materialIds) async {
    try {
      final result = await remoteDataSource.createOrder(materialIds);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}