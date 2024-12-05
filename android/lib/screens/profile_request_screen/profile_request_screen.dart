import 'package:flutter/material.dart';
import 'package:school_police/widgets/school_police_history_card.dart';

class ProfileRequestScreen extends StatelessWidget {
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
      body: SingleChildScrollView(
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
                    'Цэцэг Цэцэг', // User name
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22, // Set font size for user name
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '📞 99887766', // Phone number
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 16, // Set font size for phone number
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
                      '12', // Total posts count
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18, // Font size for stats
                      ),
                    ),
                    Text(
                      'НИЙТ ГАРСАН',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: 12, // Font size for stats label
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      '4.5', // Rating
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18, // Font size for stats
                      ),
                    ),
                    Text(
                      'ҮНЭЛГЭЭ',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: 12, // Font size for stats label
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
                          fontSize: 18, // Font size for section title
                        ),
                      ),
                      Text(
                        '12',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 16, // Font size for count label
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
            const SizedBox(height: 30),

            // User Information Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Хэрэглэгчийн мэдээлэл',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildUserInfoRow(theme, 'Овог:', 'Цэцэг'),
                  _buildUserInfoRow(theme, 'Нэр:', 'Наран'),
                  _buildUserInfoRow(theme, 'Нас:', '25'),
                  _buildUserInfoRow(theme, 'Хүйс:', 'Эмэгтэй'),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Confirm Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {},
                style: theme.elevatedButtonTheme.style,
                child: Text(
                  'Батлах',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 16, // Font size for button text
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // User information row
  Widget _buildUserInfoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
