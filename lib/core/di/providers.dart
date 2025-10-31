import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather/core/interfaces/local_storage.dart';
import 'package:weather/core/interfaces/rest_client.dart';
import 'package:weather/core/services/auth_service.dart';
import 'package:weather/core/services/dio_rest_client.dart';
import 'package:weather/core/services/location_service.dart';
import 'package:weather/core/services/weather_api_service.dart';
import 'package:weather/features/auth/data/auth_repository.dart';
import 'package:weather/features/auth/presentation/auth_cubit.dart';
import 'package:weather/features/weather/data/weather_repository.dart';

class AppProviders {
  static List<Provider<dynamic>> core(LocalStorage storage) => [
    Provider<LocalStorage>(
      create: (context) => storage,
    ),
    Provider<RestClient>(
      create: (context) => DioRestClient(),
    ),
    Provider<AuthService>(
      create: (context) => AuthService(
        context.read<LocalStorage>(),
      ),
    ),
    Provider<AuthRepository>(
      create: (context) => AuthRepository(
        context.read<AuthService>(),
      ),
    ),
  ];

  static List<Provider<dynamic>> weather() => [
    Provider<WeatherApiService>(
      create: (context) => WeatherApiService(
        restClient: context.read<RestClient>(),
      ),
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
  ];
}

class AppBlocProviders {
  static List<BlocProvider> core() => [
    BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(
        authRepository: context.read<AuthRepository>(),
      ),
    ),
  ];
}
