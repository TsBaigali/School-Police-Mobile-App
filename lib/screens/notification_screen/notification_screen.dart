import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school_police/widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId =
        FirebaseAuth.instance.currentUser?.uid; // Get current user ID

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.iconTheme.color,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.primary,
            tabs: const [
              Tab(text: 'Баталгаажсан хүсэлт'), // Confirmed Requests
              Tab(text: 'Ирсэн хүсэлт'), // Incoming Requests
            ],
          ),
          backgroundColor: theme.appBarTheme.backgroundColor,
        ),
        body: TabBarView(
          children: [
            // Requests Tab (Dynamic)
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .where('owner_id', isEqualTo: userId) // Filter by user ID
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No requests found.'));
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return NotificationCard(
                      title: request['state'] == 'pending'
                          ? 'Pending Request'
                          : 'Accepted Request',
                      message:
                          'Request from Worker ID: ${request['worker_id']}',
                      time: request['created_at'] != null
                          ? (request['created_at'] as Timestamp)
                              .toDate()
                              .toString()
                          : 'Unknown Time',
                      imageUrl: 'https://via.placeholder.com/150',
                      onTap: () {
                        // Example: Update state to 'accepted'
                        _updateRequestState(request.id);
                      },
                    );
                  },
                );
              },
            ),

            // Placeholder for Incoming Requests Tab
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return NotificationCard(
                  title: 'Ирсэн хүсэлт', // Incoming Request
                  message:
                      'Хэрэглэгчээс шинэ хүсэлт ирлээ.', // New request from a user
                  time: '10:30 AM',
                  imageUrl: 'https://via.placeholder.com/150',
                  onTap: () {
                    // Placeholder for tap action
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateRequestState(String requestId) {
    FirebaseFirestore.instance.collection('requests').doc(requestId).update({
      'state': 'accepted',
    }).then((_) {
      print('Request updated to accepted.');
    }).catchError((error) {
      print('Error updating request: $error');
    });
  }
}
