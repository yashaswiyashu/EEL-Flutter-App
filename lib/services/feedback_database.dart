
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/feedback_details_mode.dart';
import 'package:flutter_app/models/follow_up_model.dart';


class FeedBackDatabaseService {
  final String? docid;
  FeedBackDatabaseService({required this.docid});


  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('FeedBackDetailsTable');


  Future<void> setUserData(
    String execID,
    String customerName,
    String mobileNumber,
    String feedbackDate,
    String feedbackDetails,
  ) async {
    var uniqid = userCollection.doc().id;
    return await userCollection.doc(uniqid).set({
      'uid': uniqid,
      'salesExecutiveId': execID,
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'feedbackDate': feedbackDate,
      'feedbackDetails': feedbackDetails,
    });
  }


  Future<void> updateUserData(
    String uid,
    String customerName,
    String mobileNumber,
    String feedbackDate,
    String feedbackDetails,
  ) async {
    return await userCollection.doc(docid).set({
      'uid': docid,
      'salesExecutiveId': uid,
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'feedbackDate': feedbackDate,
      'feedbackDetails': feedbackDetails,
    });
  }


  Future<void> deleteUserData() async {
    return await userCollection.doc(docid).delete();
  }


  List<FeedbackDetailsModel> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return FeedbackDetailsModel(
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
        feedbackDate:
            (doc.data() as Map<String, dynamic>)['feedbackDate']?.toString() ??
                '',
        feedbackDetails: (doc.data() as Map<String, dynamic>)['feedbackDetails']
                ?.toString() ??
            '',
      );
    }).toList();
  }


  // get user table stream
  Stream<List<FeedbackDetailsModel>> get feedbackDetailsTable {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}
