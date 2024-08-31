import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  Future<void> _signOut() async {
    setState(() {
      _isSigningOut = true;
    });
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      // Handle sign out error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    } finally {
      setState(() {
        _isSigningOut = false;
      });
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
                  onTap: () => Navigator.of(context).pop(),
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
                    await _signOut();
                  },
                ),
              ],
            ),
            if (_isSigningOut)
              Center(
                child: SpinKitFadingCube(color: Color(0xffF37979),),
              ),
          ],
        ),
      ),
    );
  }
}
