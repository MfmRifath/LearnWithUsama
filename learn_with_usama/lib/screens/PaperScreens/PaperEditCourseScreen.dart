import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:learn_with_usama/models/Courses.dart';
import '../../models/PaperCourse.dart';
import '../../services/database.dart';


class PaperEditCourseScreen extends StatefulWidget {
  final PaperCourses course;

  const PaperEditCourseScreen({Key? key, required this.course}) : super(key: key);

  @override
  _PaperEditCourseScreenState createState() => _PaperEditCourseScreenState();
}

class _PaperEditCourseScreenState extends State<PaperEditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _courseNameController;
  late TextEditingController _courseIdController;
  late TextEditingController _paperIdController;
  late TextEditingController _courseDocController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _courseNameController = TextEditingController(text: widget.course.courseName);
    _courseIdController = TextEditingController(text: widget.course.courseId);
    _paperIdController =TextEditingController(text: widget.course.paperId);
    _courseDocController =TextEditingController(text: widget.course.courseDoc);
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseIdController.dispose();
    _paperIdController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      PaperCourses updatedCourse = PaperCourses(
        courseDoc: _courseDocController.text.trim(),
        courseId: _courseIdController.text.trim(),
        courseName: _courseNameController.text.trim(),
        paperId: _paperIdController.text.trim(),
      );

      print("Updating course: ${updatedCourse.courseName}, ${updatedCourse.courseId}, ${updatedCourse.paperId}");

      try {
        await Database().updatePaperCourse(updatedCourse, context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course updated successfully')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        print("Failed to update course: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update Course: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Course'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: AbsorbPointer(
          absorbing: _isLoading,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _courseNameController,
                  decoration: InputDecoration(
                    labelText: 'Course Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a course name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _courseIdController,
                  decoration: InputDecoration(
                    labelText: 'Course Id',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a course Id';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _paperIdController,
                  decoration: InputDecoration(
                    labelText: 'Paer Id',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a Paper Id';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.0),
                _isLoading
                    ? SpinKitCubeGrid(
                    color: Color(0xffF37979)
                )
                    : ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
