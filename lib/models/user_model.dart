import 'dart:io';

enum UserRole { parent, schoolPolice }

class User {
  final String? id; // Firestore document ID
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final int phoneNumber;
  final String password;
  final File? image;
  final UserRole role;
  final List<String>? assignedSchools;

  User({
    this.id, // Firestore document ID
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.image,
    required this.role,
    required this.assignedSchools,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'image': image?.path,
      'role': role.toString().split('.').last,
      'assignedSchools': assignedSchools,
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id, // Firestore document ID
      username: map['username'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      password: map['password'],
      image: map['image'] != null ? File(map['image']) : null,
      role: UserRole.values
          .firstWhere((e) => e.toString() == 'UserRole.${map['role']}'),
      assignedSchools: map['assignedSchools'] != null
          ? List<String>.from(map['assignedSchools'])
          : null,
    );
  }
}

