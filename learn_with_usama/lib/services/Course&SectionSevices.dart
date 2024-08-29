import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/models/Unit.dart';
import 'package:learn_with_usama/services/database.dart';
import '../models/Courses.dart';
import '../models/Section.dart';

// Add Course Dialog
Future<void> showAddCourseDialog(BuildContext context) async {
  String courseName = '';
  String courseId = '';
  String unitId = '';
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add New Course'),
      content: SingleChildScrollView(
        child: Column(
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              await Database().addCourse(Courses(courseId: courseId, courseName: courseName, unitId: unitId));
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
Future<void> showAddSectionDialog(String courseId, BuildContext context) async {
  String sectionName = '';
  String sectionUrl = '';
  String sectionDuration = '';
  String sectionId = '';
  String courseId ='';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add New Section'),
      content: SingleChildScrollView(
        child: Column(
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
              decoration: InputDecoration(labelText: 'Course ID'),
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              await Database().addSection(Section(courseId: courseId, sectionId: sectionId, sectionUrl: sectionUrl, sectionName: sectionName, sectionDuration: sectionDuration));
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

// Confirmation Dialog
Future<bool> showConfirmationDialog(String message, BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmation'),
      content: SingleChildScrollView(
        child: Text(message),
      ),
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
