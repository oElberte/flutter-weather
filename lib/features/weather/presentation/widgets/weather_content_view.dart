import 'package:flutter/material.dart';
import 'package:weather/features/weather/domain/weather_data.dart';
import 'package:weather/features/weather/presentation/widgets/city_header.dart';
import 'package:weather/features/weather/presentation/widgets/current_weather_card.dart';
import 'package:weather/features/weather/presentation/widgets/daily_forecast_list.dart';
import 'package:weather/features/weather/presentation/widgets/last_updated_text.dart';
import 'package:weather/features/weather/presentation/widgets/sun_times_card.dart';
import 'package:weather/features/weather/presentation/widgets/weather_details_card.dart';

class WeatherContentView extends StatelessWidget {
  const WeatherContentView({
    super.key,
    required this.weatherData,
    required this.onRefresh,
    this.isRefreshing = false,
    this.hasError = false,
  });

  final WeatherData weatherData;
  final Future<void> Function() onRefresh;
  final bool isRefreshing;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth;
          if (constraints.maxWidth < 600) {
            maxWidth = double.infinity;
          } else if (constraints.maxWidth < 1200) {
            maxWidth = 600;
          } else {
            maxWidth = 800;
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CityHeader(cityName: weatherData.cityName),
                    const SizedBox(height: 24),
                    CurrentWeatherCard(weatherData: weatherData),
                    const SizedBox(height: 24),
                    WeatherDetailsCard(weatherData: weatherData),
                    const SizedBox(height: 24),
                    SunTimesCard(weatherData: weatherData),
                    if (weatherData.dailyForecast.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      DailyForecastList(forecasts: weatherData.dailyForecast),
                    ],
                    const SizedBox(height: 16),
                    LastUpdatedText(timestamp: weatherData.timestamp),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
