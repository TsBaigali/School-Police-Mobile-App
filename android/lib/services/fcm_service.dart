import 'package:http/http.dart' as http;
import 'dart:convert';

class FCMService {
  /// Sends the FCM token to the backend.
  Future<void> sendTokenToBackend(String? token, String authToken) async {
    if (token == null || authToken.isEmpty) {
      print("Invalid inputs: token, userId, or authToken is null/empty.");
      print('Token: $token');
      print('UserId: $authToken');
      return;
    }

    // Backend API endpoint
    final url = Uri.parse("http://192.168.232.3:8080/save-fcm-token"); // Replace with your backend endpoint

    try {
      // HTTP POST request to send the token
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Add the user's auth token
        },
        body: jsonEncode({
          'token': token,
          //'userId': userId, // Associate the token with the logged-in user
        }),
      );

      if (response.statusCode == 200) {
        print("Token sent to backend successfully.");
      } else {
        print(
            "Failed to send token to backend. Status: ${response.statusCode}, Response: ${response.body}");
      }
    } catch (e) {
      print("Error occurred while sending token to backend: $e");
    }
  }
}
