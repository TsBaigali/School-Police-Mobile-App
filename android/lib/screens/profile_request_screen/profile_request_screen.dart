import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/notification_service.dart';
import '../recharge_screen/recharge_screen.dart';
import 'package:school_police/widgets/school_police_history_card.dart';

class ProfileRequestScreen extends StatelessWidget {
  final String workerId;
  final String adId;

  ProfileRequestScreen({required this.workerId, required this.adId});

  // Function to fetch worker information based on workerId
  Future<Map<String, dynamic>> _fetchWorkerInfo(String workerId) async {
    try {
      final workerDoc = await FirebaseFirestore.instance.collection('user').doc(workerId).get();
      if (workerDoc.exists) {
        return workerDoc.data()!;
      } else {
        throw 'Worker data not found';
      }
    } catch (e) {
      print('Error fetching worker info: $e');
      return {};
    }
  }

  // Function to handle request acceptance
  Future<void> _acceptedRequest(BuildContext context) async {
    try {
      final notificationService = NotificationService();

      // Ensure the current user is logged in
      final senderId = FirebaseAuth.instance.currentUser?.uid;
      if (senderId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to submit a request!')),
        );
        return;
      }

      // Call the NotificationService to accept the request
      final result = await notificationService.acceptRequest(workerId, adId);

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request accepted successfully!')),
        );
      } else if (result.paymentUrl != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RechargeScreen(paymentUrl: result.paymentUrl!),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchWorkerInfo(workerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final workerData = snapshot.data ?? {};
          final workerName = workerData['username'] ?? 'Unknown';
          final workerPhone = workerData['phoneNumber'] ?? 'Unknown';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: theme.colorScheme.primary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: theme.colorScheme.surface,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        workerName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '📞 $workerPhone',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '12',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'НИЙТ ГАРСАН',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '4.5',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'ҮНЭЛГЭЭ',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 1, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'School Police түүх',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '12',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SchoolPoliceHistoryCard(
                              schoolName: '3-р сургууль',
                              rating: 4,
                            ),
                            const SizedBox(width: 10),
                            SchoolPoliceHistoryCard(
                              schoolName: '3-р сургууль',
                              rating: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () => _acceptedRequest(context),
                    style: theme.elevatedButtonTheme.style,
                    child: Text(
                      'Батлах',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/notification_service.dart';
import 'package:school_police/widgets/school_police_history_card.dart';

class ProfileRequestScreen extends StatelessWidget {
  final String workerId;
  final String adId;

  ProfileRequestScreen({required this.workerId, required this.adId});

  // Function to fetch worker information based on workerId
  Future<Map<String, dynamic>> _fetchWorkerInfo(String workerId) async {
    try {
      final workerDoc = await FirebaseFirestore.instance.collection('user').doc(workerId).get();
      if (workerDoc.exists) {
        return workerDoc.data()!;
      } else {
        throw 'Worker data not found';
      }
    } catch (e) {
      print('Error fetching worker info: $e');
      return {};
    }
  }

  // Function to handle request acceptance
  Future<void> _acceptedRequest(BuildContext context) async {
    try {
      final notificationService = NotificationService();

      // Ensure the current user is logged in
      final senderId = FirebaseAuth.instance.currentUser?.uid;
      if (senderId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to submit a request!')),
        );
        return;
      }

      // Call the NotificationService to accept the request
      final success = await notificationService.acceptRequest(workerId, adId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request accepted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request has already been accepted.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchWorkerInfo(workerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final workerData = snapshot.data ?? {};
          final workerName = workerData['username'] ?? 'Unknown';
          final workerPhone = workerData['phoneNumber'] ?? 'Unknown';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Info Section
                Container(
                  height: 200,
                  width: double.infinity,
                  color: theme.colorScheme.primary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: theme.colorScheme.surface,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        workerName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '📞 $workerPhone',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '12', // Example total posts count
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'НИЙТ ГАРСАН',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '4.5', // Example rating
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'ҮНЭЛГЭЭ',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 1, color: Colors.grey),

                // School Police History Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'School Police түүх',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '12',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SchoolPoliceHistoryCard(
                              schoolName: '3-р сургууль',
                              rating: 4,
                            ),
                            const SizedBox(width: 10),
                            SchoolPoliceHistoryCard(
                              schoolName: '3-р сургууль',
                              rating: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Confirm Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () => _acceptedRequest(context),
                    style: theme.elevatedButtonTheme.style,
                    child: Text(
                      'Батлах',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/notification_service.dart';
import 'package:school_police/widgets/school_police_history_card.dart';

class ProfileRequestScreen extends StatelessWidget {
  final String workerId;
  final String adId;// Accept workerId as a parameter

  ProfileRequestScreen({required this.workerId, required this.adId}); // Constructor to accept workerId

  // Function to fetch worker information based on workerId
  Future<Map<String, dynamic>> _fetchWorkerInfo(String workerId) async {
    try {
      final workerDoc = await FirebaseFirestore.instance.collection('user').doc(workerId).get();
      if (workerDoc.exists) {
        return workerDoc.data()!;
      } else {
        throw 'Worker data not found';
      }
    } catch (e) {
      print('Error fetching worker info: $e');
      return {}; // Return an empty map if there's an error
    }
  }

  // Function to submit the request and send notification
  Future<void> _acceptedRequest(BuildContext context) async {
    try {
      final notificationService = NotificationService();

      // Get the current user's UID as the workerId
      final workerId = FirebaseAuth.instance.currentUser?.uid;

      if (workerId == null) {
        // Handle the case where the user is not authenticated
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to submit a request!')),
        );
        return;
      }

      // Call the submitRequest function to add the request and send a notification
      await notificationService.acceptRequest(workerId, adId);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request sent successfully!')),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print('Worker ID received in ProfileRequestScreen: $workerId');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchWorkerInfo(workerId), // Fetch worker info based on workerId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final workerData = snapshot.data ?? {};
          final workerName = workerData['username'] ?? 'Unknown';
          final workerPhone = workerData['phoneNumber'] ?? 'Unknown';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Info Section
                Container(
                  height: 200,
                  width: double.infinity,
                  color: theme.colorScheme.primary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: theme.colorScheme.surface,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        workerName, // Display worker's username
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '📞 $workerPhone', // Display worker's phone number
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '12', // Example total posts count
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'НИЙТ ГАРСАН',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '4.5', // Example rating
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'ҮНЭЛГЭЭ',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 1, color: Colors.grey),

                // School Police History Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'School Police түүх',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '12',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SchoolPoliceHistoryCard(
                              schoolName: '3-р сургууль',
                              rating: 4,
                            ),
                            const SizedBox(width: 10),
                            SchoolPoliceHistoryCard(
                              schoolName: '3-р сургууль',
                              rating: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Confirm Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () => _acceptedRequest(context), // Pass context explicitly
                    style: theme.elevatedButtonTheme.style,
                    child: Text(
                      'Батлах',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}*/