import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:learn_with_usama/models/Unit.dart';

import 'Courses.dart';

class Section  {
  final String? sectionId;
  final String sectionUrl;
  final String? sectionName;
  final String? sectionDuration;
  final String? courseId;
  Courses? courses;

  Section({this.courseId,
    this.sectionId,
    required this.sectionUrl,
    this.sectionName,
    this.sectionDuration,
  });

  // Factory constructor to create a Section from a Firestore document
  factory Section.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Section(
      sectionId: data['sectionId'] as String?,
      // Use the document ID for sectionId
      sectionName: data['sectionName'] as String?,
      sectionUrl: data['sectionUrl'] as String,
      sectionDuration: data['sectionDuration'] as String?,
      courseId: data['coursesId'] as String, // Ensure coursesId is part of the document
    );
  }

  // Method to convert a Section to Firestore document data
  Map<String, dynamic> toMap() {
    return {
      'sectionName': sectionName,
      'sectionUrl': sectionUrl,
      'sectionDuration': sectionDuration,
      'courseId': courseId,
      'sectionId': sectionId,// Include coursesId when converting to map
    };
  }

  // Method to update the Section in Firestore
  Future<void> update() {
    final sectionRef = FirebaseFirestore.instance.collection('section').doc(
        sectionId);
    return sectionRef.update(toMap());
  }

  // Static method to delete a Section from Firestore
  static Future<void> delete(String sectionId) {
    final sectionRef = FirebaseFirestore.instance.collection('section').doc(
        sectionId);
    return sectionRef.delete();
  }


}