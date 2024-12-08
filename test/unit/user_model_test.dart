import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_police/models/user_model.dart';

void main() {
  group('User Model Tests', () {
    test('toMap should correctly serialize User object', () {
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
      final userMap = user.toMap();
      expect(userMap['username'], 'testuser');
      expect(userMap['role'], 'parent');
    });

    test('fromMap should correctly deserialize Map to User object', () {
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
      final user = User.fromMap(userMap, '123');
      expect(user.username, 'testuser');
      expect(user.role, UserRole.parent);
    });

    test('fromMap should handle null optional fields gracefully', () {
      final userMap = {
        'username': 'testuser',
        'firstName': 'Test',
        'lastName': 'User',
        'email': 'test@example.com',
        'phoneNumber': 1234567890,
        'password': 'password123',
        'role': 'schoolPolice',
      };
      final user = User.fromMap(userMap, '456');
      expect(user.image, null);
      expect(user.assignedSchools, null);
    });

    test('fromMap should throw error for invalid role', () {
      final userMap = {
        'username': 'testuser',
        'firstName': 'Test',
        'lastName': 'User',
        'email': 'test@example.com',
        'phoneNumber': 1234567890,
        'password': 'password123',
        'role': 'invalidRole',
      };
      expect(() => User.fromMap(userMap, '789'), throwsA(isA<StateError>()));
    });
  });
}
