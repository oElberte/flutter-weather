import 'package:flutter/material.dart';
import 'package:weather/features/auth/presentation/splash_screen.dart';
import 'package:weather/features/weather/presentation/weather_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String weather = '/weather';

  static Widget getPageForRoute(String? route) {
    switch (route) {
      case weather:
        return WeatherScreen.withProviders();
      default:
        return const SplashScreen();
    }
  }
}
