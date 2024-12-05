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
              Tab(text: 'Ирсэн хүсэлт'), // Incoming Requests
              Tab(text: 'Баталгаажсан хүсэлт'), // Confirmed Requests
            ],
          ),
          backgroundColor: theme.appBarTheme.backgroundColor,
        ),
        body: TabBarView(
          children: [
            // Incoming Requests Tab
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .where('owner_id', isEqualTo: userId) // Filter by ad owner ID
                  .where('state', isEqualTo: 'pending') // Show only pending
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No incoming requests found.'));
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return NotificationCard(
                      title: 'Incoming Request',
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

            // Confirmed Requests Tab
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .where('worker_id', isEqualTo: userId) // Filter by worker ID
                  .where('state', isEqualTo: 'accepted') // Show only accepted
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No confirmed requests found.'));
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return NotificationCard(
                      title: 'Accepted Request',
                      message: 'Ad ID: ${request['ad_id']}',
                      time: request['created_at'] != null
                          ? (request['created_at'] as Timestamp)
                              .toDate()
                              .toString()
                          : 'Unknown Time',
                      imageUrl: 'https://via.placeholder.com/150',
                      onTap: () {
                        // Placeholder for any action on accepted request
                      },
                    );
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
