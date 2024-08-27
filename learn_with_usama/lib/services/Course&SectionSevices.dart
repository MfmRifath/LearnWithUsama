import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/Courses.dart';
import '../models/Section.dart';

// Add Course Dialog
Future<void> showAddCourseDialog(BuildContext context, FirebaseFirestore _firestore) async {
  String courseName = '';
  String courseId = '';
  String unitId = '';

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add New Course'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Course Name'),
            onChanged: (value) {
              courseName = value;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Course ID'),
            onChanged: (value) {
              courseId = value;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Unit ID'),
            onChanged: (value) {
              unitId = value;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              final addCourse = Courses(courseId: courseId, courseName: courseName, unitId: unitId);
              await _firestore.collection('courses').add(addCourse.toMap());
              Navigator.of(context).pop();
            } catch (e) {
              print('Error adding course: $e');
            }
          },
          child: Text('Add'),
        ),
      ],
    ),
  );
}

// Add Section Dialog
Future<void> showAddSectionDialog(String courseId, BuildContext context, FirebaseFirestore _firestore) async {
  String sectionName = '';
  String sectionUrl = '';
  String sectionDuration = '';
  String sectionId = '';
  String courseId ='';

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add New Section'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Section Name'),
            onChanged: (value) {
              sectionName = value;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Section URL'),
            onChanged: (value) {
              sectionUrl = value;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Section ID'),
            onChanged: (value) {
              sectionId = value;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Course Id'),
            onChanged: (value) {
              courseId = value;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Section Duration'),
            onChanged: (value) {
              sectionDuration = value;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              final addSection = Section(sectionUrl: sectionUrl, sectionName: sectionName,sectionId: sectionId ,sectionDuration: sectionDuration,courseId: courseId);
              await _firestore.collection('section').add(addSection.toMap());
              Navigator.of(context).pop();
            } catch (e) {
              print('Error adding section: $e');
            }
          },
          child: Text('Add'),
        ),
      ],
    ),
  );
}

// Edit Course Dialog
Future<void> showEditCourseDialog(Courses course, BuildContext context, FirebaseFirestore _firestore) async {
  String courseName = course.courseName;
  String? courseId = course.courseId;
  String? unitId = course.unitId;

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Edit Course'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Course Name'),
            onChanged: (value) {
              courseName = value;
            },
            controller: TextEditingController(text: courseName),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Course ID'),
            onChanged: (value) {
              courseId = value;
            },
            controller: TextEditingController(text: courseId),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Unit ID'),
            onChanged: (value) {
              unitId = value;
            },
            controller: TextEditingController(text: unitId),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              final editCourse = Courses(courseId: courseId, courseName: courseName, unitId: unitId);
              await _firestore.collection('courses').doc(course.courseId).update(editCourse.toMap());
              Navigator.of(context).pop();
            } catch (e) {
              print('Error updating course: $e');
            }
          },
          child: Text('Update'),
        ),
      ],
    ),
  );
}

// Edit Section Dialog
Future<void> showEditSectionDialog(Section section, BuildContext context, FirebaseFirestore _firestore) async {
  String? sectionName = section.sectionName;
  String sectionUrl = section.sectionUrl;
  String? sectionDuration = section.sectionDuration;

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Edit Section'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Section Name'),
            onChanged: (value) {
              sectionName = value;
            },
            controller: TextEditingController(text: sectionName),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Section URL'),
            onChanged: (value) {
              sectionUrl = value;
            },
            controller: TextEditingController(text: sectionUrl),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Section Duration'),
            onChanged: (value) {
              sectionDuration = value;
            },
            controller: TextEditingController(text: sectionDuration),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              final editSection = Section(sectionUrl: sectionUrl, sectionDuration: sectionDuration,sectionName: sectionName);
              await _firestore.collection('section').doc(section.sectionId).update(editSection.toMap());
              Navigator.of(context).pop();
            } catch (e) {
              print('Error updating section: $e');
            }
          },
          child: Text('Update'),
        ),
      ],
    ),
  );
}

// Delete Course
Future<void> deleteCourse(Courses course, FirebaseFirestore _firestore, BuildContext context) async {
  bool confirm = await showConfirmationDialog('Delete this course?', context);
  if (confirm) {
    try {
      await _firestore.collection('courses').doc(course.courseId).delete();
    } catch (e) {
      print('Error deleting course: $e');
    }
  }
}

// Delete Section
Future<void> deleteSection(Section section, FirebaseFirestore _firestore, BuildContext context) async {
  bool confirm = await showConfirmationDialog('Delete this section?', context);
  if (confirm) {
    try {
      await _firestore.collection('section').doc(section.sectionId).delete();
    } catch (e) {
      print('Error deleting section: $e');
    }
  }
}

// Confirmation Dialog
Future<bool> showConfirmationDialog(String message, BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmation'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Confirm'),
        ),
      ],
    ),
  ) ?? false;
}
