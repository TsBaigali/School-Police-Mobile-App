import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:io';

class NotificationService {
  // Path to your service account JSON file
  final String serviceAccountPath = 'path/to/serviceAccountKey.json';

  Future<void> sendNotificationToAdOwner(String ownerId, String adDocId) async {
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

      // Fetch ad details from Firestore
      final adDoc = await FirebaseFirestore.instance
          .collection('ad')
          .doc(adDocId)
          .get();

      final adData = adDoc.data();
      if (adData == null) {
        print('Ad does not exist');
        return;
      }

      // Prepare notification payload
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
            'action': 'new_request',
          },
        },
      };

      // Authenticate with Firebase using the service account JSON
      final serviceAccount = File(serviceAccountPath);
      final credentials = json.decode(serviceAccount.readAsStringSync());
      final authClient = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(credentials),
        ['https://www.googleapis.com/auth/firebase.messaging'],
      );

      // Send the notification via FCM HTTP v1 API
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
      print('Error sending notification: $e');
    }
  }
}


/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final String baseUrl = 'http://192.168.237.3/notifications/send'; // Backend URL

  Future<void> sendNotificationToAdOwner(String ownerId, String adDocId) async {
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

      // Fetch ad details from Firestore
      final adDoc = await FirebaseFirestore.instance
          .collection('ad')
          .doc(adDocId)
          .get();

      final adData = adDoc.data();
      if (adData == null) {
        print('Ad does not exist');
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
          'adId': adDocId, // Firestore document ID
          'additionalInfo': adData['additionalInfo'], // Additional info
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
*/