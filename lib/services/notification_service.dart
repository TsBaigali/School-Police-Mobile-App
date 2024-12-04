import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final String baseUrl = 'http://192.168.69.3/notifications/send'; // Replace with your actual backend URL

  Future<void> sendNotificationToAdOwner(String ownerId, String adId) async {
    try {
      // Fetch owner's FCM token from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(ownerId)
          .get();

      final fcmToken = userDoc.data()?['fcmToken'];
      if (fcmToken == null) {
        print('Owner does not have an FCM token');
        return;
      }

      // Prepare notification payload
      final notificationData = {
        'to': fcmToken,
        'notification': {
          'title': 'Шинэ хүсэлт',
          'body': 'Таны зар дээр шинэ хүсэлт ирлээ!',
        },
        'data': {
          'adId': adId,
          'action': 'new_request',
        },
      };

      // Send the notification via your backend
      final response = await http.post(
        Uri.parse('${baseUrl}send-notification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(notificationData),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
