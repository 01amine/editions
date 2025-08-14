import 'package:dartz/dartz.dart';
import 'package:editions_lection/core/errors/failure.dart';
import 'package:editions_lection/core/usecase/usecase.dart';
import 'package:editions_lection/features/home/domain/entities/order.dart';
import 'package:editions_lection/features/home/domain/repositories/home_repository.dart';

class GetOrders implements UseCase<List<OrderEntity>, NoParams> {
  final HomeRepository repository;

  GetOrders({required this.repository});

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) async {
    return await repository.getOrders();
  }
}