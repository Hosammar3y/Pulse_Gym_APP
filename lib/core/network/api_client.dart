import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/config/app_config.dart';
import 'api_exception.dart';
import 'auth_interceptor.dart';

final apiClientProvider = Provider<ApiClient>((ref) => throw UnimplementedError('ApiClient is provided during bootstrap.'));

class ApiClient {
  ApiClient({required Future<String?> Function() tokenReader})
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.current().api.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 30),
            headers: const <String, String>{'Accept': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(AuthInterceptor(readToken: tokenReader));
  }

  final Dio _dio;

  Dio get raw => _dio;

  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get<dynamic>(path, queryParameters: queryParameters);
      return response.data as T;
    } on DioException catch (error) {
      throw _map(error);
    }
  }

  Future<T> post<T>(String path, {Object? data}) async {
    try {
      final response = await _dio.post<dynamic>(path, data: data);
      return response.data as T;
    } on DioException catch (error) {
      throw _map(error);
    }
  }

  Future<T> patch<T>(String path, {Object? data}) async {
    try {
      final response = await _dio.patch<dynamic>(path, data: data);
      return response.data as T;
    } on DioException catch (error) {
      throw _map(error);
    }
  }

  Future<T> delete<T>(String path, {Object? data}) async {
    try {
      final response = await _dio.delete<dynamic>(path, data: data);
      return response.data as T;
    } on DioException catch (error) {
      throw _map(error);
    }
  }

  ApiException _map(DioException error) {
    final response = error.response;
    final data = response?.data;
    final message = data is Map<String, dynamic>
        ? (data['message']?.toString() ?? error.message ?? 'Request failed.')
        : (error.message ?? 'Request failed.');
    final code = data is Map<String, dynamic> ? data['code']?.toString() : null;
    return ApiException(message, code: code, statusCode: response?.statusCode);
  }
}
