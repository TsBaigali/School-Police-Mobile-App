import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_police/models/user_model.dart'; // Your custom User model
import 'package:school_police/services/secure_storage_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:school_police/services/fcm_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final SecureStorageService _secureStorage = SecureStorageService();
  final FCMService _fcmService = FCMService();
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUpWithEmailAndPassword(String email, String password, String username) async {
    try {
      // Create user in Firebase Authentication
      final firebase_auth.UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user details to Firestore
      final userId = userCredential.user?.uid;
      if (userId != null) {
        await _firestore.collection('user').doc(userId).set({
          'email': email,
          'username': username,
          'createdAt': DateTime.now().toIso8601String(),
        });

        // Store FCM token
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await _firestore.collection('user').doc(userId).update({
            'fcmToken': fcmToken,
          });
        }

        return userId; // Return Firebase `uid`
      }
      return null;
    } catch (e) {
      print("Error during sign-up: $e");
      return null;
    }
  }

  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      // Authenticate user in Firebase Authentication
      final firebase_auth.UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user?.uid;
      if (userId != null) {
        // Retrieve the user document from Firestore
        final userDocSnapshot = await _firestore.collection('user').doc(userId).get();

        if (userDocSnapshot.exists) {
          final fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            // Update FCM token in Firestore
            await _firestore.collection('user').doc(userId).update({
              'fcmToken': fcmToken,
            });

            // Optionally, send the token to your backend
            final backendToken = await _secureStorage.getToken(); // Replace with actual backend token if needed
            if (backendToken != null) {
              await _fcmService.sendTokenToBackend(fcmToken, backendToken);
            }
          }

          return userId; // Return Firebase `uid`
        } else {
          print("User document not found in Firestore.");
          return null;
        }
      }
      return null;
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      // Sign out from Firebase Authentication
      await _firebaseAuth.signOut();

      // Clear local storage
      await _secureStorage.deleteToken();
      await _secureStorage.deleteUser();
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  Future<bool> isLoggedIn() async {
    final user = _firebaseAuth.currentUser;
    return user != null;
  }

  Future<User?> getUser() async {
    final firebase_auth.User? firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      final userDocSnapshot = await _firestore.collection('user').doc(firebaseUser.uid).get();
      if (userDocSnapshot.exists) {
        return User.fromMap(userDocSnapshot.data()!, firebaseUser.uid); // Update `User` model as needed
      }
    }
    return null;
  }
}
