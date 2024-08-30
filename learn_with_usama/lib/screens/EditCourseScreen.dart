import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:learn_with_usama/models/Courses.dart';
import '../models/Section.dart';
import '../models/Unit.dart';
import '../services/database.dart';

class EditCourseScreen extends StatefulWidget {
  final Courses course;

  const EditCourseScreen({Key? key, required this.course}) : super(key: key);

  @override
  _EditCourseScreenState createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _courseNameController;
  late TextEditingController _courseIdController;
  late TextEditingController _unitIdController;
  late TextEditingController _courseDocController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _courseNameController = TextEditingController(text: widget.course.courseName);
    _courseIdController = TextEditingController(text: widget.course.courseId);
    _unitIdController =TextEditingController(text: widget.course.unitId);
    _courseDocController =TextEditingController(text: widget.course.courseDoc);
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseIdController.dispose();
    _unitIdController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Courses updatedCourse = Courses(
        courseDoc: _courseDocController.text.trim(),
        courseId: _courseIdController.text.trim(),
        courseName: _courseNameController.text.trim(),
        unitId: _unitIdController.text.trim(),
      );

      print("Updating course: ${updatedCourse.courseName}, ${updatedCourse.courseId}, ${updatedCourse.unitId}");

      try {
        await Database().updateCourse(updatedCourse, context);
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
                  controller: _unitIdController,
                  decoration: InputDecoration(
                    labelText: 'Unit Id',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a Unit Id';
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
