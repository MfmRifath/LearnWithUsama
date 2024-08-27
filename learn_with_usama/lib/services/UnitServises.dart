import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/models/Unit.dart';

final _firestore = FirebaseFirestore.instance;

Future<void> addUnit(TextEditingController _unitNameController ,
TextEditingController _unitNumberController,bool _isSubmitting,
String? _error, String docId , TextEditingController _paymentController, TextEditingController _overviewDescriptionController) async {
     _isSubmitting = true;
    _error = null;

  final unitName = _unitNameController.text.trim();
  final unitNumber = _unitNumberController.text.trim();
  final updatedPayment = _paymentController.text.trim();
  final updatedOverviewDescription = _overviewDescriptionController.text.trim();

  if (unitName.isEmpty || unitNumber.isEmpty || updatedPayment.isEmpty || updatedOverviewDescription.isEmpty) {
      _isSubmitting = false;
      _error = 'Both fields are required.';
    return;
  }

  try {
    final addedUnit = Unit(unitNumber: unitNumber, unitName: unitName, documentId: docId,payment: updatedPayment,overviewDescription: updatedOverviewDescription);
    await _firestore.collection('units').add(addedUnit.toMap());

     // Close the dialog
  } catch (e) {

      _error = 'An error occurred: $e';
  } finally {

      _isSubmitting = false;
  }
}
void editUnits(TextEditingController _unitNameController,TextEditingController _unitNumberController,BuildContext context,String documentId, TextEditingController _paymentController, TextEditingController _overviewDescriptionController) async {
  // Get the updated values from the controllers
  final updatedUnitName = _unitNameController.text;
  final updatedUnitNumber = _unitNumberController.text;
  final updatedPayment = _paymentController.text;
  final updatedOverviewDescription = _overviewDescriptionController.text;

  // Get a reference to the Firestore document
  final updatedUnit = Unit(unitNumber: updatedUnitNumber, unitName: updatedUnitName, documentId: documentId,payment: updatedPayment,overviewDescription: updatedOverviewDescription);


  final unitRef = _firestore.collection('units').doc(documentId);

  try {
    // Update the document with the new values
    await unitRef.update(updatedUnit.toMap());

    Navigator.of(context).pop(); // Close the dialog after saving
  } catch (e) {
    // Handle errors here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating unit: $e')),
    );
  }
}

