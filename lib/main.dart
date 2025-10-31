import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather/core/config/routes.dart';
import 'package:weather/core/di/providers.dart';
import 'package:weather/features/auth/presentation/login_screen.dart';
import 'package:weather/features/auth/presentation/splash_screen.dart';
import 'package:weather/features/weather/presentation/weather_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.core(),
      child: MultiBlocProvider(
        providers: AppBlocProviders.core(),
        child: MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (_) => const SplashScreen(),
            AppRoutes.login: (_) => const LoginScreen(),
            AppRoutes.weather: (_) => WeatherScreen.withProviders(),
          },
        ),
      ),
    );
  }
}
