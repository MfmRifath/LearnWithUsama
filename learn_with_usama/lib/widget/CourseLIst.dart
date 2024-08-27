import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Courses.dart';

class CourseList extends StatelessWidget {
  final Courses course;
  final VoidCallback toggle;


  const CourseList({
    Key? key,
    required this.course,
    required this.toggle,

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

          ],
        ),
      ),
    );
  }
}
