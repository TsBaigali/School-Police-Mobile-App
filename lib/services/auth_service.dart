import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_police/models/user_model.dart';
import 'package:school_police/services/secure_storage_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:school_police/services/fcm_service.dart';

class AuthService {
  final SecureStorageService _secureStorage = SecureStorageService();
  final FCMService _fcmService = FCMService();

  final String baseUrl =
      'https://backend-api-491759785783.asia-northeast1.run.app/';

  /// Authenticate user and send FCM token to backend.
  Future<String?> authenticateUser(
      String usernameOrEmail, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usernameOrEmail': usernameOrEmail,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        // Assuming the API returns a `token` and `userId` object
        final token = responseBody['token'];
        final userId = responseBody['userId']; // Ensure this key matches your API response

        // Save token and user in secure storage
        await _secureStorage.saveToken(token);

        // Retrieve the FCM token
        final fcmToken = await FirebaseMessaging.instance.getToken();

        // Send the FCM token to the backend
        if (fcmToken != null) {
          await _fcmService.sendTokenToBackend(fcmToken, userId, token);
        } else {
          print("FCM token is null.");
        }

        return token;
      } else {
        print("Authentication failed: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      print('Error during authentication: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.getToken();
    return token != null;
  }

  Future<User?> getUser() async {
    return await _secureStorage.getUser();
  }

  Future<void> logout() async {
    await _secureStorage.deleteToken();
    await _secureStorage.deleteUser();
  }
}
