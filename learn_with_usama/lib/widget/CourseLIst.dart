// CourseList widget
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Courses.dart';

class CourseList extends StatelessWidget {
  final String? selectedItem;
  final Courses course;
  final VoidCallback toggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddSection;

  const CourseList({
    Key? key,
    required this.selectedItem,
    required this.course,
    required this.toggle,
    required this.onEdit,
    required this.onDelete,
    required this.onAddSection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: onAddSection,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
