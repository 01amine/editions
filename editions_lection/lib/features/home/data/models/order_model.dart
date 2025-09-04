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
    required super.deliveryType,
    super.appointmentDate,
    super.deliveryAddress,
    super.zrTrackingId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final List<OrderItemEntity> items =
        (json['item'] as List).map((e) => OrderItemModel.fromJson(e)).toList();

    return OrderModel(
      id: json['_id'],
      items: items,
      status: json['status'],
      deliveryType: json['delivery_type'] == 'pickup'
          ? DeliveryType.pickup
          : DeliveryType.delivery,
      deliveryAddress: json['delivery_address'],
      zrTrackingId: json['zr_tracking_id'],
      appointmentDate: json['appointment_date'] != null
          ? DateTime.parse(json['appointment_date'])
          : null,
    );
  }
}

class OrderCreateModel extends OrderCreateEntity {
  const OrderCreateModel({
    required super.materialId,
    required super.quantity,
    required super.deliveryType,
    super.deliveryAddress,
    super.deliveryPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'materiel_id': materialId,
      'quantity': quantity,
      'delivery_type': deliveryType.name,
      'delivery_address': deliveryAddress,
      'delivery_phone': deliveryPhone,
    };
  }
}