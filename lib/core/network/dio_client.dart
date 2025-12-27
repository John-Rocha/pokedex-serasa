import 'package:dio/dio.dart';

abstract class RestClient {
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
}

class DioClient implements RestClient {
  final Dio _dio;

  DioClient({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
