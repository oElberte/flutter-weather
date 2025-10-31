import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/features/weather/domain/weather_data.dart';
import 'package:weather/shared/utils/weather_icon_helper.dart';

class DailyForecastCard extends StatelessWidget {
  const DailyForecastCard({
    super.key,
    required this.forecast,
    required this.isToday,
  });

  final DailyForecast forecast;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final day = isToday ? 'Today' : DateFormat('EEE').format(forecast.date);

    return Card(
      margin: const EdgeInsets.only(right: 12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Icon(
              WeatherIconHelper.getIcon(forecast.iconCode),
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              '${forecast.tempMax.round()}°',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '${forecast.tempMin.round()}°',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
