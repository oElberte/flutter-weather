import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/core/interfaces/local_storage.dart';
import 'package:weather/core/services/location_service.dart';
import 'package:weather/core/services/shared_preferences_storage.dart';
import 'package:weather/core/services/weather_api_service.dart';
import 'package:weather/features/weather/data/weather_repository.dart';

class MockWeatherApiService extends Mock implements WeatherApiService {}

class MockLocationService extends Mock implements LocationService {}

void main() {
  late WeatherRepository repository;
  late MockWeatherApiService mockApiService;
  late MockLocationService mockLocationService;
  late LocalStorage storage;

  setUp(() async {
    SharedPreferencesStorage.resetInstance();
    SharedPreferences.setMockInitialValues({});
    storage = await SharedPreferencesStorage.getInstance();
    mockApiService = MockWeatherApiService();
    mockLocationService = MockLocationService();
    repository = WeatherRepository(
      weatherApi: mockApiService,
      locationService: mockLocationService,
      storage: storage,
    );
  });

  group('WeatherRepository', () {
    final mockPosition = Position(
      latitude: 40.7128,
      longitude: -74.0060,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

    final mockWeatherJson = {
      'name': 'New York',
      'main': {'temp': 25.5, 'feels_like': 26.0, 'humidity': 70},
      'weather': [
        {'description': 'clear sky', 'icon': '01d'},
      ],
      'wind': {'speed': 5.5},
      'sys': {'sunrise': 1609459200, 'sunset': 1609495200},
    };

    test('should fetch and cache weather data successfully', () async {
      when(
        () => mockLocationService.getCurrentPosition(),
      ).thenAnswer((_) async => mockPosition);
      when(
        () => mockApiService.getWeather(any(), any()),
      ).thenAnswer((_) async => mockWeatherJson);

      final result = await repository.getWeather();

      expect(result.cityName, 'New York');
      expect(result.temperature, 25.5);
      expect(result.humidity, 70);
      expect(repository.getCachedWeather(), isNotNull);
    });

    test('should retrieve cached weather data', () async {
      when(
        () => mockLocationService.getCurrentPosition(),
      ).thenAnswer((_) async => mockPosition);
      when(
        () => mockApiService.getWeather(any(), any()),
      ).thenAnswer((_) async => mockWeatherJson);

      await repository.getWeather();

      final cached = repository.getCachedWeather();
      expect(cached, isNotNull);
      expect(cached!.cityName, 'New York');
      expect(cached.temperature, 25.5);
    });

    test('should return null when no cached data exists', () {
      final cached = repository.getCachedWeather();
      expect(cached, isNull);
    });

    test('should clear cached weather data', () async {
      when(
        () => mockLocationService.getCurrentPosition(),
      ).thenAnswer((_) async => mockPosition);
      when(
        () => mockApiService.getWeather(any(), any()),
      ).thenAnswer((_) async => mockWeatherJson);

      await repository.getWeather();
      await repository.clearCache();

      final cached = repository.getCachedWeather();
      expect(cached, isNull);
    });
  });
}
