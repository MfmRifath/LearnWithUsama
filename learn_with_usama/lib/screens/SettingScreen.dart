import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();  // Navigate back
          },
        ),
      ),
      body: ListView(
        children: [
          // Account section
          SettingsSection(
            title: 'Account',
            tiles: [
              SettingsTile(
                icon: Icons.person_outline,
                title: 'Edit profile',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.security_outlined,
                title: 'Security',
                onTap: () {Navigator.pushNamed(context, '/security');},
              ),
              SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () {Navigator.pushNamed(context, '/notificationSetting');},
              ),
              SettingsTile(
                icon: Icons.lock_outline,
                title: 'Privacy',
                onTap: () {
                  Navigator.pushNamed(context, '/privacy');

                },
              ),
            ],
          ),

          // Support & About section
        ],
      ),

    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsTile> tiles;

  SettingsSection({required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Colors.grey.shade200,
            width: double.infinity,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          Column(children: tiles),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  SettingsTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade600),
    );
  }
}
