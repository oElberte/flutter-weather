import 'dart:convert';
import 'package:weather/core/interfaces/local_storage.dart';
import 'package:weather/core/services/location_service.dart';
import 'package:weather/core/services/weather_api_service.dart';
import 'package:weather/features/weather/domain/weather_data.dart';

class WeatherRepository {
  WeatherRepository({
    required WeatherApiService weatherApi,
    required LocationService locationService,
    required LocalStorage storage,
  }) : _weatherApi = weatherApi,
       _locationService = locationService,
       _storage = storage;

  final WeatherApiService _weatherApi;
  final LocationService _locationService;
  final LocalStorage _storage;

  static const String _cacheKey = 'weather_cache';

  Future<WeatherData> getWeather() async {
    final position = await _locationService.getCurrentPosition();

    final weatherJson = await _weatherApi.getWeather(
      position.latitude,
      position.longitude,
    );

    final weatherData = WeatherData.fromJson(weatherJson);

    await _cacheWeather(weatherData);

    return weatherData;
  }

  WeatherData? getCachedWeather() {
    final cachedJson = _storage.getString(_cacheKey);
    if (cachedJson == null) return null;

    try {
      final json = jsonDecode(cachedJson) as Map<String, dynamic>;
      return WeatherData.fromCache(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> _cacheWeather(WeatherData data) async {
    final json = jsonEncode(data.toJson());
    await _storage.setString(_cacheKey, json);
  }

  Future<void> clearCache() async {
    await _storage.remove(_cacheKey);
  }
}
