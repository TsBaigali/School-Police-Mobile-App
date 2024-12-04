import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_police/models/user_model.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toMap());
    await _storage.write(key: 'user_info', value: userJson);
  }

  Future<User?> getUser() async {
    final userJson = await _storage.read(key: 'user_info');
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      final id = userMap['id'] as String?; // Ensure the document ID is stored
      return User.fromMap(userMap, id ?? '');
    }
    return null;
  }


  Future<void> deleteUser() async {
    await _storage.delete(key: 'user_info');
  }
}
