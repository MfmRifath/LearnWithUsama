import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/screens/LoginScreen.dart';

class NavDrawer extends StatefulWidget {
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    Future<void> signOut() async {
      try {
        await FirebaseAuth.instance.signOut();
        print('User signed out successfully.');
        // Navigate to the login screen or any other appropriate screen
      } catch (e) {
        print('Error signing out: $e');
      }
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('images/big_usama.png'),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center, // Center the image horizontally

                  child: Positioned(
                    bottom: 100.0, // Adjust the image position to align its center with the bottom of DrawerHeader
                    child: Transform.translate(
                      offset: Offset(0,60),
                      child: Container(
                        width: 80.0,  // Set the width of the image
                        height: 80.0, // Set the height of the image
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4.0,
                          ),// If you want the image to be circular
                          image: DecorationImage(
                            image: AssetImage('images/Usama.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            SizedBox(height: 8.0),  // Space between the image and text
            Align(
              alignment: Alignment.center,
              child: Positioned(
                bottom: 100.0,
                child: Transform.translate(
                  offset: Offset(0,120),
                  child: Text(
                    "Your Name",  // Display name text
                    style: TextStyle(
                      fontSize: 16.0,  // Font size
                      color: Colors.black,  // Text color
                      fontWeight: FontWeight.bold,  // Text weight
                    ),
                  ),
                ),
              ),
            ),
              ],
            ),
          ),
          SizedBox(height: 40), // Add space to avoid overlap with list tiles
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              setState(() {
           signOut();
           Navigator.pushNamed(context, '/');
              }),

            },
          ),
        ],
      ),
    );
  }
}
