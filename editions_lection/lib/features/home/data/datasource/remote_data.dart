// remote_data.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/material.dart';

abstract class HomeRemoteDataSource {
  Future<List<MaterialEntity>> getBooks();
  Future<List<MaterialEntity>> getPolycopies();
  Future<List<MaterialEntity>> searchMaterialsByTitle(String title);
  Future<bool> createOrder(List<String> materialIds);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  HomeRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<List<MaterialEntity>> getBooks() async {
    final response = await client.get(
      Uri.parse('$baseUrl/materials/filter/user?material_type=book'),
    );

    if (response.statusCode == 200) {
      final materials = (json.decode(response.body) as List)
          .map((e) => MaterialEntity.fromJson(e))
          .toList();
      return materials;
    } else {
      throw ServerException(
          message: json.decode(response.body)['message'] ?? 'Server Error');
    }
  }

  @override
  Future<List<MaterialEntity>> getPolycopies() async {
    final response = await client.get(
      Uri.parse('$baseUrl/materials/filter/user?material_type=polycopie'),
    );

    if (response.statusCode == 200) {
      final materials = (json.decode(response.body) as List)
          .map((e) => MaterialEntity.fromJson(e))
          .toList();
      return materials;
    } else {
      throw ServerException(
          message: json.decode(response.body)['message'] ?? 'Server Error');
    }
  }

  @override
  Future<bool> createOrder(List<String> materialIds) async {
    final response = await client.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'materials': materialIds}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException(
          message: json.decode(response.body)['message'] ?? 'Server Error');
    }
  }

  @override
  Future<List<MaterialEntity>> searchMaterialsByTitle(String title) async {
    final response = await client.get(
      Uri.parse('$baseUrl/materials/filter/user?title=$title'),
    );

    if (response.statusCode == 200) {
      final materials = (json.decode(response.body) as List)
          .map((e) => MaterialEntity.fromJson(e))
          .toList();
      return materials;
    } else {
      throw ServerException(
          message: json.decode(response.body)['message'] ?? 'Server Error');
    }
  }
}
