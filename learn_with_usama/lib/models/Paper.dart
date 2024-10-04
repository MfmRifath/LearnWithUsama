

class Paper  {
  late final String? paperId;
  late final String? paperName;
  late final String? paperImageUrl;
  late final String? year;
  late final String? payment;
  late final String? overviewDescription;
  final String? documentId; // Document ID for Firestore operations
  final List<String>? userId; // Ensure this is a list of dynamic values
  final List<String>? paymentId;
  final DateTime? paymentDate;
  final String? paymentStatus;


  Paper({this.paymentStatus, this.userId, this.paymentId, this.paymentDate, this.overviewDescription, this.payment,
    this.paperName,
    this.paperId,
    this.documentId,
    this.year,
    this.paperImageUrl
  });


}
