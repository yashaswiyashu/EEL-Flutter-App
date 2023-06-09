class ComplaintDetail {
  final String updateDate;
  final String details;  

  Map<String, dynamic> toMap() {
    return {
      'updateDate': updateDate,
      'details': details,
    };
  }


  ComplaintDetail({required this.updateDate, required this.details});

  factory ComplaintDetail.fromMap(Map<String, dynamic> map) {
    return ComplaintDetail(
      updateDate: map['updateDate']?.toString() ?? '',
      details: map['details']?.toString() ?? '',
    );
  }
}
class ComplaintDetailsModel {
  final String uid;
  final String salesExecutiveId;
  final String customerName;
  final String mobileNumber;
  final String complaintDate;
  final String complaintResult;
  //final String complaintDetails;
  final List<ComplaintDetail> complaintDetls;


  ComplaintDetailsModel({
    required this.uid,
    required this.salesExecutiveId,
    required this.customerName,
    required this.mobileNumber,
    required this.complaintDate,
    required this.complaintResult,
    //required this.complaintDetails,
    required this.complaintDetls,
  });
}
