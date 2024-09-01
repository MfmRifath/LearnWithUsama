import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/models/Paper.dart';
import '../models/Courses.dart';
import '../models/PaperCourse.dart';
import '../models/PaperSection.dart';
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
          unitImageUrl: data['unitImageUrl'] as String ?? '',
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
        'unitImageUrl': unit.unitImageUrl
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
        'unitImageUrl':unit.unitImageUrl
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
  Stream<List<Paper>>? get paper {
    return _firestore.collection('papers').snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((DocumentSnapshot document) {
        final data = document.data() as Map<String, dynamic>;
        return Paper(
          paperName: data['paperName'] as String? ?? '',
          paperId: data['paperId'] as String? ?? '',
          year: data['year'] as String ?? '',
          payment: data['payment'] as String? ?? '',
          overviewDescription: data['overviewDescription'] as String? ?? '',
          paperImageUrl: data['paperImageUrl'] as String ?? '',
          documentId: document.id,
        );
      }).toList();
    }).handleError((error) {
      print('Error fetching papers: $error');
      return <Unit>[]; // Return an empty list on error
    });
  }

  // Fetch courses
  Stream<List<PaperCourses>>? get paperCourses {
    return _firestore.collection('PaperCourses').orderBy('courseId').snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((DocumentSnapshot document) {
        final data = document.data() as Map<String, dynamic>;
        return PaperCourses(
            courseId: data['courseId'] as String,
            courseName: data['courseName'] as String? ?? '',
            paperId:  data['paperId'] as String? ?? '',
            courseDoc: document.id
        );
      }).toList();
    }).handleError((error) {
      print('Error fetching Paper courses: $error');
      return <Courses>[]; // Return an empty list on error
    });
  }

  // Fetch sections
  Stream<List<PaperSection>>? get paperSections {
    return _firestore.collection('PaperSection').orderBy('sectionId').snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((DocumentSnapshot document) {
        final data = document.data() as Map<String, dynamic>;
        return PaperSection(
          sectionId: data['sectionId'] as String,
          sectionName: data['sectionName'] as String? ?? '',
          sectionUrl: data['sectionUrl'] as String? ?? '',
          sectionDuration: data['sectionDuration'] as String? ?? '',
          courseId: data['courseId'] as String? ?? '',
          sectionDoc: document.id,
          paperId: data['paperId'] as String? ?? '',
        );
      }).toList();
    }).handleError((error) {
      print('Error fetching sections: $error');
      return <Section>[]; // Return an empty list on error
    });
  }

  // Add a new unit
  Future<void> addPaper(Paper paper) async {
    try {
      await _firestore.collection('papers').add({
        'paperId': paper.paperId,
        'paperName': paper.paperName,
        'year' : paper.year,
        'payment': paper.payment,
        'overviewDescription': paper.overviewDescription,
        'paperImageUrl' : paper.paperImageUrl,
      });
      notifyListeners();
    } catch (e) {
      print('Error adding paper: $e');
    }
  }

  // Update an existing unit
  Future<void> updatePaper(Paper paper) async {
    try {
      await _firestore.collection('papers').doc(paper.documentId).update({
        'paperId': paper.paperId,
        'paperName': paper.paperName,
        'year': paper.year,
        'payment': paper.payment,
        'overviewDescription': paper.overviewDescription,
      });
      notifyListeners();
    } catch (e) {
      print('Error updating paper: $e');
    }
  }

  // Delete a unit
  Future<void> deletePaper(String? documentId) async {
    try {
      await _firestore.collection('papers').doc(documentId).delete();
      notifyListeners();
    } catch (e) {
      print('Error deleting paper: $e');
    }
  }

  // Add a new course
  Future<void> addPaperCourse(PaperCourses course) async {
    try {
      await _firestore.collection('PaperCourses').add({
        'courseId': course.courseId,
        'courseName': course.courseName,
        'paperId': course.paperId,
      });
      notifyListeners();
    } catch (e) {
      print('Error adding Paper course: $e');
    }
  }

  Future<void> updatePaperCourse(PaperCourses course, BuildContext context) async {
    try {
      // Check if the document exists
      DocumentSnapshot doc = await _firestore.collection('PaperCourses').doc(course.courseDoc).get();

      if (!doc.exists) {
        print('Course document with ID ${course.courseDoc} not found.');
        // You can show a message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course not found. Please check the course ID.')),
        );
        return; // Exit the method if the document is not found
      }

      // Proceed with the update if the document exists
      await _firestore.collection('PaperCourses').doc(course.courseDoc).update({
        'courseName': course.courseName,
        'courseId': course.courseId,
        'paperId': course.paperId,
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
  Future<void> deletePaperCourse(String courseDoc) async {
    try {
      await _firestore.collection('PaperCourses').doc(courseDoc).delete();
      notifyListeners();
    } catch (e) {
      print('Error deleting course: $e');
    }
  }

  // Add a new section
  Future<void> addPaperSection(PaperSection section) async {
    try {
      await _firestore.collection('PaperSection').add({
        'sectionId': section.sectionId,
        'sectionName': section.sectionName,
        'sectionUrl': section.sectionUrl,
        'sectionDuration': section.sectionDuration,
        'courseId': section.courseId,
        'paperId' : section.paperId
      });
      notifyListeners();
    } catch (e) {
      print('Error adding section: $e');
    }
  }

  // Update an existing section
  Future<void> updatePaperSection(PaperSection section) async {
    try {
      await _firestore.collection('PaperSection').doc(section.sectionDoc).update({
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
  Future<void> deletePaperSection(String sectionDoc) async {
    try {
      await _firestore.collection('PaperSection').doc(sectionDoc).delete();
      notifyListeners();
    } catch (e) {
      print('Error deleting section: $e');
    }
  }
}
