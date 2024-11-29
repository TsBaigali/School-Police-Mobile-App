import 'package:flutter/material.dart';
import 'package:school_police/screens/settings_screen/settings_screen.dart';
import 'package:school_police/widgets/ad_profile_card.dart';
import 'package:school_police/widgets/school_police_history_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme

    return Scaffold(
      body: Column(
        children: [
          // Upper Half with primary color background (Profile Info)
          Container(
            color: theme.colorScheme.primary, // Use primary color from theme
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                AppBar(
                  backgroundColor:
                      theme.colorScheme.primary, // Match background
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: theme.colorScheme.onPrimary),
                    onPressed: () {
                      Navigator.pop(context); // Handle back button
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.settings,
                          color: theme.colorScheme.onPrimary),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                  elevation: 0, // Remove shadow from AppBar
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSxSycPmZ67xN1lxHxyMYOUPxZObOxnkLf6w&s',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Доналд Трамп',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color:
                        theme.colorScheme.onPrimary, // White text for the name
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Үлдэгдэл',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.yellow,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '₮50000',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.yellow,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Handle recharge action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            theme.colorScheme.onPrimary, // White button
                        foregroundColor: theme.colorScheme.primary, // Dark text
                      ),
                      child: const Text('Цэнэглэх'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('5 ЗАР',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: theme.colorScheme.onPrimary)),
                    const SizedBox(width: 12),
                    Text('12 АЖИЛ',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: theme.colorScheme.onPrimary)),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        Text(
                          '4.5 ҮНЭЛГЭЭ',
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: theme.colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Section - White background
          Expanded(
            child: Container(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 16),

                  // Description and Registration Date at the top of the bottom section
                  Text(
                    'Өөрийн ерөнхий мэдээллийг оруулах хэсэг...',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 15, // Add font size 15 to headlineMedium
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Бүртгүүлсэн 2024.07.07',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 13, // Add font size 13 to headlineSmall
                    ),
                  ),

                  const SizedBox(height: 16),

                  // "Миний зарууд" section with cards
                  _buildSectionHeader('Миний зарууд', theme),
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        AdProfileCard(
                          schoolName: '3-р сургууль',
                          date: '2024-07-07',
                        ),
                        SizedBox(width: 10),
                        AdProfileCard(
                          schoolName: '3-р сургууль',
                          date: '2024-07-07',
                        ),
                        SizedBox(width: 10),
                        AdProfileCard(
                          schoolName: '3-р сургууль',
                          date: '2024-07-07',
                        ),
                        SizedBox(width: 10),
                        AdProfileCard(
                          schoolName: '3-р сургууль',
                          date: '2024-07-07',
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // "Мэдээлэл шинэчлэх" section
                  ListTile(
                    title: Text(
                      'Мэдээлэл шинэчлэх',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontSize: 20 // Text color based on surface
                              ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: theme.colorScheme.onSurface),
                    onTap: () {
                      // Handle update info action
                    },
                  ),
                  const SizedBox(height: 16),

                  // "School Police түүх" section with cards
                  _buildSectionHeader('School Police түүх', theme),
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
                        const SizedBox(width: 10),
                        SchoolPoliceHistoryCard(
                          schoolName: '3-р сургууль',
                          rating: 4,
                        ),
                        const SizedBox(width: 10),
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
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: theme.textTheme.headlineMedium?.copyWith(
          fontSize: 20, // Use surface color for text
        ),
      ),
    );
  }

  Widget _buildHorizontalCardList(ThemeData theme) {
    return SizedBox(
      height: 100, // Adjust based on your card design
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Number of cards
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 16.0),
            width: 100, // Width for the card
            decoration: BoxDecoration(
              color: theme.colorScheme.surface, // Card background color
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}
