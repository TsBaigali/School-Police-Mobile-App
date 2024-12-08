import 'package:flutter_test/flutter_test.dart';
import 'package:school_police/models/ad.dart';

void main() {
  group('Ad Model Tests', () {
    test('toMap should correctly serialize Ad object', () {
      final ad = Ad(
        id: '123',
        school: 'ABC High School',
        profilePic: 'https://example.com/pic.jpg',
        district: 'District 1',
        additionalInfo: 'No special requirements',
        shift: 'Morning',
        date: '2024-12-01',
        phoneNumber: '1234567890',
        views: 100,
        requestCount: 10,
        price: 500,
        ownerId: 'owner_001',
      );
      final adMap = ad.toMap();
      expect(adMap['id'], '123');
      expect(adMap['school'], 'ABC High School');
      expect(adMap['price'], 500);
    });

    test('fromMap should correctly deserialize Map to Ad object', () {
      final adMap = {
        'school': 'XYZ High School',
        'profilePic': 'https://example.com/profile.jpg',
        'address': 'District 2',
        'additionalInfo': 'Pets allowed',
        'shift': 'Afternoon',
        'date': '2024-12-02',
        'phoneNumber': '0987654321',
        'views': 150,
        'requestCount': 5,
        'price': 600,
        'ownerId': 'owner_002',
      };
      final ad = Ad.fromMap(adMap, '456');
      expect(ad.id, '456');
      expect(ad.school, 'XYZ High School');
    });

    test('fromMap should handle missing fields with default values', () {
      final incompleteMap = {
        'school': 'LMN High School',
        'price': 700,
      };
      final ad = Ad.fromMap(incompleteMap, '789');
      expect(ad.id, '789');
      expect(ad.school, 'LMN High School');
      expect(ad.price, 700);
    });
  });
}
