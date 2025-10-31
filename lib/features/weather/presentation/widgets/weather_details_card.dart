import 'package:flutter/material.dart';
import 'package:weather/features/weather/domain/weather_data.dart';
import 'package:weather/features/weather/presentation/widgets/weather_detail_item.dart';

class WeatherDetailsCard extends StatelessWidget {
  const WeatherDetailsCard({super.key, required this.weatherData});

  final WeatherData weatherData;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            WeatherDetailItem(
              icon: Icons.water_drop,
              label: 'Humidity',
              value: '${weatherData.humidity}%',
            ),
            WeatherDetailItem(
              icon: Icons.air,
              label: 'Wind',
              value: '${weatherData.windSpeed.toStringAsFixed(1)} m/s',
            ),
          ],
        ),
      ),
    );
  }
}
