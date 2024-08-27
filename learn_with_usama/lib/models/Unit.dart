import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

 class Unit  {
  final String? unitNumber;
  final String? unitName;
  final String? payment;
  final String? overviewDescription;
  final String documentId; // Document ID for Firestore operations

  Unit({this.overviewDescription, this.payment,
    required this.unitNumber,
    required this.unitName,
     required this.documentId,
  });

  // Factory method to create a Unit from Firestore document data
  factory Unit.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Unit(
      unitNumber: data['unitNumber'] as String?,
      unitName: data['unitName'] as String?,
      payment: data['payment'] as String?,
      overviewDescription: data['overviewDescription'] as String?,
      documentId: doc.id,
    );
  }

  // Method to convert a Unit to Firestore document data
  Map<String, dynamic> toMap() {
    return {
      'unitNumber': unitNumber,
      'unitName': unitName,
      'payment' : payment,
      'overviewDescription' : overviewDescription
    };
  }

  // Method to update the unit in Firestore
  Future<void> update() {
    final unitRef = FirebaseFirestore.instance.collection('units').doc(documentId);
    return unitRef.update(toMap());
  }

  // Static method to delete a unit from Firestore
  static Future<void> delete(String documentId) {
    final unitRef = FirebaseFirestore.instance.collection('units').doc(documentId);
    return unitRef.delete();
  }


}
