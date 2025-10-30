import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather/features/auth/data/auth_repository.dart';
import 'package:weather/features/auth/domain/auth_user.dart';
import 'package:weather/features/auth/presentation/auth_cubit.dart';
import 'package:weather/features/auth/presentation/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthCubit authCubit;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authCubit = AuthCubit(mockAuthRepository);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    final testUser = AuthUser(
      email: 'test@example.com',
      sessionToken: 'test-token',
      loginTimestamp: DateTime.now(),
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when checkAuthStatus finds existing session',
      build: () {
        when(
          () => mockAuthRepository.isLoggedIn(),
        ).thenAnswer((_) async => true);
        when(() => mockAuthRepository.getCurrentUser()).thenReturn(testUser);
        return authCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      wait: const Duration(seconds: 2),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when checkAuthStatus finds no session',
      build: () {
        when(
          () => mockAuthRepository.isLoggedIn(),
        ).thenAnswer((_) async => false);
        return authCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      wait: const Duration(seconds: 2),
      expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        when(
          () => mockAuthRepository.login(any(), any()),
        ).thenAnswer((_) async => true);
        when(() => mockAuthRepository.getCurrentUser()).thenReturn(testUser);
        return authCubit;
      },
      act: (cubit) => cubit.login('test@example.com', 'Password1'),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(
          () => mockAuthRepository.login(any(), any()),
        ).thenAnswer((_) async => false);
        return authCubit;
      },
      act: (cubit) => cubit.login('test@example.com', 'wrongpassword'),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthUnauthenticated] when logout is called',
      build: () {
        when(() => mockAuthRepository.logout()).thenAnswer((_) async {});
        return authCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [isA<AuthUnauthenticated>()],
    );
  });
}
