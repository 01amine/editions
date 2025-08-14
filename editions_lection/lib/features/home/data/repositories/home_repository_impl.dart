// home_repository_impl.dart

import 'package:editions_lection/features/home/data/datasource/remote_data.dart';
import 'package:editions_lection/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:editions_lection/core/errors/failure.dart';
import 'package:editions_lection/core/errors/exceptions.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';

import '../../../../core/network/network_info.dart';
import '../../domain/entities/order.dart';
import '../models/order_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl(this.networkInfo, {required this.remoteDataSource});

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
  Future<Either<Failure, bool>> createOrder(List<OrderCreateEntity> orders) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModels = orders.map((e) => OrderCreateModel(materialId: e.materialId, quantity: e.quantity)).toList();
        final result = await remoteDataSource.createOrder(orderModels);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOrders = await remoteDataSource.getOrders();
        return Right(remoteOrders);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(ServerFailure(message: 'No internet connection'));
    }
  }

}