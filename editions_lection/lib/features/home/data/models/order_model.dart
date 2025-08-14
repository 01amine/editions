import 'package:editions_lection/features/home/domain/entities/order.dart';
import 'package:editions_lection/features/home/data/models/material_model.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({required super.material, required super.quantity});

  factory OrderItemModel.fromJson(List<dynamic> json) {
    return OrderItemModel(
      material: MaterialModel.fromJson(json[0]),
      quantity: json[1],
    );
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.items,
    required super.status,
    super.appointmentDate,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final List<OrderItemEntity> items =
        (json['item'] as List).map((e) => OrderItemModel.fromJson(e)).toList();

    return OrderModel(
      id: json['id'],
      items: items,
      status: json['status'],
      appointmentDate: json['appointment_date'] != null
          ? DateTime.parse(json['appointment_date'])
          : null,
    );
  }
}

class OrderCreateModel {
  final String materialId;
  final int quantity;

  OrderCreateModel({required this.materialId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'materiel_id': materialId,
      'quantity': quantity,
    };
  }
}