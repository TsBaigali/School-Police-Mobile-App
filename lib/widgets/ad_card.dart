import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:school_police/screens/ad_description_screen/ad_description_screen.dart';
import '../../models/ad.dart';

class AdCard extends StatelessWidget {
  final Ad ad;

  const AdCard({Key? key, required this.ad}) : super(key: key);

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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdDescriptionScreen(
              ad: ad,
              phoneNumber: ad.phoneNumber,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage('https://media.gettyimages.com/id/1437816897/photo/business-woman-manager-or-human-resources-portrait-for-career-success-company-we-are-hiring.jpg?s=612x612&w=gi&k=20&c=LsB3LmCoN69U82LEYU78IC2tNwOMjy7LJlmEj30UOSs='),
              ),
              const SizedBox(width: 12.0),

              // Ad Details Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Time Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            ad.school,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          "9:41 AM", // Example placeholder time
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),

                    // Address and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ad.district,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _formatDate(ad.date), // Display formatted date
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),

                    // Price and Shift Info Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Үнэ / Хөлс',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '${ad.price} ₮',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF00204A),
                              ),
                            ),
                          ],
                        ),

                        // Shift Time Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ээлж',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  ad.shift,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Forward Arrow Icon
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF00204A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
