

class PaperSection  {
  late final String? sectionId;
  late final String? sectionUrl;
  late final String? sectionName;
  late final String? sectionDuration;
  late final String? courseId;
  late final String? paperId;
  final String? sectionDoc;

  PaperSection({this.sectionDoc, required this.courseId,
    required this.sectionId,
    required this.sectionUrl,
    required this.sectionName,
    required this.sectionDuration,
    required this.paperId
  });


}