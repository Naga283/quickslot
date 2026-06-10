import 'package:dio/dio.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<User> createUser({required String name, required String email}) async {
    try {
      final response = await _dio.post(
        '/users',
        data: {'name': name, 'email': email},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return User.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create user');
    }
  }

  @override
  Future<User> getUserById(String id) async {
    try {
      final response = await _dio.get('/users/$id');
      final data = response.data['data'] as Map<String, dynamic>;
      return User.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'User not found');
    }
  }
}
