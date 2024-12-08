import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_police/widgets/notification_card.dart';

// TestHttpOverrides to handle network image issues in tests
class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  setUpAll(() {
    // Set HttpOverrides to mock NetworkImage requests
    HttpOverrides.global = TestHttpOverrides();
  });

  group('NotificationCard Widget Tests', () {
    testWidgets('should display correct title, message, and time',
        (WidgetTester tester) async {
      const testTitle = 'New Notification';
      const testMessage = 'This is a test notification message.';
      const testTime = '10:00 AM';
      const testImageUrl =
          'assets/images/logo_noword.png'; // Replace with local asset

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(
              title: testTitle,
              message: testMessage,
              time: testTime,
              imageUrl: testImageUrl, // Replace URL with local asset
              onTap: () {}, // Empty callback for testing
            ),
          ),
        ),
      );

      // Verify text content
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testMessage), findsOneWidget);
      expect(find.text(testTime), findsOneWidget);
    });

    testWidgets('should handle tap interaction correctly',
        (WidgetTester tester) async {
      // Track whether the callback is triggered
      bool isTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(
              title: 'Test Title',
              message: 'Test Message',
              time: '10:00 AM',
              imageUrl: 'https://example.com/image.png',
              onTap: () {
                isTapped = true;
              },
            ),
          ),
        ),
      );

      // Simulate a tap on the NotificationCard
      await tester.tap(find.byType(NotificationCard));
      await tester.pumpAndSettle();

      // Verify the callback is triggered
      expect(isTapped, true);
    });

    testWidgets('should display placeholder for invalid image URL',
        (WidgetTester tester) async {
      const testTitle = 'New Notification';
      const testMessage = 'This is a test notification message.';
      const testTime = '10:00 AM';
      const invalidImageUrl = 'invalid_image_url';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(
              title: testTitle,
              message: testMessage,
              time: testTime,
              imageUrl: invalidImageUrl,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify text content
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testMessage), findsOneWidget);
      expect(find.text(testTime), findsOneWidget);

      // Verify placeholder behavior (use your specific fallback implementation)
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });
}
