class LoginRequest {
  final String email;
  final String password;
  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class LoginResponse {
  final String token;
  final String? name;
  const LoginResponse({required this.token, this.name});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      LoginResponse(token: json['token'] as String, name: json['name'] as String?);
}

class RegisterRequest {
  final String name;
  final String email;
  final String password;
  const RegisterRequest({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
      };
}

class RegisterResponse {
  final String token;
  const RegisterResponse({required this.token});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(token: json['token'] as String);
}
