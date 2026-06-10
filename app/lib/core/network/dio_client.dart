import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final defaultHost = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? '10.198.99.162'
      : 'localhost';

  final options = BaseOptions(
    baseUrl:
        const String.fromEnvironment('API_BASE_URL', defaultValue: '').isEmpty
        ? 'https://quickslot-bmgn.onrender.com/api'
        : const String.fromEnvironment('API_BASE_URL'),
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );

  final dio = Dio(options);

  dio.interceptors.add(
    LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
    ),
  );

  return dio;
}
