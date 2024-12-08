import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_police/models/ad.dart';
import 'package:school_police/widgets/ad_card.dart';

void main() {
  group('AdCard Widget Tests', () {
    late Ad testAd;

    setUp(() {
      testAd = Ad(
        id: '1',
        school: '18 дугаар сургууль',
        profilePic: '', // Mocked empty profile picture
        district: 'Хан-Уул', // Assuming this maps to "address"
        additionalInfo: 'ttb',
        shift: 'Өглөө',
        date: '2024-12-06T05:06:35.989372',
        phoneNumber: '', // Mocked empty phone number
        views: 0,
        requestCount: 0,
        price: 50,
        ownerId: 'RITrcxt9Gjbpv59wz3IuTblsuPG3',
      );
    });

    testWidgets('should display the AdCard with correct information',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdCard(ad: testAd),
          ),
        ),
      );

      expect(find.text('18 дугаар сургууль'), findsOneWidget);
      expect(find.text('Хан-Уул'), findsOneWidget);
      expect(find.text('50 ₮'), findsOneWidget);
      expect(find.text('2024-12-06'), findsOneWidget);
      expect(find.text('Өглөө'), findsOneWidget); // Shift field
    });
  });
}
