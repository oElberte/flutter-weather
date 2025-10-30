import 'package:weather/core/services/auth_service.dart';
import 'package:weather/features/auth/domain/auth_user.dart';

class AuthRepository {
  AuthRepository(this._authService);

  final AuthService _authService;

  Future<bool> login(String email, String password) async {
    return await _authService.login(email.trim(), password);
  }

  Future<bool> isLoggedIn() async {
    return await _authService.isLoggedIn();
  }

  AuthUser? getCurrentUser() {
    final email = _authService.getEmail();
    final token = _authService.getSessionToken();
    final timestamp = _authService.getLoginTimestamp();

    if (email == null || token == null || timestamp == null) {
      return null;
    }

    return AuthUser.fromSharedPreferences(
      email: email,
      sessionToken: token,
      timestamp: timestamp,
    );
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
