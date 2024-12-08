import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_police/widgets/forgot_password_dialog.dart';

void main() {
  group('ForgotPasswordDialog Widget Tests', () {
    testWidgets('should display dialog with correct title and content',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForgotPasswordDialog(),
          ),
        ),
      );

      expect(find.text('Нууц үг сэргээх'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
