class Unit {
 final String? unitNumber;
 final String? unitName;
 final String? payment;
 final String? paymentStatus;
 final String? unitImageUrl;
 final String? overviewDescription;
 final List<String>? userId; // Ensure this is a list of dynamic values
 final String? documentId;
 final List<String>? paymentId;
 final DateTime? paymentDate;

 Unit({this.paymentDate,
  this.unitNumber,
  this.unitName,
  this.payment,
  this.paymentStatus,
  this.unitImageUrl,
  this.overviewDescription,
  this.documentId,
  this.userId,
  this.paymentId// Required field must be initialized in constructor
 });
}
