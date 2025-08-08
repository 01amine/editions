import 'package:equatable/equatable.dart';

class MaterialEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final List<String> imageUrls;
  final String materialType;
  final double priceDzd;
  final DateTime createdAt;

  const MaterialEntity({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrls,
    required this.materialType,
    required this.priceDzd,
    required this.createdAt,
  });

  factory MaterialEntity.fromJson(Map<String, dynamic> json) {
    return MaterialEntity(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrls: List<String>.from(json['image_urls'] as List),
      
      materialType: json['material_type'] as String,
      priceDzd: (json['price_dzd'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'image_urls': imageUrls,
      
      'material_type': materialType,
      'price_dzd': priceDzd,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props =>
      [id, title, description, imageUrls,  materialType, priceDzd, createdAt];
}