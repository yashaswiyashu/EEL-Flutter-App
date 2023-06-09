import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/complaint_details_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/follow_up_model.dart';


class ComplaintDetailsDatabaseService {
  final String? docid;
  ComplaintDetailsDatabaseService({required this.docid});


  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('ComplaintDetailsTable');


  Future<void> setUserData(
    String uid,
    String customerName,
    String mobileNumber,
    String complaintDate,
    String complaintResult,
    //String complaintDetails,
    List<ComplaintDetail> details,
  ) async {
    var uniqid = userCollection.doc().id;
    return await userCollection.doc(uniqid).set({
      'uid': uniqid,
      'salesExecutiveId': uid,
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'complaintDate': complaintDate,
      'complaintResult': complaintResult,
      'complaintDetls': ConvertComplaintDetailstoMap(complaintList: details),
    });
  }


  Future<void> updateUserData(
    String uid,
    String customerName,
    String mobileNumber,
    String complaintDate,
    String complaintResult,
    List<ComplaintDetail> details,
  ) async {
    return await userCollection.doc(docid).set({
      'uid': docid,
      'salesExecutiveId': uid,
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'complaintDate': complaintDate,
      'complaintResult': complaintResult,
      'complaintDetls': ConvertComplaintDetailstoMap(complaintList: details),
    });
  }

  static List<Map> ConvertComplaintDetailstoMap({required List<ComplaintDetail> complaintList}) {
    List<Map> steps = [];
    complaintList.forEach((ComplaintDetail complaint) {
      Map step = complaint.toMap();
      steps.add(step);
    });
    return steps;
  }

  Future<void> deleteUserData() async {
    return await userCollection.doc(docid).delete();
  }


/*   List<ComplaintDetailsModel> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;

      List<ComplaintDetail> details = (data['complaintDetls'] as List<dynamic>).map<ComplaintDetail>((complaintMap) {
        return ComplaintDetail.fromMap(complaintMap as Map<String, dynamic>? ?? {});
      }).toList();
      
      return ComplaintDetailsModel(
        uid: (doc.data() as Map<String, dynamic>)['uid']?.toString() ?? '',
        salesExecutiveId:
            (doc.data() as Map<String, dynamic>)['salesExecutiveId']
                    ?.toString() ??
                '',
        customerName:
            (doc.data() as Map<String, dynamic>)['customerName']?.toString() ??
                '',
        mobileNumber:
            (doc.data() as Map<String, dynamic>)['mobileNumber']?.toString() ??
                '',
        complaintDate:
            (doc.data() as Map<String, dynamic>)['complaintDate']?.toString() ??
                '',
        complaintResult:
            (doc.data() as Map<String, dynamic>)['complaintResult']?.toString() ?? '',
        complaintDetls: details,
      );
    }).toList();
  }
 */

  List<ComplaintDetailsModel> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;

      List<ComplaintDetail> details = (data['complaintDetls'] as List<dynamic>? ?? [])
          .map<ComplaintDetail>((complaintMap) {
            return ComplaintDetail.fromMap(complaintMap as Map<String, dynamic>? ?? {});
          })
          .toList();
        
      return ComplaintDetailsModel(
        uid: data['uid']?.toString() ?? '',
        salesExecutiveId: data['salesExecutiveId']?.toString() ?? '',
        customerName: data['customerName']?.toString() ?? '',
        mobileNumber: data['mobileNumber']?.toString() ?? '',
        complaintDate: data['complaintDate']?.toString() ?? '',
        complaintResult: data['complaintResult']?.toString() ?? '',
        complaintDetls: details,
      );
    }).toList();
  }


  // get user table stream
  Stream<List<ComplaintDetailsModel>> get complaintDetailsTable {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}
