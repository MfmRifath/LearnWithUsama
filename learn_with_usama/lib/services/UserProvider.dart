import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/User.dart';


class UserProvider with ChangeNotifier {
  AppUser? _appUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? get appUser => _appUser;

  // Method to initialize the user data
  Future<void> initializeUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (userDoc.exists) {
        _appUser = AppUser.fromDocument(userDoc);
      } else {
        _appUser = AppUser.fromFirebaseUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email,
          displayName: firebaseUser.displayName,
          profilePictureUrl: firebaseUser.photoURL,
        );
        await _firestore.collection('users').doc(_appUser!.uid).set(_appUser!.toDocument());
      }

      notifyListeners();  // Notify listeners after the user is initialized
    }
  }

  // Method to update user preferences
  Future<void> updatePreferences({
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) async {
    if (_appUser != null) {
      _appUser = _appUser!.copyWith(
        notificationsEnabled: notificationsEnabled ?? _appUser!.notificationsEnabled,
        soundEnabled: soundEnabled ?? _appUser!.soundEnabled,
        vibrationEnabled: vibrationEnabled ?? _appUser!.vibrationEnabled,
      );

      // Save to Firestore
      await _firestore.collection('users').doc(_appUser!.uid).set(_appUser!.toDocument());

      notifyListeners();  // Notify listeners after updating preferences
    }
  }
}
