import 'package:cloud_firestore/cloud_firestore.dart';

import 'Courses.dart';

class Section implements Courses {
  final String? sectionId;
  final String sectionUrl;
  final String? sectionName;
  final String? sectionDuration;
  final String? coursesId;

  Section({
     this.sectionId,
    required this.sectionUrl,
    this.sectionName,
    this.sectionDuration,
    this.coursesId,
  });

  // Factory constructor to create a Section from a Firestore document
  factory Section.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Section(
      sectionId: data['sectionId'] as String?, // Use the document ID for sectionId
      sectionName: data['sectionName'] as String?,
      sectionUrl: data['sectionUrl'] as String,
      sectionDuration: data['sectionDuration'] as String?,
      coursesId: data['coursesId'] as String?, // Ensure coursesId is part of the document
    );
  }

  // Method to convert a Section to Firestore document data
  Map<String, dynamic> toMap() {
    return {
      'sectionName': sectionName,
      'sectionUrl': sectionUrl,
      'sectionDuration': sectionDuration,
      'coursesId': coursesId, // Include coursesId when converting to map
    };
  }

  // Method to update the Section in Firestore
  Future<void> update() {
    final sectionRef = FirebaseFirestore.instance.collection('section').doc(sectionId);
    return sectionRef.update(toMap());
  }

  // Static method to delete a Section from Firestore
  static Future<void> delete(String sectionId) {
    final sectionRef = FirebaseFirestore.instance.collection('section').doc(sectionId);
    return sectionRef.delete();
  }

  @override
  String get courseId => coursesId ?? ''; // Implement courseId

  @override
  String get courseName => sectionName ?? ''; // Implement courseName

  @override
  String? get unitId => sectionId;

  @override
  // TODO: implement documentId
  String get documentId => throw UnimplementedError();

  @override
  // TODO: implement unitName
  String? get unitName => throw UnimplementedError();

  @override
  // TODO: implement unitNumber
  String? get unitNumber => throw UnimplementedError(); // Implement unitId, using sectionId as unitId
}
