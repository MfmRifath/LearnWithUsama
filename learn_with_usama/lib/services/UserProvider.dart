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

  List<AppUser> _users = [];

  List<AppUser> get users => _users;

  Future<void> fetchUsers() async {
    try {
      // Fetch users from Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('users').get();
      List<AppUser> fetchedUsers = snapshot.docs.map((doc) {
        return AppUser.fromDocument(doc);
      }).toList();

      _users = fetchedUsers;
      notifyListeners();
    } catch (error) {
      print('Failed to fetch users: $error');
    }
  }
  Future<void> addUser(String uid, String displayName, String email, String profilePictureUrl, String role, bool notificationsEnabled, bool soundEnabled, bool vibrationEnabled) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'displayName': displayName,
        'email': email,
        'profilePictureUrl': profilePictureUrl,
        'role': role, // Add user role
        'notificationsEnabled': notificationsEnabled,
        'soundEnabled': soundEnabled,
        'vibrationEnabled': vibrationEnabled
      });
    } catch (e) {
      print('Error adding user: $e');
      throw e;
    }
  }

  Future<void> updateUser({String? uid,
     String? displayName,
    String? email,
    String? profilePictureUrl,
    String? role,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) async {
    try {
      final userDocRef = _firestore.collection('users').doc(uid);

      final updateData = {
        if (displayName != null) 'displayName': displayName,
        if (email != null) 'email': email,
        if (profilePictureUrl != null) 'profilePictureUrl': profilePictureUrl,
        if (role != null) 'role': role,
        if (notificationsEnabled != null) 'notificationsEnabled': notificationsEnabled,
        if (soundEnabled != null) 'soundEnabled': soundEnabled,
        if (vibrationEnabled != null) 'vibrationEnabled': vibrationEnabled,
      };

      await userDocRef.update(updateData);
      // Optionally, you can also fetch the updated user data
      // to ensure consistency in the app state.
      await fetchUsers();
    } catch (e) {
      print('Error updating user: $e');
      throw e;
    }
  }
}
