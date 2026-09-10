import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product.dart';

class ProductApiService {
  Future<List<Product>> fetchProducts(int skip) async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products?limit=20&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<Product> fetchProduct(int id) async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products/$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to fetch product');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products/search?q=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to search products');
    }
  }
}
