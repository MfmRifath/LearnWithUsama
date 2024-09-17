import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'getDeviceId.dart';

Future<void> loginUser(String email, String password, BuildContext context, Widget home) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    // Get device ID
    String? deviceId = await getDeviceId();
    if (deviceId == null) {
      throw Exception("Device ID could not be retrieved.");
    }

    // Sign in user
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    String userId = userCredential.user!.uid;
    DocumentReference userRef = _firestore.collection('users').doc(userId);

    // Get user's document from Firestore
    DocumentSnapshot userDoc = await userRef.get();

    if (userDoc.exists) {
      // Cast the document data to Map<String, dynamic>
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Safely get the 'device_id' field if it exists, otherwise set it to null
      String? storedDeviceId = userData.containsKey('device_id') ? userData['device_id'] : null;

      // Check if the user is already logged in on another device
      if (storedDeviceId != null && storedDeviceId != deviceId) {
        await _auth.signOut();
        throw Exception('User is already logged in on another device.');
      }
    }

    // If no other device is logged in, proceed to update Firestore
    await userRef.set({
      'device_id': deviceId,
      'last_login': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Navigate to Home Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => home),  // Pass the home widget
    );
  } catch (e) {
    print('Error: $e');
    showErrorDialog(e.toString(), context);  // Pass the context
  }
}

Future<void> logoutUser(BuildContext context, String screen) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    String userId = _auth.currentUser!.uid;
    DocumentReference userRef = _firestore.collection('users').doc(userId);

    // Clear the device_id in Firestore
    await userRef.update({
      'device_id': FieldValue.delete(),
    });

    await _auth.signOut();
    Navigator.pushNamed(context, screen);
  } catch (e) {
    print('Error logging out: $e');
  }
}

void showErrorDialog(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Error'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
