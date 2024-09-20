import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:learn_with_usama/models/Courses.dart';
import 'package:learn_with_usama/models/Section.dart';
import 'package:learn_with_usama/models/Unit.dart';
import 'package:learn_with_usama/services/database.dart';

import 'AddUnitScreen.dart';
import 'EditUnitScreen.dart';

Unit selectedUnit = Unit();

class Units extends StatefulWidget {
  const Units({super.key, required this.unit, this.courses, this.section});
  final Unit? unit;
  final Courses? courses;
  final Section? section;

  @override
  State<Units> createState() => _UnitsState();
}

class _UnitsState extends State<Units> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        String role = userDoc['role'];
        setState(() {
          _isAdmin = role == 'Admin';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user role: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Please Login')),
        body: const Center(child: SpinKitHourGlass(color: Colors.black)),
      );
    }
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          onTap: () {
            selectedUnit = widget.unit!;
            Navigator.pushNamed(context, '/courseScreen');
          },
          child: ListTile(
            contentPadding: EdgeInsets.all(10.0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(widget.unit!.unitImageUrl!,width: 50.0,height: 50.0,)
            ),
            title: Text(
              '${widget.unit!.unitNumber}. ${widget.unit!.unitName}',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: _isAdmin
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {
                    _showEditDialog(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    _showDeleteDialog(context);
                  },
                ),
              ],
            )
                : null,
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: EditUnitScreen(
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
          content: Text('Are you sure you want to delete this unit? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await Database().deleteUnit(widget.unit!.documentId);
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Unit deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  // Handle error gracefully
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting unit: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: AddUnitScreen(),
    );
  }
}
