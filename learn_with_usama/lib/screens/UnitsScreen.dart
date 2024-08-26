import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/models/Courses.dart';
import 'package:learn_with_usama/models/Section.dart';
import 'package:learn_with_usama/screens/CourseScreen.dart';

import '../models/Unit.dart';
import 'AddUnitScreen.dart';
import 'EditUnitScreen.dart';

class Units extends StatelessWidget {
  const Units({  this.unit,  this.courses, this.section});
  final Unit? unit;
  final Courses? courses;
  final Section? section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: TextButton(

        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Color(0xffFF8A8A)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseScreen(course: courses,section: section,unit: unit,)),
          );
        },
        child: ListTile(
          contentPadding: EdgeInsets.all(10.0),
          leading: Image.asset(
            'images/${unit!.unitName}.jpg', // Adjust file extension if needed
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
          title: Text(
            '${unit!.unitNumber}. ${unit!.unitName}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Handle edit action
                  _showEditDialog(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Handle delete action
                  _showDeleteDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Unit'),
          content: EditUnitScreen(
            unit: unit!,
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Unit'),
          content: Text('Are you sure you want to delete this unit?'),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await Unit.delete(unit!.documentId);
                  Navigator.of(context).pop(); // Close the dialog
                } catch (e) {
                  // Handle error here
                  print('Error deleting unit: $e');
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
}
class AddUnitDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: AddUnitScreen(),
    );
  }
}