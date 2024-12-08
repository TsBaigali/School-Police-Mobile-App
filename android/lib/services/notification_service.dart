import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final String serviceAccountPath = 'assets/school-police-c59de-firebase-adminsdk-45dsj-47f2bb275d.json';

  // Function to send notification to the ad owner
  Future<void> sendNotificationToAdOwner(String userId, String adDocId) async {
    try {
      // Load and decode the service account JSON
      final serviceAccountData = await rootBundle.loadString(serviceAccountPath);
      final credentials = json.decode(serviceAccountData);

      // Fetch user and ad data from Firestore
      final userDoc = await FirebaseFirestore.instance.collection('user').doc(userId).get();
      final adDoc = await FirebaseFirestore.instance.collection('ad').doc(adDocId).get();

      final fcmToken = userDoc.data()?['fcmToken'];
      final adData = adDoc.data();

      if (fcmToken == null || adData == null) {
        print('Missing data: FCM Token or Ad details not found');
        return;
      }

      // Build notification payload
      final notificationData = {
        'message': {
          'token': fcmToken,
          'notification': {
            'title': 'ШИНЭ ХҮСЭЛТ',
            'body': 'Таны оруулсан зард шинэ хүсэлт ирлээ',
          },
          'android': {
            'notification': {
              'sound': 'notification_sound', // Reference the file in the `raw` folder without the extension
            }
          },
          'data': {
            'adId': adDocId,
            'additionalInfo': adData['additionalInfo'],
            'price': adData['price'].toString(),
            'action': 'new_request',
            'fromUser': userDoc.data()?['username'], // Include the sender's name or ID here
          },
        },
      };

      // Authenticate and send notification
      final authClient = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(credentials),
        ['https://www.googleapis.com/auth/firebase.messaging'],
      );

      final response = await authClient.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/${credentials["project_id"]}/messages:send'),
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

  // Function to handle request submission
  Future<bool> submitRequest(String adId, String workerId, String phoneNumber) async {
    try {
      // Check if the current user has already submitted a request for this ad
      final existingRequest = await FirebaseFirestore.instance
          .collection('requests')
          .where('workerId', isEqualTo: workerId)
          .where('adId', isEqualTo: adId)
          .get();

      if (existingRequest.docs.isNotEmpty) {
        print('Энэ зарлуу хүсэлт аль хэдийн илгээсэн байна.');
        return false; // Request already exists
      }

      // Add a new request document to Firestore
      await FirebaseFirestore.instance.collection('requests').add({
        'workerId': workerId,
        'adId': adId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'New request from a worker for your ad.',
        'workerPhoneNumber': phoneNumber,
      });

      // Fetch the ad document to get the ownerId
      final adDoc = await FirebaseFirestore.instance.collection('ad').doc(adId).get();
      if (adDoc.exists) {
        final ownerId = adDoc.data()?['ownerId'];
        if (ownerId != null) {
          await sendNotificationToAdOwner(ownerId, adId);
        } else {
          print('Error: Owner ID not found in the ad document.');
        }
      } else {
        print('Error: Ad document not found.');
      }

      return true; // Request successfully submitted
    } catch (e) {
      print('Error submitting request: $e');
      return false; // Failure
    }
  }

  Future<AcceptRequestResult> acceptRequest(String workerId, String adId) async {
    try {
      // Fetch the ad document to get price and ownerId
      final adDoc = await FirebaseFirestore.instance.collection('ad').doc(adId).get();
      final adData = adDoc.data();

      if (adData == null) {
        print('Error: Ad document not found.');
        return AcceptRequestResult(false, 'Ad not found.');
      }

      final double adPrice = (adData['price'] as num).toDouble();
      final String? ownerId = adData['ownerId'];

      if (ownerId == null) {
        print('Error: Owner ID not found in the ad document.');
        return AcceptRequestResult(false, 'Owner ID not found.');
      }

      // Fetch the owner's account balance
      final ownerDoc = await FirebaseFirestore.instance.collection('user').doc(ownerId).get();
      final ownerData = ownerDoc.data();
      final double ownerBalance = (ownerData?['balance'] as num?)?.toDouble() ?? 0.0;

      // Check if the owner has enough balance
      if (ownerBalance < adPrice) {
        print('Insufficient balance. Redirecting to recharge.');

        // Generate payment URL
        final paymentUrl = await _generateRechargePaymentUrl(ownerId, adPrice - ownerBalance);

        if (paymentUrl != null) {
          print('Payment URL: $paymentUrl');
          return AcceptRequestResult(false, 'Insufficient balance', paymentUrl);
        } else {
          return AcceptRequestResult(false, 'Failed to generate payment URL. Please try again.');
        }
      }

      // Check if the request has already been accepted
      final existingRequest = await FirebaseFirestore.instance
          .collection('requests')
          .where('workerId', isEqualTo: workerId)
          .where('adId', isEqualTo: adId)
          .where('status', isEqualTo: 'accepted')
          .get();

      if (existingRequest.docs.isNotEmpty) {
        print('Хүсэлт баталгаажсан байна.');
        return AcceptRequestResult(false, 'Request already accepted.');
      }

      // Add or update the request status in Firestore
      await FirebaseFirestore.instance.collection('requests').add({
        'workerId': workerId,
        'adId': adId,
        'status': 'accepted',
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'The request has been accepted.',
      });

      print('Request accepted.');

      // Send notification to the worker
      await sendNotificationToAdOwner(workerId, adId);

      return AcceptRequestResult(true, 'Request accepted successfully.');
    } catch (e) {
      print('Error accepting request: $e');
      return AcceptRequestResult(false, 'Error: $e');
    }
  }


  Future<String?> _generateRechargePaymentUrl(String ownerId, double requiredAmount) async {
    final token = '118|eh5mOfx1XQNlZtR9QIu5p6A5oxDlL9pxbCMcfKC8c2d1bb48'; // Replace with your actual token
    try {
      final response = await http.post(
        Uri.parse('https://byl.mn/api/v1/projects/100/invoices'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': requiredAmount,
          'description': 'Хүсэлт батлахын тулд дансаа цэнэглэнэ үү',
        }),
      );

      // Debug: Log the response for analysis
      print('Response: ${response.body}');

      // Handle success status codes (200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Check if the 'url' field exists in the response
        if (responseData['data'] != null && responseData['data']['url'] != null) {
          return responseData['data']['url'];
        } else {
          print('Error: URL field missing in response.');
          return null;
        }
      } else {
        print('Error: HTTP ${response.statusCode}. Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error generating payment URL: $e');
      return null;
    }
  }



}

