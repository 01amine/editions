import 'package:dartz/dartz.dart';
import 'package:editions_lection/core/errors/failure.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';

import '../entities/order.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<MaterialEntity>>> getBooks();
  Future<Either<Failure, List<MaterialEntity>>> getPolycopies();
  Future<Either<Failure, List<MaterialEntity>>> searchMaterialsByTitle(
      String title);
  Future<Either<Failure, bool>> createOrder(
    List<OrderCreateEntity> orders,
    DeliveryType deliveryType,
    String? deliveryAddress,
    String? deliveryPhone,
  );
  Future<Either<Failure, List<OrderEntity>>> getOrders();
}