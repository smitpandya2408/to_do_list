import 'package:dio/dio.dart';
import 'package:modern_flutter_app/models/product_models.dart';
import 'package:modern_flutter_app/services/api_client.dart';

class ProductsService {
  final Dio _dio = ApiClient().dio;
  static const String _baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    final response = await _dio.get('$_baseUrl/products');
    final list = response.data as List<dynamic>;
    return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }
}
