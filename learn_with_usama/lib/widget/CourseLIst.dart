import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Courses.dart';
import '../services/Course&SectionSevices.dart';

class CourseList extends StatelessWidget {
  final Courses course;
  final VoidCallback toggle;
final FirebaseFirestore firestore;

  const CourseList({
    Key? key,
    required this.course,
    required this.toggle, required this.firestore,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: toggle,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.deepPurpleAccent, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              course.courseName,
              style: TextStyle(color: Colors.deepPurple, fontSize: 16.0),
            ),
          SizedBox(width: 15.0),
          Row(children: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed:() => showAddCourseDialog(context,firestore),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => showEditCourseDialog(course,context,firestore),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteCourse(course,firestore,context),
            ),
          ],)

          ],
        ),
      ),
    );
  }
}
