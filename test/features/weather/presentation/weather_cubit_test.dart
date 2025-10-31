import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather/core/services/location_service.dart';
import 'package:weather/features/weather/data/weather_repository.dart';
import 'package:weather/features/weather/domain/weather_data.dart';
import 'package:weather/features/weather/presentation/weather_cubit.dart';
import 'package:weather/features/weather/presentation/weather_state.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late WeatherCubit cubit;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    cubit = WeatherCubit(weatherRepository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('WeatherCubit', () {
    final testWeather = WeatherData(
      cityName: 'Test City',
      temperature: 25.0,
      feelsLike: 26.0,
      description: 'clear sky',
      iconCode: '01d',
      humidity: 70,
      windSpeed: 5.5,
      sunrise: DateTime.now(),
      sunset: DateTime.now(),
      dailyForecast: [],
      timestamp: DateTime.now(),
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [WeatherLoading, WeatherLoaded] when loadWeather succeeds',
      build: () {
        when(() => mockRepository.getCachedWeather()).thenReturn(null);
        when(
          () => mockRepository.getWeather(),
        ).thenAnswer((_) async => testWeather);
        return cubit;
      },
      act: (cubit) => cubit.loadWeather(),
      wait: const Duration(milliseconds: 400),
      expect: () => [isA<WeatherLoading>(), isA<WeatherLoaded>()],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [WeatherLoading, WeatherError] when location permission denied',
      build: () {
        when(() => mockRepository.getCachedWeather()).thenReturn(null);
        when(
          () => mockRepository.getWeather(),
        ).thenThrow(LocationPermissionDeniedException());
        return cubit;
      },
      act: (cubit) => cubit.loadWeather(),
      wait: const Duration(milliseconds: 400),
      expect: () => [isA<WeatherLoading>(), isA<WeatherError>()],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [WeatherLoading with cache] when cached data exists',
      build: () {
        when(() => mockRepository.getCachedWeather()).thenReturn(testWeather);
        when(
          () => mockRepository.getWeather(),
        ).thenAnswer((_) async => testWeather);
        return cubit;
      },
      act: (cubit) => cubit.loadWeather(),
      wait: const Duration(milliseconds: 400),
      expect: () => [
        isA<WeatherLoading>().having(
          (state) => state.cachedData,
          'cachedData',
          isNotNull,
        ),
        isA<WeatherLoaded>(),
      ],
    );
  });
}
