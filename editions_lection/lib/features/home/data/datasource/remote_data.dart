// remote_data.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/material.dart';
import '../models/order_model.dart';
import '../../domain/entities/order.dart';

abstract class HomeRemoteDataSource {
  Future<List<MaterialEntity>> getBooks();
  Future<List<MaterialEntity>> getPolycopies();
  Future<List<MaterialEntity>> searchMaterialsByTitle(String title);
  Future<List<OrderEntity>> getOrders(String token);
  Future<bool> createOrder(List<OrderCreateModel> orders, String token);
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
      Uri.parse('$baseUrl/materials/filter/user?material_type=polycop'),
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
  Future<bool> createOrder(List<OrderCreateModel> orders, String token) async {
    final response = await client.post(
      Uri.parse(
        '$baseUrl/orders/',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(orders.map((e) => e.toJson()).toList()),
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

  @override
  Future<List<OrderEntity>> getOrders(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/orders/my'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final orders = (json.decode(response.body) as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
      return orders;
    } else {
      throw ServerException(
          message: json.decode(response.body)['message'] ?? 'Server Error');
    }
  }
}
