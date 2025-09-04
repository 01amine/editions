import 'package:equatable/equatable.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';

enum DeliveryType {
  pickup,
  delivery,
}

class OrderItemEntity extends Equatable {
  final MaterialEntity material;
  final int quantity;

  const OrderItemEntity({required this.material, required this.quantity});

  @override
  List<Object?> get props => [material, quantity];
}

class OrderEntity extends Equatable {
  final String id;
  final List<OrderItemEntity> items;
  final String status;
  final DateTime? appointmentDate;
final DeliveryType deliveryType;
  final String? deliveryAddress;
  final String? deliveryPhone;
  final String? zrTrackingId;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.status,
    required this.deliveryType,
    this.appointmentDate,
    this.deliveryAddress,
    this.deliveryPhone,
    this.zrTrackingId,
  });

  @override
  List<Object?> get props => [
        id,
        items,
        status,
        appointmentDate,
        deliveryType,
        deliveryAddress,
        deliveryPhone,
        zrTrackingId,
      ];
}

class OrderCreateEntity extends Equatable {
  final String materialId;
  final int quantity;
  final DeliveryType deliveryType;
  final String? deliveryAddress;
  final String? deliveryPhone;

  const OrderCreateEntity({
    required this.materialId,
    required this.quantity,
    required this.deliveryType,
    this.deliveryAddress,
    this.deliveryPhone,
  });

  @override
  List<Object?> get props => [
        materialId,
        quantity,
        deliveryType,
        deliveryAddress,
        deliveryPhone,
      ];
}