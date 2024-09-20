import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:learn_with_usama/screens/PaidUseraandUnits.dart';
import 'package:learn_with_usama/screens/PaidUsersandPapers.dart';
import 'package:learn_with_usama/services/login.dart';

class NavDrawer extends StatefulWidget {
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  User? user;
  bool _isAdmin = false;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetch user role from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
        if (userDoc.exists) {
          setState(() {
            _isAdmin = userDoc['role'] == 'Admin'; // Adjust this according to your role field
          });
        }
      } catch (e) {
        // Handle error (e.g., log error or show message)
        print('Error fetching user details: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : AssetImage('images/profile.jpg') as ImageProvider,
                    ),
                    SizedBox(height: 16),
                    Text(
                      user?.displayName ?? 'Edit Your Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?.email ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () => {},
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () => Navigator.pushNamed(context, '/setting'),
                ),
                ListTile(
                  leading: Icon(Icons.border_color),
                  title: Text('Feedback'),
                  onTap: () => Navigator.pushNamed(context, '/feedback'),
                ),
                if (_isAdmin)
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings),
                    title: Text('Add Admin'),
                    onTap: () => Navigator.pushNamed(context, '/addAdmin'),
                  ),
                if (_isAdmin)
                  ListTile(
                    leading: Icon(Icons.verified_user),
                    title: Text('User Details'),
                    onTap: () => Navigator.pushNamed(context, '/userDetail'),
                  ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () async {
                    setState(() {
                      _isSigningOut = true; // Show the loading spinner
                    });
                    await logoutUser(context, '/login/');
                    setState(() {
                      _isSigningOut = false; // Hide the loading spinner after logout
                    });

                  },

                ),
                if (_isAdmin)
                ListTile(
                  leading: Icon(Icons.paid),
                  title: Text('Paid Users and Unites'),
                  onTap: () async {

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PaidUsersAndUnitsScreen()));
                  },

                ),
                if (_isAdmin)
                ListTile(
                  leading: Icon(Icons.paid),
                  title: Text('Paid Users and Papers'),
                  onTap: () async {

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PaidUsersAndPapersScreen()));
                  },

                ),
              ],
            ),
            if (_isSigningOut)
              Center(
                child: SpinKitFadingCube(
                  color: Color(0xffF37979),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
