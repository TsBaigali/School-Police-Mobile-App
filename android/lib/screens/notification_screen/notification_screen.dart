import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_bloc.dart';
import 'package:school_police/widgets/notification_card.dart';
import 'package:school_police/screens/profile_request_screen/profile_request_screen.dart';
import 'package:school_police/screens/time_record_screen/time_record_screen.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationBloc(FirebaseFirestore.instance, FirebaseAuth.instance)
        ..add(LoadNotificationsEvent()),
      child: NotificationView(),
    );
  }
}

class NotificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.unselectedWidgetColor,
            tabs: const [
              Tab(text: 'Ирсэн хүсэлт'),
              Tab(text: 'Баталгаажсан хүсэлт'),
            ],
          ),
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is NotificationErrorState) {
              return Center(child: Text(state.error));
            } else if (state is NotificationLoadedState) {
              return TabBarView(
                children: [
                  // Pending Requests Tab
                  StreamBuilder<QuerySnapshot>(
                    stream: state.pendingRequestsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No new requests.'));
                      }
                      final requests = snapshot.data!.docs;
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          final request = requests[index];
                          final adId = request['adId'];
                          final workerId = request['workerId'];
                          final message = request['message'];
                          final timestamp = request['timestamp'];

                          return NotificationCard(
                            title: 'Ирсэн хүсэлт',
                            message: message ?? 'New request for your ad.',
                            time: timestamp != null
                                ? DateTime.fromMillisecondsSinceEpoch(
                                timestamp.seconds * 1000)
                                .toString()
                                : 'Unknown',
                            imageUrl: 'https://via.placeholder.com/150',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileRequestScreen(workerId: workerId, adId: adId),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),

                  // Accepted Requests Tab
                  StreamBuilder<QuerySnapshot>(
                    stream: state.acceptedRequestsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No accepted requests.'));
                      }
                      final requests = snapshot.data!.docs;
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          final request = requests[index];
                          final adId = request['adId'];
                          final workerId = request['workerId'];
                          final message = request['message'];
                          final timestamp = request['timestamp'];

                          return NotificationCard(
                            title: 'Баталгаажсан хүсэлт',
                            message: message ?? 'Your request has been accepted.',
                            time: timestamp != null
                                ? DateTime.fromMillisecondsSinceEpoch(
                                timestamp.seconds * 1000)
                                .toString()
                                : 'Unknown',
                            imageUrl: 'https://via.placeholder.com/150',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TimeRecordScreen(adId: adId),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            }
            return SizedBox.shrink(); // Fallback for unexpected states
          },
        ),
      ),
    );
  }
}
