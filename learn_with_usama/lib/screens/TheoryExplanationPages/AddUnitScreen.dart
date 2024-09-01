import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_with_usama/models/Unit.dart';
import 'package:learn_with_usama/services/database.dart';

class AddUnitScreen extends StatefulWidget {
  @override
  _AddUnitScreenState createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
  File? _unitImage;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String unitName = '';
  String unitNumber = '';
  String payment = '';
  String overviewDescription = '';
  bool _isSubmitting = false;
  String? _error;

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _unitImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      String? imageUrl;
      if (_unitImage != null) {
        final storageRef = FirebaseStorage.instance.ref().child('units').child('${unitNumber}.jpg');
        await storageRef.putFile(_unitImage!);
        imageUrl = await storageRef.getDownloadURL();
      }

      // Add your Firestore code here to save the unit details along with the image URL
      await Database().addUnit(Unit(
        unitName: unitName,
        unitNumber: unitNumber,
        payment: payment,
        overviewDescription: overviewDescription,
        unitImageUrl: imageUrl, // Save the image URL
      ));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unit added successfully.')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding unit: $e')));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Size to fit content
          children: <Widget>[
            Text(
              'Add Unit',
              style: GoogleFonts.nunito(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                unitName = value;
              },
              decoration: InputDecoration(
                labelText: 'Unit Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                unitNumber = value;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Unit Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                payment = value;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Payment',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                overviewDescription = value;
              },
              decoration: InputDecoration(
                labelText: 'Overview Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(_unitImage == null ? 'Pick an Image' : 'Change Image'),
            ),
            if (_unitImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Image.file(_unitImage!, height: 100),
              ),
            SizedBox(height: 20.0),
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20.0),
            _isSubmitting
                ? SpinKitCircle(
              color: Color(0xffF37979),
            )
                : ElevatedButton(
              onPressed: _saveDetails,
              child: Text('Add Unit'),
            ),
          ],
        ),
      ),
    );
  }
}
