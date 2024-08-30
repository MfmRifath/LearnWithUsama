import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/UserProvider.dart';


class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appUser = userProvider.appUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: appUser == null
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching user data
          : ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text('Location Access'),
            subtitle: Text('Allow access to your location for personalized experience.'),
            value: appUser.notificationsEnabled, // Example value from user preferences
            onChanged: (bool value) {
              userProvider.updatePreferences(notificationsEnabled: value); // Update the preference
            },
          ),
          Divider(),
          SwitchListTile(
            title: Text('Data Sharing'),
            subtitle: Text('Share your usage data to improve our services.'),
            value: appUser.soundEnabled, // Example value from user preferences
            onChanged: (bool value) {
              userProvider.updatePreferences(soundEnabled: value); // Update the preference
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Privacy Policy'),
            subtitle: Text('Read our privacy policy.'),
            onTap: () {
              // Navigate to privacy policy page or show in a dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Privacy Policy'),
                  content: SingleChildScrollView(
                    child: Text(
                      'Your privacy is important to us. This policy outlines how we handle your data...',
                      // Add your privacy policy text here
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade600),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.security_outlined),
            title: Text('Terms of Service'),
            subtitle: Text('Read our terms and conditions.'),
            onTap: () {
              // Navigate to terms of service page or show in a dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Terms of Service'),
                  content: SingleChildScrollView(
                    child: Text(
                      'By using our service, you agree to the following terms...',
                      // Add your terms of service text here
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade600),
          ),
          Divider(),
        ],
      ),
    );
  }
}
