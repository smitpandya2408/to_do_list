import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modern_flutter_app/models/auth_models.dart';
import 'package:modern_flutter_app/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final String? token;
  final String? userName;
  final bool isLoading;
  final String? error;

  const AuthState({this.token, this.userName, this.isLoading = false, this.error});

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  AuthState copyWith({String? token, String? userName, bool? isLoading, String? error}) => AuthState(
        token: token ?? this.token,
        userName: userName ?? this.userName,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class AuthController extends AsyncNotifier<AuthState> {
  static const _keyToken = 'auth_token';
  static const _keyName = 'user_name';

  final AuthService _authService = AuthService();
  late SharedPreferences _prefs;

  @override
  Future<AuthState> build() async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString(_keyToken);
    final name = _prefs.getString(_keyName);
    return AuthState(token: token, userName: name);
  }

  Future<bool> login(String email, String password) async {
    try {
      final current = state.value ?? const AuthState();
      state = AsyncData(current.copyWith(isLoading: true, error: null));
      final res = await _authService.login(LoginRequest(email: email, password: password));
      final inferredName = email.split('@').first;
      await _prefs.setString(_keyToken, res.token);
      await _prefs.setString(_keyName, inferredName);
      state = AsyncData(AuthState(token: res.token, userName: inferredName));
      return true;
    } on DioException catch (e) {
      final msg = e.response?.data.toString() ?? e.message;
      final current = state.value ?? const AuthState();
      state = AsyncData(current.copyWith(isLoading: false, error: msg));
      return false;
    } catch (e) {
      final current = state.value ?? const AuthState();
      state = AsyncData(current.copyWith(isLoading: false, error: e.toString()));
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final current = state.value ?? const AuthState();
      state = AsyncData(current.copyWith(isLoading: true, error: null));
      final res = await _authService.register(RegisterRequest(name: name, email: email, password: password));
      await _prefs.setString(_keyToken, res.token);
      await _prefs.setString(_keyName, name);
      state = AsyncData(AuthState(token: res.token, userName: name));
      return true;
    } on DioException catch (e) {
      final msg = e.response?.data.toString() ?? e.message;
      final current = state.value ?? const AuthState();
      state = AsyncData(current.copyWith(isLoading: false, error: msg));
      return false;
    } catch (e) {
      final current = state.value ?? const AuthState();
      state = AsyncData(current.copyWith(isLoading: false, error: e.toString()));
      return false;
    }
  }

  Future<void> logout() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyName);
    state = const AsyncData(AuthState());
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(() => AuthController());
