import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../services/UserProvider.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appUser = userProvider.appUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: appUser == null
          ? Center(child: SpinKitCircle(color: Color(0xffF37979)))
          : ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: appUser.notificationsEnabled,
            onChanged: (bool value) {
              userProvider.updatePreferences(notificationsEnabled: value);
            },
          ),
          if (appUser.notificationsEnabled) ...[
            SwitchListTile(
              title: Text('Sound'),
              value: appUser.soundEnabled,
              onChanged: (bool value) {
                userProvider.updatePreferences(soundEnabled: value);
              },
            ),
            SwitchListTile(
              title: Text('Vibration'),
              value: appUser.vibrationEnabled,
              onChanged: (bool value) {
                userProvider.updatePreferences(vibrationEnabled: value);
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notification Tone'),
              subtitle: Text('Default'),
              onTap: () {
                // Handle notification tone change
              },
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
