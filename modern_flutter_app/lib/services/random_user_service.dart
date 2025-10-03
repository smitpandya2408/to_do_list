import 'package:dio/dio.dart';
import 'package:modern_flutter_app/services/api_client.dart';

class RandomUserDetail {
  final String fullName;
  final String email;
  final String avatarUrl;
  final String city;
  final String country;

  const RandomUserDetail({
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.city,
    required this.country,
  });
}

class RandomUserService {
  final Dio _dio = ApiClient().dio;

  Future<RandomUserDetail> fetchUser() async {
    final response = await _dio.get('https://randomuser.me/api/');
    final data = (response.data as Map<String, dynamic>)['results'][0] as Map<String, dynamic>;
    final name = data['name'] as Map<String, dynamic>;
    final location = data['location'] as Map<String, dynamic>;

    return RandomUserDetail(
      fullName: '${name['first']} ${name['last']}',
      email: data['email'] as String,
      avatarUrl: (data['picture'] as Map<String, dynamic>)['large'] as String,
      city: (location['city'] as String),
      country: (location['country'] as String),
    );
  }
}
