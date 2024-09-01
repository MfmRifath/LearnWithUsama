import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../models/Section.dart';
import '../../services/database.dart';


class EditSectionScreen extends StatefulWidget {
  final Section section;

  const EditSectionScreen({Key? key, required this.section}) : super(key: key);

  @override
  _EditSectionScreenState createState() => _EditSectionScreenState();
}

class _EditSectionScreenState extends State<EditSectionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _sectionNameController;
  late TextEditingController _sectionIdController;
  late TextEditingController _sectionUrlController;
  late TextEditingController _sectionDurationController;
  late TextEditingController _courseIdController;
  late TextEditingController _unitIdController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sectionNameController = TextEditingController(text: widget.section.sectionName);
    _sectionIdController = TextEditingController(text: widget.section.sectionId);
    _sectionUrlController = TextEditingController(text: widget.section.sectionUrl);
    _sectionDurationController = TextEditingController(text: widget.section.sectionDuration);
    _courseIdController =TextEditingController(text: widget.section.courseId);
    _unitIdController = TextEditingController(text: widget.section.unitId );
  }

  @override
  void dispose() {
    _sectionNameController.dispose();
    _sectionIdController.dispose();
    _sectionUrlController.dispose();
    _sectionDurationController.dispose();
    _courseIdController.dispose();
    _unitIdController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Section updatedSection = Section(
        sectionDoc: widget.section.sectionDoc,
        sectionName: _sectionNameController.text.trim(),
        sectionId: _sectionIdController.text.trim(),
        sectionDuration: _sectionDurationController.text.trim(),
        sectionUrl: _sectionUrlController.text.trim(),
        courseId: _courseIdController.text.trim(),
        unitId: _unitIdController.text.trim(),
      );

      try {
        await Database().updateSection(updatedSection);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Section updated successfully')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update Section: $e')),
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
        title: Text('Edit Section'),
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
                  controller: _sectionNameController,
                  decoration: InputDecoration(
                    labelText: 'Section Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a section name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _sectionIdController,
                  decoration: InputDecoration(
                    labelText: 'Section Id',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a section Id';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _sectionDurationController,
                  decoration: InputDecoration(
                    labelText: 'Section Duration',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a Section Duration';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a Duration';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _sectionUrlController,
                  decoration: InputDecoration(
                    labelText: 'Section URL',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an Section URL';
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an Unit Id';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.0),
                _isLoading
                    ? SpinKitCubeGrid(color: Color(0xffF37979))
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
