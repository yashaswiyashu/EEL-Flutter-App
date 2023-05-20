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
    String complaintDetails,
  ) async {
    var uniqid = userCollection.doc().id;
    return await userCollection.doc(uniqid).set({
      'uid': uniqid,
      'salesExecutiveId': uid,
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'complaintDate': complaintDate,
      'complaintResult': complaintResult,
      'complaintDetails': complaintDetails,
    });
  }


  Future<void> updateUserData(
    String uid,
    String customerName,
    String mobileNumber,
    String complaintDate,
    String complaintResult,
    String complaintDetails,
  ) async {
    return await userCollection.doc(docid).set({
      'uid': docid,
      'salesExecutiveId': uid,
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'complaintDate': complaintDate,
      'callResult': complaintResult,
      'complaintDetails': complaintDetails,
    });
  }


  Future<void> deleteUserData() async {
    return await userCollection.doc(docid).delete();
  }


  List<ComplaintDetailsModel> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
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
            (doc.data() as Map<String, dynamic>)['complaint']?.toString() ?? '',
        complaintDetails:
            (doc.data() as Map<String, dynamic>)['complaintDetails']
                    ?.toString() ??
                '',
      );
    }).toList();
  }


  // get user table stream
  Stream<List<ComplaintDetailsModel>> get complaintDetailsTable {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}
