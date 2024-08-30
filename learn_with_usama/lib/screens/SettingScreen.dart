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
                onTap: () {Navigator.pushNamed(context, '/notification');},
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
          Divider(thickness: 1.0, color: Colors.grey.shade300),
          // Support & About section
          SettingsSection(
            title: 'Support & About',
            tiles: [
              SettingsTile(
                icon: Icons.subscriptions_outlined,
                title: 'My Subscription',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.info_outline,
                title: 'Terms and Policies',
                onTap: () {},
              ),
            ],
          ),
          Divider(thickness: 1.0, color: Colors.grey.shade300),
          // Cache & Cellular section
          SettingsSection(
            title: 'Cache & Cellular',
            tiles: [
              SettingsTile(
                icon: Icons.delete_outline,
                title: 'Free up space',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.data_usage_outlined,
                title: 'Data Saver',
                onTap: () {},
              ),
            ],
          ),
          Divider(thickness: 1.0, color: Colors.grey.shade300),
          // Actions section
          SettingsSection(
            title: 'Actions',
            tiles: [
              SettingsTile(
                icon: Icons.report_outlined,
                title: 'Report a problem',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.person_add_outlined,
                title: 'Add account',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.logout_outlined,
                title: 'Log out',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: 2,
        onTap: (index) {
          // Handle navigation based on the tapped index
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle action
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
