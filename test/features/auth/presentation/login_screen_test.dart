import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather/features/auth/data/auth_repository.dart';
import 'package:weather/features/auth/presentation/auth_cubit.dart';
import 'package:weather/features/auth/presentation/login_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  Widget createLoginScreen() {
    return MaterialApp(
      home: BlocProvider<AuthCubit>(
        create: (_) => AuthCubit(authRepository: mockAuthRepository),
        child: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('should show error when invalid email is entered', (
      tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email'),
        'invalid-email',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your password'),
        'Password123!',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error when password is too short', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your password'),
        'Pass1',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('should show error when password lacks uppercase', (
      tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your password'),
        'password1',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      expect(
        find.text('Password must contain at least 1 uppercase letter'),
        findsOneWidget,
      );
    });

    testWidgets('login button should be enabled even when form is empty', (
      tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      expect(tester.widget<ElevatedButton>(loginButton).onPressed, isNotNull);
    });

    testWidgets('login button should be enabled when form is valid', (
      tester,
    ) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your password'),
        'Password123!',
      );

      await tester.pump();

      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      expect(tester.widget<ElevatedButton>(loginButton).onPressed, isNotNull);
    });

    testWidgets('should display error snackbar on login failure', (
      tester,
    ) async {
      when(
        () => mockAuthRepository.login(any(), any()),
      ).thenAnswer((_) async => false);

      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your password'),
        'Password123!',
      );

      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(
        find.text('Please enter valid email and password'),
        findsOneWidget,
      );
    });
  });
}
