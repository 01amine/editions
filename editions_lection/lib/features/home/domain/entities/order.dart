import 'package:equatable/equatable.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';

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

  const OrderEntity({
    required this.id,
    required this.items,
    required this.status,
    this.appointmentDate,
  });

  @override
  List<Object?> get props => [id, items, status, appointmentDate];
}

class OrderCreateEntity extends Equatable {
  final String materialId;
  final int quantity;

  const OrderCreateEntity({
    required this.materialId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [materialId, quantity];
}