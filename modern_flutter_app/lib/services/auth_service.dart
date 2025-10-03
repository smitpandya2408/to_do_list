import 'package:dio/dio.dart';
import 'package:modern_flutter_app/models/auth_models.dart';
import 'package:modern_flutter_app/services/api_client.dart';

class AuthService {
  static const String _baseUrl = 'https://reqres.in/api';
  final Dio _dio = ApiClient().dio;

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post('$_baseUrl/login', data: request.toJson());
    // reqres returns only token; we keep name in storage elsewhere
    return LoginResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await _dio.post('$_baseUrl/register', data: request.toJson());
    return RegisterResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
