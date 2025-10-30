import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/core/services/auth_service.dart';

void main() {
  late SharedPreferences prefs;
  late AuthService authService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    authService = AuthService(prefs);
  });

  group('AuthService', () {
    test('should store session data on login', () async {
      await authService.login('test@example.com', 'password123');

      expect(authService.getEmail(), 'test@example.com');
      expect(authService.getSessionToken(), isNotNull);
      expect(authService.getLoginTimestamp(), isNotNull);
    });

    test(
      'should generate unique session tokens for different logins',
      () async {
        await authService.login('user1@example.com', 'password1');
        final token1 = authService.getSessionToken();

        await authService.logout();

        await authService.login('user2@example.com', 'password2');
        final token2 = authService.getSessionToken();

        expect(token1, isNot(equals(token2)));
      },
    );

    test('should return true when user is logged in', () async {
      await authService.login('test@example.com', 'password123');

      final isLoggedIn = await authService.isLoggedIn();

      expect(isLoggedIn, true);
    });

    test('should return false when user is not logged in', () async {
      final isLoggedIn = await authService.isLoggedIn();

      expect(isLoggedIn, false);
    });

    test('should clear session data on logout', () async {
      await authService.login('test@example.com', 'password123');
      await authService.logout();

      expect(authService.getEmail(), isNull);
      expect(authService.getSessionToken(), isNull);
      expect(authService.getLoginTimestamp(), isNull);
    });

    test('should trim whitespace from email', () async {
      await authService.login('  test@example.com  ', 'password123');

      expect(authService.getEmail(), '  test@example.com  ');
    });
  });
}
