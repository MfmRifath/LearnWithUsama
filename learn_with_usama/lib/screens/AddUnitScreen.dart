import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/UnitServises.dart';

class AddUnitScreen extends StatefulWidget {
  @override
  _AddUnitScreenState createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
  final _unitNameController = TextEditingController();
  final _unitNumberController = TextEditingController();
  final _docIdController = TextEditingController();
final _paymnetController = TextEditingController();
final _overviewDescriptionController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            controller: _unitNameController,
            decoration: InputDecoration(
              labelText: 'Unit Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _unitNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Unit Number',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _docIdController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'documentId',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _paymnetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'payment',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _overviewDescriptionController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'overviewDescription',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Colors.red),
            ),
          SizedBox(height: 20.0),
          _isSubmitting
              ? CircularProgressIndicator()
              : ElevatedButton(
            onPressed: () {
              addUnit(_unitNameController,_unitNumberController,_isSubmitting,_error,_docIdController as String,_paymnetController,_overviewDescriptionController);
              Navigator.of(context).pop();
            },
            child: Text('Add Unit'),
          ),
        ],
      ),
    );
  }
}
