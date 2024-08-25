import 'package:flutter/material.dart';
import '../models/Courses.dart';

class CourseList extends StatefulWidget {
  final String? selectedItem;
  final String? selectedcourseId;
  final Courses course;
  final void Function(String? courseId) onCourseTap;

  CourseList({
    Key? key,
    required this.selectedItem,
    required this.onCourseTap,
    required this.course,
    this.selectedcourseId,
  }) : super(key: key);

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onCourseTap(widget.course.courseId);
        });
      },
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
              widget.course.courseName,
              style: TextStyle(color: Colors.deepPurple, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
