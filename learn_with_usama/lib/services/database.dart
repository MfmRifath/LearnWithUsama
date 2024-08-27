import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/models/Courses.dart';
import 'package:learn_with_usama/models/Section.dart';
import 'package:learn_with_usama/models/Unit.dart';

import '../models/Courses.dart';

class Database with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Unit>>? get units {
    return _firestore.collection('units').snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((DocumentSnapshot document) {
        final data = document.data() as Map<String, dynamic>; // Explicitly cast to Map<String, dynamic>
        return Unit(
          unitNumber: data['unitNumber'] as String , // Provide default value if null
          unitName: data['unitName'] as String? ?? '',
          payment: data['payment'] as String ,
          overviewDescription: data['overviewDescription'] as String?,
          documentId: document.id, // Provide default value if null
           // Provide default value if null
        );
      }).toList();
    }).handleError((error) {
      // Handle errors (e.g., log them or show a message to the user)
      print('Error fetching units: $error');
      return []; // Return an empty list on error
    });
  }
  Stream<List<Courses>>? get Course {
    return _firestore.collection('courses').orderBy('courseId').snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((DocumentSnapshot document) {
        final data = document.data() as Map<String, dynamic>; // Explicitly cast to Map<String, dynamic>
        return Courses(
          courseId: data['courseId'] as String?, // Use document ID for courseId
          courseName: data['courseName'] as String? ?? '',
          unitId:  data['unitId'] as String? ?? '',
        );
      }).toList();
    }).handleError((error) {
      // Handle errors (e.g., log them or show a message to the user)
      print('Error fetching units: $error');
      return [print("Error")]; // Return an empty list on error
    });
  }
  Stream<List<Section>>? get section {
    return _firestore.collection('section').orderBy('sectionId').snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((DocumentSnapshot document) {
        final data = document.data() as Map<String, dynamic>; // Explicitly cast to Map<String, dynamic>
        return Section(
          sectionId: data['sectionId'] as String?, // Use the document ID for sectionId
          sectionName: data['sectionName'] as String?,
          sectionUrl: data['sectionUrl'] as String,
          sectionDuration: data['sectionDuration'] as String?,
          courseId: data['courseId'] as String?, // Ensure coursesId is part of the document
        );
      }).toList();
    }).handleError((error) {
      // Handle errors (e.g., log them or show a message to the user)
      print('Error fetching units: $error');
      return [print("error")]; // Return an empty list on error
    });
  }
}
