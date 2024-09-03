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
    final data = doc.data() as Map<String, dynamic>;
    return Feedback1(
      id: doc.id,
      message: data['message'] ?? '',
      name: data['name'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
