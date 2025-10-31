import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/core/services/location_service.dart';
import 'package:weather/core/services/weather_api_service.dart';
import 'package:weather/features/weather/data/weather_repository.dart';
import 'package:weather/features/weather/presentation/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit({required WeatherRepository weatherRepository})
    : _weatherRepository = weatherRepository,
      super(WeatherInitial());

  final WeatherRepository _weatherRepository;
  Timer? _autoRefreshTimer;

  Future<void> loadWeather() async {
    final cachedData = _weatherRepository.getCachedWeather();
    emit(WeatherLoading(cachedData: cachedData));

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final weatherData = await _weatherRepository.getWeather();
      emit(WeatherLoaded(weatherData));
      _startAutoRefresh();
    } on LocationServiceDisabledException {
      emit(
        WeatherError(
          'Please turn on location services.',
          cachedData: cachedData,
        ),
      );
    } on LocationPermissionDeniedException {
      emit(
        WeatherError(
          'Location permission is required. Please enable it in settings.',
          cachedData: cachedData,
        ),
      );
    } on LocationPermissionPermanentlyDeniedException {
      emit(
        WeatherError(
          'Location permission is required. Please enable it in settings.',
          cachedData: cachedData,
        ),
      );
    } on NetworkConnectionException {
      emit(
        WeatherError(
          "Can't connect to weather service. Check your internet.",
          cachedData: cachedData,
        ),
      );
    } on NetworkTimeoutException {
      emit(
        WeatherError(
          "Can't connect to weather service. Check your internet.",
          cachedData: cachedData,
        ),
      );
    } on RateLimitException {
      emit(
        WeatherError(
          'Too many requests. Please wait a moment.',
          cachedData: cachedData,
        ),
      );
    } on ApiServerException {
      emit(
        WeatherError(
          'Weather service temporarily unavailable. Try again later.',
          cachedData: cachedData,
        ),
      );
    } catch (_) {
      emit(
        WeatherError(
          "Couldn't load weather information. Please try again.",
          cachedData: cachedData,
        ),
      );
    }
  }

  Future<void> refreshWeather() async {
    final currentState = state;
    final cachedData = currentState is WeatherLoaded
        ? currentState.weatherData
        : currentState is WeatherError
        ? currentState.cachedData
        : _weatherRepository.getCachedWeather();

    emit(WeatherLoading(cachedData: cachedData));

    try {
      final weatherData = await _weatherRepository.getWeather();
      emit(WeatherLoaded(weatherData));
    } catch (e) {
      if (currentState is WeatherLoaded) {
        emit(WeatherLoaded(currentState.weatherData));
      } else {
        await loadWeather();
      }
    }
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) => refreshWeather(),
    );
  }

  @override
  Future<void> close() {
    _autoRefreshTimer?.cancel();
    return super.close();
  }
}
