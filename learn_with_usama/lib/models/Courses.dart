import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_with_usama/models/Unit.dart';

class Courses implements Unit {
  final String? courseId; // Make courseId an instance variable
  final String courseName;
  final String? unitId;
  Unit? unit;

  Courses( {
    required this.courseId,
    required this.courseName,
    required this.unitId,
  });

  // Factory constructor to create a Courses from a Firestore document
  factory Courses.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Courses(
      courseId: data['courseId'] as String?, // Use document ID for courseId
      courseName: data['courseName'] as String? ?? '',
       unitId:  data['unitId'] as String?? '',
       // Extract unitId from the document data
    );
  }


  // Method to convert a Courses to Firestore document data
  Map<String, dynamic> toMap() {
    return {
      'courseId' :courseId,
      'courseName': courseName,
      'unitId':unitId,

    };
  }

  // Method to update the Courses in Firestore
  Future<void> update() {
    final courseRef = FirebaseFirestore.instance.collection('courses').doc(courseId);
    return courseRef.update(toMap());
  }

  // Static method to delete a Courses from Firestore
  static Future<void> delete(String courseId) {
    final courseRef = FirebaseFirestore.instance.collection('courses').doc(courseId);
    return courseRef.delete();
  }

  @override
  // TODO: implement documentId
  String get documentId => unitId!;

  @override
  // TODO: implement unitName
  String? get unitName => unit!.unitName;

  @override
  // TODO: implement unitNumber
  String? get unitNumber => throw UnimplementedError();

  @override
  // TODO: implement payment
  String? get payment => throw UnimplementedError();

  @override
  // TODO: implement overviewDescripton
  String? get overviewDescripton => throw UnimplementedError();
}
