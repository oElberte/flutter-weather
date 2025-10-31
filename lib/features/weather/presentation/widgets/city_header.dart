import 'package:flutter/material.dart';

class CityHeader extends StatelessWidget {
  const CityHeader({super.key, required this.cityName});

  final String cityName;

  @override
  Widget build(BuildContext context) {
    return Text(
      cityName,
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}
