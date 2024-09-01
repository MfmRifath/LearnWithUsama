import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

 class Unit  {
  late final String? unitNumber;
  late final String? unitName;
  late final String? payment;
  late final String? unitImageUrl;
  late final String? overviewDescription;
  final String? documentId; // Document ID for Firestore operations

  Unit({this.overviewDescription, this.payment,
     this.unitNumber,
     this.unitName,
      this.documentId,
   this.unitImageUrl
  });


}
