import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Changed from Cupertino to Material for general Flutter projects
import 'package:learn_with_usama/models/Unit.dart';
import 'package:learn_with_usama/screens/Home.dart';
import 'package:learn_with_usama/screens/startScreen.dart';
import 'package:learn_with_usama/services/database.dart';
import 'package:provider/provider.dart';

class Root extends StatelessWidget {
  @override



  Widget build(BuildContext context) {
    // Use StreamBuilder to listen to authentication state changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for authentication state to be determined, show a loading indicator
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // User is signed in, provide units data to the Home screen
          return StreamProvider<List<Unit>>.value(
            value: Database().units,
            initialData: [],
            child: Home(),
          );
        } else {
          // User is not signed in, show the StartScreen
          return StartScreen();
        }
      },
    );
  }
}
