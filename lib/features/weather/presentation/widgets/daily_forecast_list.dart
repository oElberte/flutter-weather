import 'package:flutter/material.dart';
import 'package:weather/features/weather/domain/weather_data.dart';
import 'package:weather/features/weather/presentation/widgets/daily_forecast_card.dart';

class DailyForecastList extends StatelessWidget {
  const DailyForecastList({super.key, required this.forecasts});

  final List<DailyForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '7-Day Forecast',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecasts.length,
            itemBuilder: (context, index) {
              return DailyForecastCard(
                forecast: forecasts[index],
                isToday: index == 0,
              );
            },
          ),
        ),
      ],
    );
  }
}
