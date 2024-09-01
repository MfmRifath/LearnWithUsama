import 'package:cloud_firestore/cloud_firestore.dart';

class Feedback1 {
  final String id;
  final String message;
  final String name;
  final String profileImageUrl;
  final Timestamp createdAt;

  Feedback1({
    required this.id,
    required this.message,
    required this.name,
    required this.profileImageUrl,
    required this.createdAt,
  });

  factory Feedback1.fromDocument(DocumentSnapshot doc) {
    return Feedback1(
      id: doc.id,
      message: doc['message'],
      name: doc['name'],
      profileImageUrl: doc['profileImageUrl'],
      createdAt: doc['createdAt'],
    );
  }
}
