import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';
import 'package:weather/core/config/routes.dart';
import 'package:weather/core/mixins/snackbar_mixin.dart';
import 'package:weather/features/auth/presentation/auth_cubit.dart';
import 'package:weather/features/auth/presentation/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SnackbarMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isFormValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  Widget _buildResponsiveContainer(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth;
        if (constraints.maxWidth < 600) {
          maxWidth = double.infinity;
        } else if (constraints.maxWidth < 1200) {
          maxWidth = 600;
        } else {
          maxWidth = 800;
        }

        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.weather);
          } else if (state is AuthError) {
            showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: _buildResponsiveContainer(
              Form(
                key: _formKey,
                onChanged: _validateForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.cloud,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 48),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: Validatorless.multiple([
                        Validatorless.required('Email is required'),
                        Validatorless.email('Enter a valid email'),
                      ]),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: Validatorless.multiple([
                        Validatorless.required('Password is required'),
                        Validatorless.min(
                          6,
                          'Password must be at least 6 characters',
                        ),
                        Validatorless.regex(
                          RegExp(r'[A-Z]'),
                          'Password must contain at least 1 uppercase letter',
                        ),
                        Validatorless.regex(
                          RegExp(r'[a-z]'),
                          'Password must contain at least 1 lowercase letter',
                        ),
                        Validatorless.regex(
                          RegExp(r'[0-9]'),
                          'Password must contain at least 1 number',
                        ),
                      ]),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isFormValid && !isLoading ? _onLogin : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
