import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather/core/mixins/snackbar_mixin.dart';

class TestWidget extends StatelessWidget with SnackbarMixin {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => showSuccess(context, 'Success message'),
            child: const Text('Success'),
          ),
          ElevatedButton(
            onPressed: () => showError(context, 'Error message'),
            child: const Text('Error'),
          ),
          ElevatedButton(
            onPressed: () => showInfo(context, 'Info message'),
            child: const Text('Info'),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('SnackbarMixin', () {
    testWidgets('showSuccess displays green snackbar with checkmark icon', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      await tester.tap(find.text('Success'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, Colors.green);

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('Success message'), findsOneWidget);
    });

    testWidgets('showError displays red snackbar with error icon', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      await tester.tap(find.text('Error'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, Colors.red);

      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('showInfo displays blue snackbar with info icon', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      await tester.tap(find.text('Info'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, Colors.blue);

      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.text('Info message'), findsOneWidget);
    });
  });
}
