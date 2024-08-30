import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/Courses.dart';
import '../models/Section.dart';
import '../models/Unit.dart';

class Database with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch units
  Stream<List<Unit>>? get units {
    return _firestore.collection('units').snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((DocumentSnapshot document) {
        final data = document.data() as Map<String, dynamic>;
        return Unit(
          unitNumber: data['unitNumber'] as String? ?? '',
          unitName: data['unitName'] as String? ?? '',
          payment: data['payment'] as String? ?? '',
          overviewDescription: data['overviewDescription'] as String? ?? '',
          documentId: document.id,
        );
      }).toList();
    }).handleError((error) {
      print('Error fetching units: $error');
      return <Unit>[]; // Return an empty list on error
    });
  }

  // Fetch courses
  Stream<List<Courses>>? get courses {
    return _firestore.collection('courses').orderBy('courseId').snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((DocumentSnapshot document) {
        final data = document.data() as Map<String, dynamic>;
        return Courses(
          courseId: data['courseId'] as String,
          courseName: data['courseName'] as String? ?? '',
          unitId:  data['unitId'] as String? ?? '',
          courseDoc: document.id
        );
      }).toList();
    }).handleError((error) {
      print('Error fetching courses: $error');
      return <Courses>[]; // Return an empty list on error
    });
  }

  // Fetch sections
  Stream<List<Section>>? get sections {
    return _firestore.collection('section').orderBy('sectionId').snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((DocumentSnapshot document) {
        final data = document.data() as Map<String, dynamic>;
        return Section(
          sectionId: data['sectionId'] as String,
          sectionName: data['sectionName'] as String? ?? '',
          sectionUrl: data['sectionUrl'] as String? ?? '',
          sectionDuration: data['sectionDuration'] as String? ?? '',
          courseId: data['courseId'] as String? ?? '',
          sectionDoc: document.id,
            unitId: data['unitId'] as String? ?? '',
        );
      }).toList();
    }).handleError((error) {
      print('Error fetching sections: $error');
      return <Section>[]; // Return an empty list on error
    });
  }

  // Add a new unit
  Future<void> addUnit(Unit unit) async {
    try {
      await _firestore.collection('units').add({
        'unitNumber': unit.unitNumber,
        'unitName': unit.unitName,
        'payment': unit.payment,
        'overviewDescription': unit.overviewDescription,
      });
      notifyListeners();
    } catch (e) {
      print('Error adding unit: $e');
    }
  }

  // Update an existing unit
  Future<void> updateUnit(Unit unit) async {
    try {
      await _firestore.collection('units').doc(unit.documentId).update({
        'unitNumber': unit.unitNumber,
        'unitName': unit.unitName,
        'payment': unit.payment,
        'overviewDescription': unit.overviewDescription,
      });
      notifyListeners();
    } catch (e) {
      print('Error updating unit: $e');
    }
  }

  // Delete a unit
  Future<void> deleteUnit(String? documentId) async {
    try {
      await _firestore.collection('units').doc(documentId).delete();
      notifyListeners();
    } catch (e) {
      print('Error deleting unit: $e');
    }
  }

  // Add a new course
  Future<void> addCourse(Courses course) async {
    try {
      await _firestore.collection('courses').add({
        'courseId': course.courseId,
        'courseName': course.courseName,
        'unitId': course.unitId,
      });
      notifyListeners();
    } catch (e) {
      print('Error adding course: $e');
    }
  }

  Future<void> updateCourse(Courses course, BuildContext context) async {
    try {
      // Check if the document exists
      DocumentSnapshot doc = await _firestore.collection('courses').doc(course.courseDoc).get();

      if (!doc.exists) {
        print('Course document with ID ${course.courseDoc} not found.');
        // You can show a message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course not found. Please check the course ID.')),
        );
        return; // Exit the method if the document is not found
      }

      // Proceed with the update if the document exists
      await _firestore.collection('courses').doc(course.courseDoc).update({
        'courseName': course.courseName,
        'courseId': course.courseId,
        'unitId': course.unitId,
      });

      // Notify listeners and show success message
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course updated successfully')),
      );
      print('Course updated successfully');
    } catch (e) {
      print('Error updating course: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update course: $e')),
      );
    }
  }

  // Delete a course
  Future<void> deleteCourse(String courseDoc) async {
    try {
      await _firestore.collection('courses').doc(courseDoc).delete();
      notifyListeners();
    } catch (e) {
      print('Error deleting course: $e');
    }
  }

  // Add a new section
  Future<void> addSection(Section section) async {
    try {
      await _firestore.collection('section').add({
        'sectionId': section.sectionId,
        'sectionName': section.sectionName,
        'sectionUrl': section.sectionUrl,
        'sectionDuration': section.sectionDuration,
        'courseId': section.courseId,
        'unitId' : section.unitId
      });
      notifyListeners();
    } catch (e) {
      print('Error adding section: $e');
    }
  }

  // Update an existing section
  Future<void> updateSection(Section section) async {
    try {
      await _firestore.collection('section').doc(section.sectionDoc).update({
        'sectionName': section.sectionName,
        'sectionUrl': section.sectionUrl,
        'sectionDuration': section.sectionDuration,
        'courseId': section.courseId,
      });
      notifyListeners();
    } catch (e) {
      print('Error updating section: $e');
    }
  }

  // Delete a section
  Future<void> deleteSection(String sectionDoc) async {
    try {
      await _firestore.collection('section').doc(sectionDoc).delete();
      notifyListeners();
    } catch (e) {
      print('Error deleting section: $e');
    }
  }
}
