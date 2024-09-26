import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../services/Course&SectionSevices.dart';

class AppBar1 extends StatefulWidget {
  final String page;
   final  VoidCallback? push;

  AppBar1({required this.page,this.push});

  @override
  State<AppBar1> createState() => _AppBar1State();
}

class _AppBar1State extends State<AppBar1> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      color: Colors.white60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: () {
              if (widget.page.isEmpty) {
                Navigator.pop(context);
              } else {
                if(widget.push != null) {
                  widget.push?.call();
                }
                Navigator.pushNamed(context, widget.page);


              }
            },
            icon: Icon(CupertinoIcons.back),
          ),
          Builder(
            builder: (context) =>
                TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: ClipOval(
                    child: Image.network(
                      user?.photoURL?.isNotEmpty == true
                          ? user!.photoURL!
                          : 'https://www.freepik.com/free-vector/blue-circle-with-white-user_145857007.htm#query=user&position=2&from_view=keyword&track=ais_hybrid&uuid=4ce622f1-6c18-440b-bed8-9508d7a6eea1',
                      // Replace with your default image URL or asset
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
            onPressed: () {
          Navigator.pushNamed(context, '/notifications');
            },
            icon: Icon(CupertinoIcons.bell),
          ),
        ],
      ),
    );
  }


}