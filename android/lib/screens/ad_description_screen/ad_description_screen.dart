import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/ad.dart';
import '../../services/notification_service.dart';
import '../ad_description_screen/ad_description_bloc.dart';
import '../ad_description_screen/ad_description_event.dart';
import '../ad_description_screen/ad_description_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class AdDescriptionScreen extends StatefulWidget {
  final Ad ad;
  final String phoneNumber;

  const AdDescriptionScreen({
    required this.ad,
    required this.phoneNumber,
  });
  @override
  _AdDescriptionScreenState createState() => _AdDescriptionScreenState();
}

class _AdDescriptionScreenState extends State<AdDescriptionScreen> {
  bool isExpanded = false;
  String? _ownerName; // To store the owner's username

  @override
  void initState() {
    super.initState();
    _fetchOwnerName(); // Fetch owner's name when the screen initializes
  }

  Future<void> _fetchOwnerName() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.ad.ownerId)
          .get();
      if (userDoc.exists) {
        setState(() {
          _ownerName = userDoc.data()?['username'] ?? 'Unknown';
        });
      } else {
        setState(() {
          _ownerName = 'Unknown';
        });
      }
    } catch (e) {
      setState(() {
        _ownerName = 'Error fetching username';
      });
      print('Error fetching owner name: $e');
    }
  }
  Future<void> _sendNotificationToAdOwner() async {
    try {
      final notificationService = NotificationService();

      // Call the service to send a notification
      await notificationService.sendNotificationToAdOwner(
        widget.ad.ownerId, // Owner's ID
        widget.ad.id, // Ad's ID
      );

      print('Notification sent to the ad owner');
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  // Function to format the date
  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate); // Example: 2024-12-01
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 50), // Space for the back arrow
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://media.gettyimages.com/id/1437816897/photo/business-woman-manager-or-human-resources-portrait-for-career-success-company-we-are-hiring.jpg?s=612x612&w=gi&k=20&c=LsB3LmCoN69U82LEYU78IC2tNwOMjy7LJlmEj30UOSs='),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _ownerName ?? 'Loading...', // Display owner's username
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 30),
                        child: BlocProvider(
                          create: (context) => AdDescriptionBloc(),
                          child: BlocListener<AdDescriptionBloc,
                              AdDescriptionState>(
                            listener: (context, state) {
                              if (state is JobRequestLoading) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Sending request...')),
                                );
                              } else if (state is JobRequestSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                      Text('Request sent successfully!')),
                                );
                              } else if (state is JobRequestError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              }
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Address Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.ad.school,
                                        style: const TextStyle(
                                            fontSize: 25, color: Colors.black),
                                      ),
                                      const SizedBox(width: 8),
                                      Image.asset(
                                        'assets/icons/google-maps.png',
                                        width: 25,
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.visibility,
                                          color: Colors.grey),
                                      const SizedBox(width: 3),
                                      Text('${widget.ad.views}',
                                          style: const TextStyle(
                                              color: Colors.black54)),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1, // Adjust flex for relative sizing
                                        child: _buildInfoCard(
                                          'Үнэ / Хөлс',
                                          '${widget.ad.price}₮',
                                          icon: Icons.attach_money,
                                          iconColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                          iconBackground: Theme.of(context).colorScheme.surfaceContainerHighest,
                                          isLarge: true, // Pass flag for large styling
                                        ),
                                      ),
                                      const SizedBox(width: 10), // Add spacing between cards
                                      Expanded(
                                        flex: 1, // Adjust flex for relative sizing
                                        child: _buildInfoCard(
                                          'Хугацаа',
                                          widget.ad.shift,
                                          icon: Icons.access_time,
                                          iconColor: Theme.of(context).colorScheme.tertiary,
                                          iconBackground: Theme.of(context).colorScheme.tertiary,
                                          isLarge: true, // Pass flag for large styling
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Дэлгэрэнгүй',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isExpanded
                                        ? widget.ad.additionalInfo
                                        : widget.ad.additionalInfo.length > 100
                                        ? '${widget.ad.additionalInfo.substring(0, 100)}...'
                                        : widget.ad.additionalInfo,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        isExpanded
                                            ? 'See Less'
                                            : 'See More',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Wrap(
                                    spacing: 12.0,
                                    children: [
                                      _buildTag("Туршлагатай"),
                                      _buildTag("Бүтэн цаг"),
                                      _buildTag("Маргааш"),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.group,
                                                  color: Colors.orange),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Хүсэлт: ${widget.ad.requestCount}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Text(
                                                'Огноо: ${_formatDate(widget.ad.date)}', //${widget.ad.date}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          _buildActionButton(
                                            context,
                                            label: 'Хүсэлт илгээх',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            icon: Icons.group,
                                            onPressed: () {
                                              context
                                                  .read<AdDescriptionBloc>()
                                                  .add(
                                                SubmitJobRequest(
                                                    widget.ad.id),
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          _buildActionButton(
                                            context,
                                            label: 'Холбоо барих',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHighest,
                                            icon: Icons.phone,
                                            onPressed: () {
                                              _launchPhoneDialer(
                                                  widget.phoneNumber);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value,
      {required IconData icon,
        required Color iconColor,
        required Color iconBackground,
        bool isLarge = false,}) {
    return Container(
      padding: EdgeInsets.all(isLarge ? 20 : 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isLarge ? 12 : 8),
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String label,
        required Color color,
        IconData? icon,
        required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
      icon: icon != null ? Icon(icon, color: Colors.white) : const SizedBox.shrink(),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      onPressed: () {
        context.read<AdDescriptionBloc>().add(SubmitJobRequest(widget.ad.id));
        _sendNotificationToAdOwner(); // Call the notification function
      },
    );
  }

  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
}
