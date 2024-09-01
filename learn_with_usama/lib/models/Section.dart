

class Section  {
  late final String? sectionId;
  late final String? sectionUrl;
  late final String? sectionName;
  late final String? sectionDuration;
  late final String? courseId;
  late final String? unitId;
  final String? sectionDoc;

  Section({this.sectionDoc, required this.courseId,
    required this.sectionId,
    required this.sectionUrl,
    required this.sectionName,
    required this.sectionDuration,
    required this.unitId
  });


}