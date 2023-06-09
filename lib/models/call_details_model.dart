class FollowUpDetail {
  final String followUpDate;
  final String details;  

  Map<String, dynamic> toMap() {
    return {
      'followUpDate': followUpDate,
      'details': details,
    };
  }


  FollowUpDetail({required this.followUpDate, required this.details});

  factory FollowUpDetail.fromMap(Map<String, dynamic> map) {
    return FollowUpDetail(
      followUpDate: map['followUpDate']?.toString() ?? '',
      details: map['details']?.toString() ?? '',
    );
  }
}
class CallDetailsModel {
  final String uid;
  final String salesExecutiveId;
  final String customerName;
  final String customerType;
  final String mobileNumber;
  final String callDate;
  final String callResult;
  final bool followUp;
  //final String followUpdetails;
  final List<FollowUpDetail> followUpDetls;
  

  CallDetailsModel({
    required this.uid,
    required this.salesExecutiveId,
    required this.customerName,
    required this.customerType,
    required this.mobileNumber,
    required this.callDate,
    required this.callResult,
    required this.followUp,
    //required this.followUpdetails,
    required this.followUpDetls,    
  });
}
