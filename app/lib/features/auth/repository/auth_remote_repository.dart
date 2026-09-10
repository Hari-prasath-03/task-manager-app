import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_manager/core/constants/constants.dart';
import 'package:task_manager/core/services/sp_service.dart';
import 'package:task_manager/models/user_model.dart';

class AuthRemoteRepository {
  final _spService = SPService();

  Future<void> signIn({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.baseUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['message'] ?? 'Failed to sign in';
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['message'] ?? 'Failed to log in';
      }

      return UserModel.fromJson(res.body);
    } catch (e) {
      throw Exception('Failed to log in: $e');
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await _spService.getToken();
      if (token == null || token.isEmpty) {
        return null;
      }

      final res = await http.get(
        Uri.parse('${Constants.baseUrl}/auth/me'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['message'] ?? 'Failed to fetch user data';
      }

      return UserModel.fromJson(res.body);
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }
}
