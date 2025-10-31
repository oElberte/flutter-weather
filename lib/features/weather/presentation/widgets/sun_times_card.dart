import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/features/weather/domain/weather_data.dart';
import 'package:weather/features/weather/presentation/widgets/weather_detail_item.dart';

class SunTimesCard extends StatelessWidget {
  const SunTimesCard({super.key, required this.weatherData});

  final WeatherData weatherData;

  @override
  Widget build(BuildContext context) {
    final sunriseTime = DateFormat('HH:mm').format(weatherData.sunrise);
    final sunsetTime = DateFormat('HH:mm').format(weatherData.sunset);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            WeatherDetailItem(
              icon: Icons.wb_sunny,
              label: 'Sunrise',
              value: sunriseTime,
            ),
            WeatherDetailItem(
              icon: Icons.nightlight_round,
              label: 'Sunset',
              value: sunsetTime,
            ),
          ],
        ),
      ),
    );
  }
}
