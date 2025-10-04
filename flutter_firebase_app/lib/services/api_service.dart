import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const String baseListUrl = 'https://fakestoreapi.com/products';
  static const String baseDetailUrl = 'https://jsonplaceholder.typicode.com/users/1';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseListUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body) as List<dynamic>;
      return jsonList.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to fetch products: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> fetchUserDetail() async {
    final response = await http.get(Uri.parse(baseDetailUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to fetch user detail: ${response.statusCode}');
  }
}