// Class to encapsulate the result of an acceptRequest call
class AcceptRequestResult {
  final bool success;
  final String message;
  final String? paymentUrl;

  AcceptRequestResult(this.success, this.message, [this.paymentUrl]);
}




/*import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';

class NotificationService {
  final String serviceAccountPath = 'assets/school-police-c59de-firebase-adminsdk-45dsj-47f2bb275d.json';

  // Function to send notification to the ad owner
  Future<void> sendNotificationToAdOwner(String userId, String adDocId) async {
    try {
      // Load and decode the service account JSON
      final serviceAccountData = await rootBundle.loadString(serviceAccountPath);
      final credentials = json.decode(serviceAccountData);

      // Fetch user and ad data from Firestore
      final userDoc = await FirebaseFirestore.instance.collection('user').doc(userId).get();
      final adDoc = await FirebaseFirestore.instance.collection('ad').doc(adDocId).get();

      final fcmToken = userDoc.data()?['fcmToken'];
      final adData = adDoc.data();

      if (fcmToken == null || adData == null) {
        print('Missing data: FCM Token or Ad details not found');
        return;
      }

      // Build notification payload
      final notificationData = {
        'message': {
          'token': fcmToken,
          'notification': {
            'title': 'ШИНЭ ХҮСЭЛТ',
            'body': 'Таны оруулсан зард шинэ хүсэлт ирлээ',
          },
          'android': {
            'notification': {
              'sound': 'notification_sound', // Reference the file in the `raw` folder without the extension
            }
          },
          'data': {
            'adId': adDocId,
            'additionalInfo': adData['additionalInfo'],
            'price': adData['price'].toString(),
            'action': 'new_request',
            'fromUser': userDoc.data()?['username'], // Include the sender's name or ID here
          },
        },
      };

      // Authenticate and send notification
      final authClient = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(credentials),
        ['https://www.googleapis.com/auth/firebase.messaging'],
      );

      final response = await authClient.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/${credentials["project_id"]}/messages:send'),
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

  // Function to handle request submission
  Future<bool> submitRequest(String adId, String workerId, String phoneNumber) async {
    try {
      // Check if the current user has already submitted a request for this ad
      final existingRequest = await FirebaseFirestore.instance
          .collection('requests')
          .where('workerId', isEqualTo: workerId)
          .where('adId', isEqualTo: adId)
          .get();

      if (existingRequest.docs.isNotEmpty) {
        print('Энэ зарлуу хүсэлт аль хэдийн илгээсэн байна.');
        return false; // Request already exists
      }

      // Add a new request document to Firestore
      await FirebaseFirestore.instance.collection('requests').add({
        'workerId': workerId,
        'adId': adId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'New request from a worker for your ad.',
        'workerPhoneNumber': phoneNumber,
      });

      // Fetch the ad document to get the ownerId
      final adDoc = await FirebaseFirestore.instance.collection('ad').doc(adId).get();
      if (adDoc.exists) {
        final ownerId = adDoc.data()?['ownerId'];
        if (ownerId != null) {
          await sendNotificationToAdOwner(ownerId, adId);
        } else {
          print('Error: Owner ID not found in the ad document.');
        }
      } else {
        print('Error: Ad document not found.');
      }

      return true; // Request successfully submitted
    } catch (e) {
      print('Error submitting request: $e');
      return false; // Failure
    }
  }

  // Function to handle request acceptance
  Future<bool> acceptRequest(String workerId, String adId) async {
    try {
      // Check if the request has already been accepted
      final existingRequest = await FirebaseFirestore.instance
          .collection('requests')
          .where('workerId', isEqualTo: workerId)
          .where('adId', isEqualTo: adId)
          .where('status', isEqualTo: 'accepted')
          .get();

      if (existingRequest.docs.isNotEmpty) {
        print('Хүсэлт баталгаажсан байна.');
        return false; // Request already accepted
      }

      // Add or update the request status in Firestore
      final newRequest = await FirebaseFirestore.instance.collection('requests').add({
        'workerId': workerId,
        'adId': adId,
        'status': 'accepted',
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'The request has been accepted.',
      });

      print("Request accepted: ${newRequest.id}");

      // Fetch the ad document to get the ownerId
      final adDoc = await FirebaseFirestore.instance.collection('ad').doc(adId).get();
      if (adDoc.exists) {
        await sendNotificationToAdOwner(workerId, adId);
        } else {
        print('Error: Ad document not found.');
      }

      return true; // Request successfully accepted
    } catch (e) {
      print('Error accepting request: $e');
      return false; // Failure
    }
  }
}*/