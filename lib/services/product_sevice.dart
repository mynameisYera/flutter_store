import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    final response = await rootBundle.loadString('assets/products.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> fetchProductById(String id) async {
    final response = await rootBundle.loadString('assets/products.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Product.fromJson(json)).firstWhere((product) => product.id == id);
  }
}
