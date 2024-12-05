import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school_police/screens/profile_request_screen/profile_request_screen.dart';
import 'package:school_police/screens/time_record_screen/time_record_screen.dart';
import 'package:school_police/widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String currentUserId;
  late Stream<QuerySnapshot> _pendingRequestsStream;
  late Stream<QuerySnapshot> _acceptedRequestsStream;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser!.uid; // Get the current user's ID
    _initializeStreams(); // Initialize streams once userId is available
  }

  // Fetch the ownerId from the ad collection using adId and set up streams
  Future<void> _initializeStreams() async {
    try {
      // Fetch the adId of the current user's ad(s)
      final adDocs = await _firestore
          .collection('ad')
          .where('ownerId', isEqualTo: currentUserId)
          .get();

      if (adDocs.docs.isNotEmpty) {
        String adId = adDocs.docs.first.id; // Get the adId

        // Fetch pending and accepted requests related to the adId
        setState(() {
          _pendingRequestsStream = _firestore
              .collection('requests')
              .where('adId', isEqualTo: adId) // Filter requests by adId
              .where('status', isEqualTo: 'pending') // Filter pending requests
              .snapshots();

          _acceptedRequestsStream = _firestore
              .collection('requests')
              .where('adId', isEqualTo: adId) // Filter requests by adId
              .where('status', isEqualTo: 'accepted') // Filter accepted requests
              .snapshots();
          isLoading = false; // Set loading state to false once streams are initialized
        });
      } else {
        print("No ads found for the user.");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching ownerId or adId: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Scaffold(
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
          backgroundColor: theme.appBarTheme.backgroundColor,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
              Tab(text: 'Баталгаажсан хүсэлт'),
              Tab(text: 'Ирсэн хүсэлт'),
            ],
          ),
          backgroundColor: theme.appBarTheme.backgroundColor,
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            // Pending requests (Ирсэн хүсэлт)
            StreamBuilder<QuerySnapshot>(
              stream: _pendingRequestsStream,
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
                          ? DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000).toString()
                          : 'Unknown',
                      imageUrl: 'https://via.placeholder.com/150',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileRequestScreen(),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

            // Accepted requests (Баталгаажсан хүсэлт)
            StreamBuilder<QuerySnapshot>(
              stream: _acceptedRequestsStream,
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
                      message: message ?? 'Request accepted for your ad.',
                      time: timestamp != null
                          ? DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000).toString()
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
        ),
      ),
    );
  }
}




/*import 'package:flutter/material.dart';
import 'package:school_police/screens/profile_request_screen/profile_request_screen.dart';
import 'package:school_police/screens/time_record_screen/time_record_screen.dart';
import 'package:school_police/widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              Tab(text: 'Баталгаажсан хүсэлт'),
              Tab(text: 'Ирсэн хүсэлт'),
            ],
          ),
          backgroundColor: theme.appBarTheme.backgroundColor,
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return NotificationCard(
                  title: 'Баталгаажсан',
                  message: '246 - р сургуулийн school police хүсэлт баталгаажсан байна.',
                  time: '9:41 AM',
                  imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSxSycPmZ67xN1lxHxyMYOUPxZObOxnkLf6w&s',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimeRecordScreen(adId: '1'),
                      ),
                    );
                  },
                );
              },
            ),
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return NotificationCard(
                  title: 'Ирсэн хүсэлт',
                  message: 'Хэрэглэгчээс шинэ хүсэлт ирлээ.',
                  time: '10:30 AM',
                  imageUrl: 'https://via.placeholder.com/150',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileRequestScreen(),
                      ),
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
}*/
