import 'package:flutter/material.dart';
import 'package:learn_with_usama/models/Courses.dart';
import 'package:learn_with_usama/models/Section.dart';

import 'package:learn_with_usama/models/Unit.dart';
import 'package:learn_with_usama/services/database.dart';
import '../screens/AddUnitScreen.dart';
import '../screens/EditUnitScreen.dart';
Unit selectedUnit =Unit();

class Units extends StatefulWidget {
  const Units({super.key, required this.unit, this.courses, this.section});
  final Unit? unit;
  final Courses? courses;
  final Section? section;

  @override
  State<Units> createState() => _UnitsState();
}

class _UnitsState extends State<Units> {

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(3.0),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xffFF8A8A)),
        ),
        onPressed: () {
          selectedUnit = widget.unit!;
          Navigator.pushNamed(context,'/courseScreen'
          );
        },
        child: ListTile(
          contentPadding: EdgeInsets.all(10.0),
          leading: Image.asset(
            'images/${widget.unit!.unitName}.jpg', // Adjust file extension if needed
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
          title: Text(
            '${widget.unit!.unitNumber}. ${widget.unit!.unitName}',
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
                  _showEditDialog(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
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
            unit: widget.unit!,
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
                  await Database().deleteUnit(widget.unit!.documentId);
                  Navigator.of(context).pop(); // Close the dialog
                } catch (e) {
                  // Handle error gracefully
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting unit: $e')),
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
}

class AddUnitDialog extends StatelessWidget {
  const AddUnitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: AddUnitScreen(),
    );
  }
}
