import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';

class NotificationService {
  final String serviceAccountPath =
      'assets/school-police-c59de-firebase-adminsdk-45dsj-47f2bb275d.json';

  /// Sends a notification to the ad owner and stores the request in Firestore
  Future<void> sendNotificationToAdOwner(
      String ownerId, String adDocId, String workerId) async {
    try {
      // Load and decode the service account JSON
      final serviceAccountData =
          await rootBundle.loadString(serviceAccountPath);
      final credentials = json.decode(serviceAccountData);

      // Fetch user (ad owner) and ad data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(ownerId)
          .get();
      final adDoc =
          await FirebaseFirestore.instance.collection('ad').doc(adDocId).get();

      final fcmToken = userDoc.data()?['fcmToken'];
      final adData = adDoc.data();

      if (fcmToken == null || adData == null) {
        print('Missing data: FCM Token or Ad details not found');
        return;
      }

      // Add a new request to Firestore
      final requestRef =
          await FirebaseFirestore.instance.collection('requests').add({
        'state': 'pending', // Initial state is 'pending'
        'worker_id': workerId,
        'ad_id': adDocId,
        'owner_id': ownerId,
        'created_at': FieldValue.serverTimestamp(),
      });

      print('Request created with ID: ${requestRef.id}');

      // Build notification payload
      final notificationData = {
        'message': {
          'token': fcmToken,
          'notification': {
            'title': 'Шинэ хүсэлт',
            'body': 'Таны зар дээр шинэ хүсэлт ирлээ!',
          },
          'data': {
            'adId': adDocId,
            'requestId': requestRef.id,
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

  /// Sends the FCM token to the backend
  Future<void> sendTokenToBackend(String fcmToken) async {
    try {
      // Replace this URL with your backend endpoint for storing FCM tokens
      const String backendUrl =
          'http://192.168.69.3/notifications/register-token';

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'fcmToken': fcmToken}),
      );

      if (response.statusCode == 200) {
        print('FCM token registered successfully');
      } else {
        print('Failed to register FCM token: ${response.body}');
      }
    } catch (e) {
      print('Error sending FCM token to backend: $e');
    }
  }
}
