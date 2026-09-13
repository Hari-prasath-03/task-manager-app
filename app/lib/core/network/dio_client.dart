import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal();

  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.120.250.150:8000',
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
