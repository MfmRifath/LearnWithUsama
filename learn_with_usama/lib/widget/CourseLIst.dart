import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/screens/EditCourseScreen.dart';
import 'package:learn_with_usama/services/database.dart';

import '../models/Courses.dart';
import '../services/Course&SectionSevices.dart';

class CourseList extends StatefulWidget {
  final Courses course;
  final VoidCallback toggle;

  const CourseList({
    Key? key,
    required this.course,
    required this.toggle,

  }) : super(key: key);

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.toggle,
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
              '${widget.course.courseId}. ${widget.course.courseName!}',
              style: TextStyle(color: Colors.deepPurple, fontSize: 16.0),
            ),
          SizedBox(width: 15.0),
          Row(children: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed:() => showAddCourseDialog(context),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _showEditDialog(context,widget.course),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => showDeleteCourseDialog(context, widget.course.courseDoc!)

            ),
          ],)
          ],
        ),
      ),
    );
  }
}
void _showEditDialog(BuildContext context,Courses course) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Unit'),
        content: EditCourseScreen(course: course),
      );
    },
  );
}
void showDeleteCourseDialog(BuildContext context, String courseId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Course'),
        content: Text('Are you sure you want to delete this course?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await Database().deleteCourse(courseId);
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Course deleted successfully')),
                );
              } catch (e) {
                // Handle error gracefully
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting course: $e')),
                );
              }
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}
