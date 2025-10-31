import 'package:weather/features/weather/domain/weather_data.dart';

sealed class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {
  WeatherLoading({this.cachedData});

  final WeatherData? cachedData;
}

class WeatherLoaded extends WeatherState {
  WeatherLoaded(this.weatherData);

  final WeatherData weatherData;
}

class WeatherError extends WeatherState {
  WeatherError(this.message, {this.cachedData});

  final String message;
  final WeatherData? cachedData;
}
