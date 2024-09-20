

class Paper  {
  late final String? paperId;
  late final String? paperName;
  late final String? paperImageUrl;
  late final String? year;
  late final String? payment;
  late final String? overviewDescription;
  final String? documentId; // Document ID for Firestore operations

  Paper({this.overviewDescription, this.payment,
    this.paperName,
    this.paperId,
    this.documentId,
    this.year,
    this.paperImageUrl
  });


}
