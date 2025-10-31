import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather/core/config/routes.dart';
import 'package:weather/core/di/providers.dart';
import 'package:weather/core/services/shared_preferences_storage.dart';
import 'package:weather/features/auth/presentation/auth_cubit.dart';
import 'package:weather/features/auth/presentation/auth_state.dart';
import 'package:weather/features/auth/presentation/login_screen.dart';
import 'package:weather/features/auth/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await SharedPreferencesStorage.getInstance();
  runApp(MyApp(storage: storage));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.storage});

  final SharedPreferencesStorage storage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.core(storage),
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
          onGenerateRoute: (settings) {
            if (settings.name == AppRoutes.splash) {
              return MaterialPageRoute(
                builder: (_) => const SplashScreen(),
                settings: settings,
              );
            }
            if (settings.name == AppRoutes.login) {
              return MaterialPageRoute(
                builder: (_) => const LoginScreen(),
                settings: settings,
              );
            }

            return MaterialPageRoute(
              builder: (context) =>
                  _AuthCheck(child: AppRoutes.getPageForRoute(settings.name)),
              settings: settings,
            );
          },
        ),
      ),
    );
  }
}

class _AuthCheck extends StatefulWidget {
  const _AuthCheck({required this.child});

  final Widget child;

  @override
  State<_AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<_AuthCheck> {
  void _checkAuthStatus() {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      context.read<AuthCubit>().checkAuthStatus();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  @override
  void didUpdateWidget(covariant _AuthCheck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _checkAuthStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return widget.child;
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
