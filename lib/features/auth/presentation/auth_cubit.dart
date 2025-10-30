import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/features/auth/data/auth_repository.dart';
import 'package:weather/features/auth/presentation/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(AuthInitial());

  final AuthRepository _authRepository;

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));

    final isLoggedIn = await _authRepository.isLoggedIn();
    if (isLoggedIn) {
      final user = _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    try {
      final success = await _authRepository.login(email, password);
      if (success) {
        final user = _authRepository.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError('Please enter valid email and password'));
        }
      } else {
        emit(AuthError('Please enter valid email and password'));
      }
    } catch (e) {
      emit(AuthError('Please enter valid email and password'));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }
}
