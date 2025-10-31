import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather/core/config/routes.dart';
import 'package:weather/core/di/providers.dart';
import 'package:weather/core/mixins/snackbar_mixin.dart';
import 'package:weather/features/auth/presentation/auth_cubit.dart';
import 'package:weather/features/weather/data/weather_repository.dart';
import 'package:weather/features/weather/presentation/weather_cubit.dart';
import 'package:weather/features/weather/presentation/weather_state.dart';
import 'package:weather/features/weather/presentation/widgets/weather_content_view.dart';
import 'package:weather/features/weather/presentation/widgets/weather_error_view.dart';
import 'package:weather/features/weather/presentation/widgets/weather_loading_view.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  static Widget withProviders() => MultiProvider(
    providers: AppProviders.weather(),
    child: BlocProvider(
      create: (context) =>
          WeatherCubit(weatherRepository: context.read<WeatherRepository>()),
      child: const WeatherScreen(),
    ),
  );

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> with SnackbarMixin {
  @override
  void initState() {
    super.initState();
    context.read<WeatherCubit>().loadWeather();
  }

  Future<void> _onRefresh() async {
    await context.read<WeatherCubit>().refreshWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            },
          ),
        ],
      ),
      body: BlocConsumer<WeatherCubit, WeatherState>(
        listener: (context, state) {
          if (state is WeatherError && state.cachedData == null) {
            showError(context, state.message);
          } else if (state is WeatherLoading && state.cachedData != null) {
            showInfo(
              context,
              'Showing cached data. Check your internet connection.',
            );
          }
        },
        builder: (context, state) {
          switch (state) {
            case WeatherInitial():
              return const SizedBox.shrink();
            case WeatherLoading():
              if (state.cachedData != null) {
                return WeatherContentView(
                  weatherData: state.cachedData!,
                  onRefresh: _onRefresh,
                  isRefreshing: true,
                );
              } else {
                return const WeatherLoadingView();
              }
            case WeatherLoaded():
              return WeatherContentView(
                weatherData: state.weatherData,
                onRefresh: _onRefresh,
              );
            case WeatherError():
              if (state.cachedData != null) {
                return WeatherContentView(
                  weatherData: state.cachedData!,
                  onRefresh: _onRefresh,
                  hasError: true,
                );
              } else {
                return WeatherErrorView(message: state.message);
              }
          }
        },
      ),
    );
  }
}
