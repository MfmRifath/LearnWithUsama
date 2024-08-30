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
            // Navigate back
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
                icon: Icons.person,
                title: 'Edit profile',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.security,
                title: 'Security',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.lock,
                title: 'Privacy',
                onTap: () {},
              ),
            ],
          ),
          // Support & About section
          SettingsSection(
            title: 'Support & About',
            tiles: [
              SettingsTile(
                icon: Icons.subscriptions,
                title: 'My Subscription',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.help,
                title: 'Help & Support',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.info,
                title: 'Terms and Policies',
                onTap: () {},
              ),
            ],
          ),
          // Cache & Cellular section
          SettingsSection(
            title: 'Cache & Cellular',
            tiles: [
              SettingsTile(
                icon: Icons.delete,
                title: 'Free up space',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.data_usage,
                title: 'Data Saver',
                onTap: () {},
              ),
            ],
          ),
          // Actions section
          SettingsSection(
            title: 'Actions',
            tiles: [
              SettingsTile(
                icon: Icons.report,
                title: 'Report a problem',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.person_add,
                title: 'Add account',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.logout,
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
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: 2,
        onTap: (index) {
          // Handle navigation
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}