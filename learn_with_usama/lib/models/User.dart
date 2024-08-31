import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? profilePictureUrl;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String role; // New field for user role

  AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.profilePictureUrl,
    required this.notificationsEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.role, // Initialize role
  });

  // Factory method to create an AppUser instance from Firebase Auth User
  factory AppUser.fromFirebaseUser({
    required String uid,
    String? email,
    String? displayName,
    String? profilePictureUrl,
    String role = 'viewer', // Default role
  }) {
    return AppUser(
      uid: uid,
      email: email,
      displayName: displayName,
      profilePictureUrl: profilePictureUrl,
      notificationsEnabled: true,
      soundEnabled: true,
      vibrationEnabled: true,
      role: role, // Set role
    );
  }

  // Method to create an AppUser instance from Firestore document
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      profilePictureUrl: data['profilePictureUrl'] ?? '',
      notificationsEnabled: data['notificationsEnabled'] ?? true,
      soundEnabled: data['soundEnabled'] ?? true,
      vibrationEnabled: data['vibrationEnabled'] ?? true,
      role: data['role'] ?? 'viewer', // Fetch role from Firestore
    );
  }

  // Method to convert an AppUser instance to Firestore document format
  Map<String, dynamic> toDocument() {
    return {
      'email': email,
      'displayName': displayName,
      'profilePictureUrl': profilePictureUrl,
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'role': role, // Include role in the document
    };
  }

  // Define the copyWith method
  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? profilePictureUrl,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? role,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      role: role ?? this.role, // Handle role updates
    );
  }
}
