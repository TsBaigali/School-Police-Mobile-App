import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_police/services/secure_storage_service.dart';

class NotificationService {
  final String baseUrl = 'https://backend-api-491759785783.asia-northeast1.run.app/';
  final SecureStorageService _secureStorage = SecureStorageService();

  /// Send a notification to a specific recipient
  Future<void> sendNotification({
    required String recipientToken,
    required String title,
    required String body,
  }) async {
    try {
      // Retrieve the user's authentication token
      final authToken = await _secureStorage.getToken();
      if (authToken == null) {
        print("User is not authenticated.");
        return;
      }

      // Send the notification request to the backend
      final response = await http.post(
        Uri.parse('$baseUrl/api/send-notification'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'recipientToken': recipientToken,
          'title': title,
          'body': body,
        }),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully.");
      } else {
        print(
            "Failed to send notification. Status: ${response.statusCode}, Response: ${response.body}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}
