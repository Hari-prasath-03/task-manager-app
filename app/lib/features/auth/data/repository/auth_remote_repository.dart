import 'package:dio/dio.dart';
import 'package:task_manager/core/services/sp_service.dart';
import 'package:task_manager/features/auth/data/repository/auth_local_repository.dart';
import 'package:task_manager/features/auth/domain/user_model.dart';

class AuthRemoteRepository {
  final SPService _spService;
  final AuthLocalRepository _authLocalRepository;
  final Dio _dio;

  AuthRemoteRepository({
    required this._spService,
    required this._authLocalRepository,
    required this._dio,
  });

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _dio.post(
        '/auth/signup',
        data: {'name': name, 'email': email, 'password': password},
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? e.message ?? 'Failed to sign up',
      );
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final user = UserModel.fromMap(response.data as Map<String, dynamic>);

      await _spService.setToken(user.token);
      await _authLocalRepository.insertUser(user);

      return user;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? e.message ?? 'Failed to log in',
      );
    }
  }

  Future<UserModel?> getUserData() async {
    final token = await _spService.getToken();
    if (token == null || token.isEmpty) return null;

    try {
      final response = await _dio.get(
        '/auth/me',
        options: Options(headers: {'x-auth-token': token}),
      );
      final user = UserModel.fromMap(response.data as Map<String, dynamic>);

      await _authLocalRepository.insertUser(user);

      return user;
    } on DioException {
      return await _authLocalRepository.getUser();
    }
  }
}
