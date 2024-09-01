import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/screens/PaperScreens/AddPaperScreen.dart';
import 'package:learn_with_usama/services/database.dart';
import '../../models/Paper.dart';
import '../../models/PaperCourse.dart';
import '../../models/PaperSection.dart';
import 'EditPaperScreen.dart';

Paper selectedPaper = Paper();

class Papers extends StatefulWidget {
  const Papers({super.key, required this.paper, this.courses, this.section});
  final Paper paper;
  final PaperCourses? courses;
  final PaperSection? section;

  @override
  State<Papers> createState() => _PapersState();
}

class _PapersState extends State<Papers> {
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
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          onTap: () {

              selectedPaper = widget.paper;
              Navigator.pushNamed(context, '/paperCourseScreen');
          },
          child: ListTile(
            contentPadding: EdgeInsets.all(10.0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                widget.paper.paperImageUrl ?? 'default_image_url',
                height: 50.0,
                width: 50.0,
              ),
            ),
            title: Text(
              '${widget.paper.paperId ?? ''}. ${widget.paper.paperName ?? ''} ${widget.paper?.year ?? ''}',
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
          child: EditPaperScreen(
            paper: widget.paper,
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
          title: Text('Delete Paper'),
          content: Text('Are you sure you want to delete this Paper? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await Database().deletePaper(widget.paper!.documentId);
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Paper deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  // Handle error gracefully
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting paper: $e'),
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

class AddPaperDialog extends StatelessWidget {
  const AddPaperDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: AddPaperScreen(),
    );
  }
}
