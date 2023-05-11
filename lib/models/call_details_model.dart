class CallDetailsModel {
  final String uid;
  final String salesExecutiveId;
  final String customerName;
  final String customerType;
  final String mobileNumber;
  final String callDate;
  final String callResult;
  final bool followUp;
  final String followUpdetails;


  CallDetailsModel({
    required this.uid,
    required this.salesExecutiveId,
    required this.customerName,
    required this.customerType,
    required this.mobileNumber,
    required this.callDate,
    required this.callResult,
    required this.followUp,
    required this.followUpdetails,
  });
}
