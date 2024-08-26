import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NotificationWidget.dart';

class AppBar1 extends StatefulWidget {
  const AppBar1({
    super.key,
  });

  @override
  State<AppBar1> createState() => _AppBar1State();
}

class _AppBar1State extends State<AppBar1> {
  OverlayEntry? _overlayEntry;
  final _auth = FirebaseAuth.instance;;


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
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
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
                child: Image.asset(
                  'images/s2o-academy.png',
                  height: 50.0,
                  width: 50.0,
                ),
              ),
              label: Text(
                '${_auth.currentUser?.email.toString()}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Display notification icon only on larger screens
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
