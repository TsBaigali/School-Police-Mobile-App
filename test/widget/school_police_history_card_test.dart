import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_police/widgets/school_police_history_card.dart';

void main() {
  group('SchoolPoliceHistoryCard Widget Tests', () {
    testWidgets('should display the school name correctly',
        (WidgetTester tester) async {
      const schoolName = 'Test School';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SchoolPoliceHistoryCard(schoolName: schoolName),
          ),
        ),
      );

      expect(find.text(schoolName), findsOneWidget);
    });
  });
}
