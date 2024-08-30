import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'NotificationWidget.dart';

class AppBar1 extends StatefulWidget {
  String page;
  AppBar1({required this.page});

  @override
  State<AppBar1> createState() => _AppBar1State();
}

class _AppBar1State extends State<AppBar1> {
  final User? user = FirebaseAuth.instance.currentUser;
  OverlayEntry? _overlayEntry;
  final _auth = FirebaseAuth.instance;

  void _showNotification() {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => NotificationWidget(
        message: 'This is a custom notification',
        onDismiss: () {
          _overlayEntry?.remove();
        },
      ),
    );

    overlay.insert(_overlayEntry!);

    // Optionally, remove the notification after a certain duration
    Future.delayed(Duration(minutes: 3), () {
      _overlayEntry?.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: () {
              if (widget.page == '') {
                Navigator.pop(context);
              } else {
                Navigator.pushNamed(context, widget.page);
              }
            },
            icon: Icon(CupertinoIcons.back),
          ),
          Builder(
            builder: (context) => TextButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                // Open the drawer
                Scaffold.of(context).openDrawer();
              },
              icon: ClipOval(
                child: Image.network(
                  user?.photoURL?.isNotEmpty == true
                      ? user!.photoURL!
                      : 'https://www.freepik.com/free-vector/blue-circle-with-white-user_145857007.htm#query=user&position=2&from_view=keyword&track=ais_hybrid&uuid=4ce622f1-6c18-440b-bed8-9508d7a6eea1', // Replace with your default image URL or asset
                  height: 50.0,
                  width: 50.0,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'images/profile.jpg', // Path to a default asset image
                      height: 50.0,
                      width: 50.0,
                    );
                  },
                ),
              ),
              label: Text(
                '${user?.displayName ?? 'Edit Your Profile'}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            color: Colors.pinkAccent,
            onPressed: _showNotification,
            icon: Icon(CupertinoIcons.bell),
          ),
        ],
      ),
    );
  }
}
