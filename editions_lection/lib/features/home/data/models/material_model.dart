import 'package:editions_lection/features/home/domain/entities/material.dart';

class MaterialModel extends MaterialEntity {
  const MaterialModel({
    required String id,
    required String title,
    required String description,
    required List<String> imageUrls,
    required String materialType,
    required double priceDzd,
    required DateTime createdAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          imageUrls: imageUrls,
          materialType: materialType,
          priceDzd: priceDzd,
          createdAt: createdAt,
        );

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      imageUrls: json['imageUrls'],
      materialType: json['material_type'],
      priceDzd: json['price_dzd'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'material_type': materialType,
      'price_dzd': priceDzd,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
