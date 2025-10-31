import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather/core/interfaces/local_storage.dart';
import 'package:weather/core/interfaces/rest_client.dart';
import 'package:weather/core/services/auth_service.dart';
import 'package:weather/core/services/dio_rest_client.dart';
import 'package:weather/core/services/location_service.dart';
import 'package:weather/core/services/shared_preferences_storage.dart';
import 'package:weather/core/services/weather_api_service.dart';
import 'package:weather/features/auth/data/auth_repository.dart';
import 'package:weather/features/auth/presentation/auth_cubit.dart';
import 'package:weather/features/auth/presentation/login_screen.dart';
import 'package:weather/features/auth/presentation/splash_screen.dart';
import 'package:weather/features/weather/data/weather_repository.dart';
import 'package:weather/features/weather/presentation/weather_cubit.dart';
import 'package:weather/features/weather/presentation/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalStorage>(create: (context) => SharedPreferencesStorage()),
        Provider<RestClient>(create: (context) => DioRestClient()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => WeatherCubit(
              weatherRepository: context.read<WeatherRepository>(),
            ),
          ),
        ],
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
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => MultiProvider(
              providers: [
                Provider<AuthService>(
                  create: (context) =>
                      AuthService(context.read<LocalStorage>()),
                ),
                Provider<AuthRepository>(
                  create: (context) =>
                      AuthRepository(context.read<AuthService>()),
                ),
              ],
              child: const LoginScreen(),
            ),
            '/weather': (context) => MultiProvider(
              providers: [
                Provider<WeatherApiService>(
                  create: (context) =>
                      WeatherApiService(restClient: context.read<RestClient>()),
                ),
                Provider<LocationService>(
                  create: (context) => LocationService(),
                ),
                Provider<WeatherRepository>(
                  create: (context) => WeatherRepository(
                    weatherApi: context.read<WeatherApiService>(),
                    locationService: context.read<LocationService>(),
                    storage: context.read<LocalStorage>(),
                  ),
                ),
              ],
              child: const WeatherScreen(),
            ),
          },
        ),
      ),
    );
  }
}
