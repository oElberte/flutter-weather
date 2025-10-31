import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:weather/core/interfaces/rest_client.dart';

class DioRestClient implements RestClient {
  DioRestClient();

  final Dio _dio = Dio(
    BaseOptions(
      sendTimeout: kIsWeb ? null : const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  @override
  Future<RestResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) async {
    final response = await _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers, receiveTimeout: timeout),
    );

    return RestResponse(
      data: response.data,
      statusCode: response.statusCode ?? 0,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<RestResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) async {
    final response = await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers, receiveTimeout: timeout),
    );

    return RestResponse(
      data: response.data,
      statusCode: response.statusCode ?? 0,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<RestResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) async {
    final response = await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers, receiveTimeout: timeout),
    );

    return RestResponse(
      data: response.data,
      statusCode: response.statusCode ?? 0,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<RestResponse> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) async {
    final response = await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers, receiveTimeout: timeout),
    );

    return RestResponse(
      data: response.data,
      statusCode: response.statusCode ?? 0,
      statusMessage: response.statusMessage,
    );
  }
}
