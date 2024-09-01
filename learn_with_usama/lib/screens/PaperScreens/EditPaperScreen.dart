import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/Paper.dart';
import '../../services/database.dart';

class EditPaperScreen extends StatefulWidget {
  final Paper paper;

  const EditPaperScreen({Key? key, required this.paper}) : super(key: key);

  @override
  _EditPaperScreenState createState() => _EditPaperScreenState();
}

class _EditPaperScreenState extends State<EditPaperScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _paperNameController;
  late TextEditingController _paperIdController;
  late TextEditingController _yearController;
  late TextEditingController _paymentController;
  late TextEditingController _overviewDescriptionController;

  bool _isLoading = false;
  File? _newImage;

  @override
  void initState() {
    super.initState();
    _paperNameController = TextEditingController(text: widget.paper.paperName);
    _paperIdController = TextEditingController(text: widget.paper.paperId);
    _paymentController = TextEditingController(text: widget.paper.payment);
    _overviewDescriptionController = TextEditingController(text: widget.paper.overviewDescription);
    _yearController = TextEditingController(text: widget.paper.year);
  }

  @override
  void dispose() {
    _paperNameController.dispose();
    _paperIdController.dispose();
    _paymentController.dispose();
    _overviewDescriptionController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _newImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String? imageUrl;
      if (_newImage != null) {
        try {
          final storageRef = FirebaseStorage.instance.ref().child('papers').child('${widget.paper.paperId}.jpg');
          await storageRef.putFile(_newImage!);
          imageUrl = await storageRef.getDownloadURL();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
        }
      } else {
        imageUrl = widget.paper.paperImageUrl; // Keep the old image URL if no new image is selected
      }

      Paper updatedPaper = Paper(
        documentId: widget.paper.documentId,
        paperName: _paperNameController.text.trim(),
        paperId: _paperIdController.text.trim(),
        payment: _paymentController.text.trim(),
        overviewDescription: _overviewDescriptionController.text.trim(),
        year: _yearController.text.trim(),
        paperImageUrl: imageUrl, // Save the image URL
      );

      try {
        await Database().updatePaper(updatedPaper);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Paper updated successfully')));
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update paper: $e')));
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
        title: Text('Edit Paper'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: AbsorbPointer(
          absorbing: _isLoading,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _newImage == null
                        ? (widget.paper.paperImageUrl != null
                        ? Image.network(widget.paper.paperImageUrl!, fit: BoxFit.cover)
                        : Center(child: Icon(Icons.add_a_photo, color: Colors.grey[700])))
                        : Image.file(_newImage!, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _paperNameController,
                  decoration: InputDecoration(
                    labelText: 'Paper Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the paper name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(
                    labelText: 'Paper Year',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the paper year';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _paperIdController,
                  decoration: InputDecoration(
                    labelText: 'Paper Id',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the paper ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _paymentController,
                  decoration: InputDecoration(
                    labelText: 'Payment',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the payment amount';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _overviewDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Overview Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an overview description';
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
