import 'dart:io';

enum UserRole { parent, schoolPolice }

class User {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final int phoneNumber;
  final String password;
  final File? image;
  final UserRole role;
  final List<String>? assignedSchools; // Only for schoolPolice

  User({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.image,
    required this.role,
    required this.assignedSchools, // This will be null for `parent`
  });

  User copyWith({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    int? phoneNumber,
    String? password,
    File? image,
    UserRole? role,
    List<String>? assignedSchools,
  }) {
    return User(
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      image: image ?? this.image,
      role: role ?? this.role,
      assignedSchools: assignedSchools ?? this.assignedSchools,
    );
  }

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
      'assignedSchools': assignedSchools, // List of assigned schools
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      password: map['password'],
      image: map['image'] != null ? File(map['image']) : null,
      role: UserRole.values.firstWhere(
              (e) => e.toString() == 'UserRole.${map['role']}'),
      assignedSchools: map['assignedSchools'] != null
          ? List<String>.from(map['assignedSchools'])
          : null,
    );
  }
}
