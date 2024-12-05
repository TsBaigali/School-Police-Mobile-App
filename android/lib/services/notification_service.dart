import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';

class NotificationService {
  final String serviceAccountPath = 'assets/school-police-c59de-firebase-adminsdk-45dsj-47f2bb275d.json';

  Future<void> sendNotificationToAdOwner(String ownerId, String adDocId) async {
    try {
      // Load and decode the service account JSON
      final serviceAccountData = await rootBundle.loadString(serviceAccountPath);
      final credentials = json.decode(serviceAccountData);

      // Fetch user and ad data from Firestore
      final userDoc = await FirebaseFirestore.instance.collection('user').doc(ownerId).get();
      final adDoc = await FirebaseFirestore.instance.collection('ad').doc(adDocId).get();

      final fcmToken = userDoc.data()?['fcmToken'];
      final adData = adDoc.data();

      if (fcmToken == null || adData == null) {
        print('Missing data: FCM Token or Ad details not found');
        return;
      }

      // Build notification payload without the `data` section
      final notificationData = {
        'message': {
          'token': fcmToken,
          'notification': {
            'title': 'Шинэ хүсэлт',
            'body': 'Таны зар дээр шинэ хүсэлт ирлээ!',
          },
          'data': {
            'adId': adDocId,
            'additionalInfo': adData['additionalInfo'],
            'price': adData['price'].toString(),
            'action': 'new_request',
          },
        },
      };

      // Authenticate and send notification
      final authClient = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(credentials),
        ['https://www.googleapis.com/auth/firebase.messaging'],
      );

      final response = await authClient.post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/${credentials["project_id"]}/messages:send',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(notificationData),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error in sending notification: $e');
    }
  }
}


/*import 'dart:convert';
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
}*/
