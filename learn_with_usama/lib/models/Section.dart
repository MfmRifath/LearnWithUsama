import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:learn_with_usama/models/Unit.dart';
import 'package:learn_with_usama/screens/UnitsWidget.dart';

import 'Courses.dart';

class Section  {
  late final String? sectionId;
  late final String? sectionUrl;
  late final String? sectionName;
  late final String? sectionDuration;
  late final String? courseId;
  final String? sectionDoc;

  Section({this.sectionDoc, required this.courseId,
    required this.sectionId,
    required this.sectionUrl,
    required this.sectionName,
    required this.sectionDuration,
  });


}