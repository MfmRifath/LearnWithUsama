import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/services/UnitServises.dart';

import '../models/Unit.dart';

class EditUnitScreen extends StatefulWidget {
  final Unit unit; // Add documentId to identify which document to update

  const EditUnitScreen({
    Key? key, required this.unit,
     // Required to update the correct document
  }) : super(key: key);

  @override
  _EditUnitScreenState createState() => _EditUnitScreenState();
}

class _EditUnitScreenState extends State<EditUnitScreen> {
  final _unitNameController = TextEditingController();
  final _unitNumberController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _unitNameController.text = widget.unit.unitName ?? '';
    _unitNumberController.text = widget.unit.unitNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: (){
              editUnits(_unitNameController, _unitNumberController, context, widget.unit.documentId);
            },
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }


}
