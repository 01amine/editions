import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:editions_lection/core/errors/failure.dart';
import 'package:editions_lection/core/usecase/usecase.dart';
import 'package:editions_lection/features/home/domain/entities/order.dart';
import 'package:editions_lection/features/home/domain/repositories/home_repository.dart';

class CreateOrder implements UseCase<bool, CreateOrderParams> {
  final HomeRepository repository;

  CreateOrder({required this.repository});

  @override
  Future<Either<Failure, bool>> call(CreateOrderParams params) async {
    return await repository.createOrder(params.orders, params.deliveryType,
        params.deliveryAddress, params.deliveryPhone);
  }
}

class CreateOrderParams extends Equatable {
  final List<OrderCreateEntity> orders;
  final DeliveryType deliveryType;
  final String? deliveryAddress;
  final String? deliveryPhone;

  const CreateOrderParams({
    required this.orders,
    required this.deliveryType,
    this.deliveryAddress,
    this.deliveryPhone,
  });

  @override
  List<Object?> get props =>
      [orders, deliveryType, deliveryAddress, deliveryPhone];
}
