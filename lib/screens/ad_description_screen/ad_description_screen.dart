import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/ad.dart';
import '../ad_description_screen/ad_description_bloc.dart';
import '../ad_description_screen/ad_description_event.dart';
import '../ad_description_screen/ad_description_state.dart';

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
                // Profile Picture and Username
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(widget.ad.profilePic),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.ad.userName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // White Rectangle Content with Expanded to fill remaining space
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                        child: BlocProvider(
                          create: (context) => AdDescriptionBloc(),
                          child: BlocListener<AdDescriptionBloc, AdDescriptionState>(
                            listener: (context, state) {
                              if (state is JobRequestLoading) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Sending request...')),
                                );
                              } else if (state is JobRequestSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Request sent successfully!')),
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
                                        widget.ad.address,
                                        style: TextStyle(fontSize: 25, color: Colors.black),
                                      ),
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
                                      Icon(Icons.visibility, color: Colors.grey),
                                      SizedBox(width: 3),
                                      Text('${widget.ad.views}',
                                          style: TextStyle(color: Colors.black54)),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  // Price and Shift Info
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        child: _buildInfoCard(
                                          'Үнэ / Хөлс',
                                          widget.ad.price + '₮',
                                          icon: Icons.attach_money,
                                          iconColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                          iconBackground: Theme.of(context).colorScheme.surfaceContainerHighest,
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.45,
                                        child: _buildInfoCard(
                                          'Хугацаа',
                                          widget.ad.shift,
                                          icon: Icons.access_time,
                                          iconColor: Theme.of(context).colorScheme.tertiary,
                                          iconBackground: Theme.of(context).colorScheme.tertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Дэлгэрэнгүй',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isExpanded ? "See Less" : "See More",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Tags and Action Buttons
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.group, color: Colors.orange),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Хүсэлт: ${widget.ad.requestCount}',
                                                style: TextStyle(fontSize: 16, color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Text(
                                                'Огноо: ${widget.ad.date}',
                                                style: TextStyle(fontSize: 16, color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          _buildActionButton(
                                            context,
                                            label: 'Хүсэлт илгээх',
                                            color: Theme.of(context).colorScheme.tertiary,
                                            icon: Icons.group,
                                            onPressed: () {
                                              context.read<AdDescriptionBloc>().add(
                                                SubmitJobRequest(widget.ad.id),
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          _buildActionButton(
                                            context,
                                            label: 'Холбоо барих',
                                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                            icon: Icons.phone,
                                            onPressed: () {
                                              _launchPhoneDialer(widget.phoneNumber);
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
                icon: Icon(Icons.arrow_back, color: Colors.white),
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
      {required IconData icon, required Color iconColor, required Color iconBackground}) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(text, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionButton(BuildContext context, {required String label, required Color color, IconData? icon, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: icon != null ? Icon(icon, color: Colors.white) : SizedBox.shrink(),
      label: Text(label, style: TextStyle(color: Colors.white)),
      onPressed: onPressed,
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
