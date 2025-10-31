import 'package:weather/core/interfaces/rest_client.dart';

export 'package:weather/core/interfaces/rest_client.dart'
    show NetworkConnectionException, NetworkTimeoutException;

class WeatherApiService {
  WeatherApiService({required RestClient restClient})
    : _restClient = restClient;

  final RestClient _restClient;

  static const _apiKey = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
    defaultValue: '',
  );

  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> getWeather(
    double latitude,
    double longitude,
  ) async {
    final response = await _restClient.get(
      '$_baseUrl/weather',
      queryParameters: {
        'lat': latitude,
        'lon': longitude,
        'exclude': 'minutely,hourly,alerts',
        'appid': _apiKey,
        'units': 'metric',
      },
    );

    switch (response.statusCode) {
      case 200:
        return response.data as Map<String, dynamic>;
      case 429:
        throw RateLimitException();
      case 400:
      case 401:
      case 403:
      case 404:
        throw ApiClientException();
      default:
        throw ApiServerException();
    }
  }
}

class RateLimitException implements Exception {}

class ApiClientException implements Exception {}

class ApiServerException implements Exception {}
