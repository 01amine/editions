import 'package:editions_lection/features/home/domain/entities/material.dart';

class MaterialModel extends MaterialEntity {
  const MaterialModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrls,
    required super.materialType,
    required super.priceDzd,
    required super.createdAt,
    required super.studyYear,
    required super.specialite,
    required super.module,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      imageUrls: json['image_urls'] != null
          ? List<String>.from(json['image_urls'])
          : [],
      materialType: json['material_type'],
      priceDzd: json['price_dzd'],
      createdAt: DateTime.parse(json['created_at']),
      studyYear: json['study_year']?.toString() ?? '',
      specialite: json['specialite']?.toString() ?? '',
      module: json['module']?.toString() ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'image_urls': imageUrls,
      'material_type': materialType,
      'price_dzd': priceDzd,
      'created_at': createdAt.toIso8601String(),
      'study_year': studyYear,
      'specialite': specialite,
      'module': module,
    };
  }
}
