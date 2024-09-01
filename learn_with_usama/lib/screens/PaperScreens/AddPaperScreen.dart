import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_with_usama/services/database.dart';
import '../../models/Paper.dart';

class AddPaperScreen extends StatefulWidget {
  @override
  _AddPaperScreenState createState() => _AddPaperScreenState();
}

class _AddPaperScreenState extends State<AddPaperScreen> {
  File? _paperImage;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _paperImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;
      if (_paperImage != null) {
        final storageRef = FirebaseStorage.instance.ref().child('papers').child('${paperId}.jpg');
        await storageRef.putFile(_paperImage!);
        imageUrl = await storageRef.getDownloadURL();
      }

      // Add your Firestore code here to save the paper details along with the image URL
      await Database().addPaper(Paper(
        paperName: paperName,
        payment: payment,
        paperId: paperId,
        year: year,
        overviewDescription: overviewDescription,
        paperImageUrl: imageUrl, // Save the image URL
      ));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Paper added successfully.')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding paper: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String paperName = '';
  String year = '';
  String paperId = '';
  String payment = '';
  String overviewDescription = '';
  bool _isSubmitting = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Add Paper',
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _paperImage == null
                        ? Center(child: Icon(Icons.add_a_photo, color: Colors.grey[700]))
                        : Image.file(_paperImage!, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (value) {
                    paperName = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Paper Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the paper name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (value) {
                    year = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Paper Year',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the paper year';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (value) {
                    paperId = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Paper Id',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the paper ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (value) {
                    payment = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Payment',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the payment amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (value) {
                    overviewDescription = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Overview Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an overview description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                if (_error != null)
                  Text(
                    _error!,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20.0),
                _isLoading
                    ? SpinKitCircle(
                  color: Color(0xffF37979),
                )
                    : ElevatedButton(
                  onPressed: _saveDetails, // Call the save function to save paper details
                  child: Text('Add Paper'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
