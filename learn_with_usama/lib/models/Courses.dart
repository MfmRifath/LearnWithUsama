import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_with_usama/models/Unit.dart';

class Courses  {
   late final String? courseId; // Make courseId an instance variable
   late final String? courseName;
   late final String? unitId;
  final String? courseDoc;


  Courses({this.courseDoc,
    required this.courseId,
    required this.courseName,
    required this.unitId,
  });

}
