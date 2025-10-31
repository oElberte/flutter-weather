abstract class RestClient {
  Future<RestResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });

  Future<RestResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });

  Future<RestResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });

  Future<RestResponse> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });
}

class RestResponse {
  RestResponse({
    required this.data,
    required this.statusCode,
    this.statusMessage,
  });

  final dynamic data;
  final int statusCode;
  final String? statusMessage;
}
