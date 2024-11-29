import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_police/themes/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // User Information Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'User Information',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: theme.colorScheme.primary),
            title: Text('Edit Profile', style: theme.textTheme.bodyMedium),
            trailing: Icon(Icons.arrow_forward_ios,
                size: 16, color: theme.iconTheme.color),
            onTap: () {
              // Handle Edit Profile navigation
            },
          ),
          Divider(color: theme.colorScheme.surface),
          ListTile(
            leading: Icon(Icons.lock, color: theme.colorScheme.primary),
            title: Text('Change Password', style: theme.textTheme.bodyMedium),
            trailing: Icon(Icons.arrow_forward_ios,
                size: 16, color: theme.iconTheme.color),
            onTap: () {
              // Handle Change Password navigation
            },
          ),

          // App Settings Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'App Settings',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading:
                Icon(Icons.notifications, color: theme.colorScheme.primary),
            title: Text('Notifications', style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: true, // Use your notification setting value here
              onChanged: (bool value) {
                // Handle Notification setting toggle
              },
            ),
          ),
          Divider(color: theme.colorScheme.surface),
          ListTile(
            leading: Icon(Icons.dark_mode, color: theme.colorScheme.primary),
            title: Text('Dark Mode', style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: theme.brightness == Brightness.dark,
              onChanged: (bool isDarkMode) {
                BlocProvider.of<ThemeCubit>(context).toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }
}
