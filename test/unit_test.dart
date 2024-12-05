// This is an example unit test.
//
// A unit test tests a single function, method, or class. To learn more about
// writing unit tests, visit
// https://flutter.dev/docs/cookbook/testing/unit/introduction

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:school_police/models/ad.dart';
import 'package:school_police/models/notification.dart';
import 'package:school_police/models/user_model.dart';

void main() {
  group('Plus Operator', () {
    test('should add two numbers together', () {
      expect(1 + 1, 2);
    });
  });

  group('Ad Model Tests', () {
    test('toMap should correctly serialize Ad object', () {
      // Arrange
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

      // Act
      final adMap = ad.toMap();

      // Assert
      expect(adMap['id'], '123');
      expect(adMap['school'], 'ABC High School');
      expect(adMap['profilePic'], 'https://example.com/pic.jpg');
      expect(adMap['address'], 'District 1');
      expect(adMap['additionalInfo'], 'No special requirements');
      expect(adMap['shift'], 'Morning');
      expect(adMap['date'], '2024-12-01');
      expect(adMap['phoneNumber'], '1234567890');
      expect(adMap['views'], 100);
      expect(adMap['requestCount'], 10);
      expect(adMap['price'], 500);
      expect(adMap['ownerId'], 'owner_001');
    });

    test('fromMap should correctly deserialize Map to Ad object', () {
      // Arrange
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

      // Act
      final ad = Ad.fromMap(adMap, '456');

      // Assert
      expect(ad.id, '456');
      expect(ad.school, 'XYZ High School');
      expect(ad.profilePic, 'https://example.com/profile.jpg');
      expect(ad.district, 'District 2');
      expect(ad.additionalInfo, 'Pets allowed');
      expect(ad.shift, 'Afternoon');
      expect(ad.date, '2024-12-02');
      expect(ad.phoneNumber, '0987654321');
      expect(ad.views, 150);
      expect(ad.requestCount, 5);
      expect(ad.price, 600);
      expect(ad.ownerId, 'owner_002');
    });

    test('fromMap should handle missing fields with default values', () {
      // Arrange
      final incompleteMap = {
        'school': 'LMN High School',
        'price': 700,
      };

      // Act
      final ad = Ad.fromMap(incompleteMap, '789');

      // Assert
      expect(ad.id, '789');
      expect(ad.school, 'LMN High School');
      expect(ad.profilePic, '');
      expect(ad.district, '');
      expect(ad.additionalInfo, '');
      expect(ad.shift, '');
      expect(ad.date, '');
      expect(ad.phoneNumber, '');
      expect(ad.views, 0);
      expect(ad.requestCount, 0);
      expect(ad.price, 700);
      expect(ad.ownerId, '');
    });
  });
  test('NotificationModel should assign values correctly', () {
    final notification = NotificationModel(
      id: '1',
      title: 'New Alert',
      message: 'This is a test notification',
      time: '2024-12-06 10:00',
      imageUrl: 'https://example.com/image.png',
    );

    expect(notification.id, '1');
    expect(notification.title, 'New Alert');
    expect(notification.message, 'This is a test notification');
    expect(notification.time, '2024-12-06 10:00');
    expect(notification.imageUrl, 'https://example.com/image.png');
  });
  group('User Model Tests', () {
    test('toMap should correctly serialize User object', () {
      // Arrange
      final user = User(
        id: '123',
        username: 'testuser',
        firstName: 'Test',
        lastName: 'User',
        email: 'test@example.com',
        phoneNumber: 1234567890,
        password: 'password123',
        image: File('/path/to/image.png'),
        role: UserRole.parent,
        assignedSchools: ['School1', 'School2'],
      );

      // Act
      final userMap = user.toMap();

      // Assert
      expect(userMap['username'], 'testuser');
      expect(userMap['firstName'], 'Test');
      expect(userMap['lastName'], 'User');
      expect(userMap['email'], 'test@example.com');
      expect(userMap['phoneNumber'], 1234567890);
      expect(userMap['password'], 'password123');
      expect(userMap['image'], '/path/to/image.png');
      expect(userMap['role'], 'parent');
      expect(userMap['assignedSchools'], ['School1', 'School2']);
    });

    test('fromMap should correctly deserialize Map to User object', () {
      // Arrange
      final userMap = {
        'username': 'testuser',
        'firstName': 'Test',
        'lastName': 'User',
        'email': 'test@example.com',
        'phoneNumber': 1234567890,
        'password': 'password123',
        'image': '/path/to/image.png',
        'role': 'parent',
        'assignedSchools': ['School1', 'School2'],
      };

      // Act
      final user = User.fromMap(userMap, '123');

      // Assert
      expect(user.id, '123');
      expect(user.username, 'testuser');
      expect(user.firstName, 'Test');
      expect(user.lastName, 'User');
      expect(user.email, 'test@example.com');
      expect(user.phoneNumber, 1234567890);
      expect(user.password, 'password123');
      expect(user.image?.path, '/path/to/image.png');
      expect(user.role, UserRole.parent);
      expect(user.assignedSchools, ['School1', 'School2']);
    });

    test('fromMap should handle null optional fields gracefully', () {
      // Arrange
      final userMap = {
        'username': 'testuser',
        'firstName': 'Test',
        'lastName': 'User',
        'email': 'test@example.com',
        'phoneNumber': 1234567890,
        'password': 'password123',
        'role': 'schoolPolice',
      };

      // Act
      final user = User.fromMap(userMap, '456');

      // Assert
      expect(user.image, null);
      expect(user.assignedSchools, null);
    });

    test('fromMap should throw error for invalid role', () {
      // Arrange
      final userMap = {
        'username': 'testuser',
        'firstName': 'Test',
        'lastName': 'User',
        'email': 'test@example.com',
        'phoneNumber': 1234567890,
        'password': 'password123',
        'role': 'invalidRole',
      };

      // Act & Assert
      expect(
        () => User.fromMap(userMap, '789'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
