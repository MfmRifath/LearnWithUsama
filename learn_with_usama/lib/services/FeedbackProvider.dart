import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feedback.dart';

class FeedbackProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Feedback1> _feedbacks = [];

  List<Feedback1> get feedbacks => _feedbacks;

  Future<void> fetchFeedbacks() async {
    try {
      print('Fetching feedbacks...');
      QuerySnapshot snapshot = await _firestore
          .collection('feedback')
          .orderBy('createdAt', descending: true)
          .get();
      _feedbacks =
          snapshot.docs.map((doc) => Feedback1.fromDocument(doc)).toList();
      print('Fetched ${_feedbacks.length} feedbacks.');
      notifyListeners();
    } catch (e) {
      print('Error fetching feedbacks: $e');
    }
  }

  Future<void> addFeedback(
      String message, String name, String profileImageUrl) async {
    try {
      DocumentReference docRef =
      await _firestore.collection('feedback').add({
        'message': message,
        'name': name,
        'profileImageUrl': profileImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Feedback1 feedback = Feedback1(
        id: docRef.id,
        message: message,
        name: name,
        profileImageUrl: profileImageUrl,
        createdAt: Timestamp.now(),
      );

      _feedbacks.add(feedback);
      notifyListeners();
    } catch (e) {
      print('Error adding feedback: $e');
    }
  }

  Future<void> deleteFeedback(String feedbackId) async {
    try {
      await _firestore.collection('feedback').doc(feedbackId).delete();
      _feedbacks.removeWhere((feedback) => feedback.id == feedbackId);
      notifyListeners();
    } catch (e) {
      print('Error deleting feedback: $e');
    }
  }
}
