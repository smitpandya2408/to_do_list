import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Dio get dio => _dio;
}
