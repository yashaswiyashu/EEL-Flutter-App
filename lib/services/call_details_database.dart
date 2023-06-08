import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/customer_model.dart';
//import 'package:flutter_app/models/follow_up_model.dart';

class CallDetailsDatabaseService {

  final String? docid;
  CallDetailsDatabaseService({ required this.docid});

  //collection reference 
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('CallDetailsTable');

  Future<void> setUserData(
   String uid,
   String customerName,
   String customerType,
   String mobileNumber,
   String callDate,
   String callResult,
   bool? followUp,
   //String followUpdetails,
   List<FollowUpDetail> details,

    ) async {
      var uniqid = userCollection.doc().id;
    return await userCollection.doc(uniqid).set({
      'uid': uniqid,
      'salesExecutiveId': uid,
      'customerName': customerName,
      'customerType': customerType,
      'mobileNumber': mobileNumber,
      'callDate': callDate,
      'callResult': callResult,
      'followUp': followUp,
      'followUpDetls': ConvertFollowUpDetailstoMap(followupList: details),
 
    });
  }

  Future<void> updateUserData(
   String uid,
   String customerName,
   String customerType,
   String mobileNumber,
   String callDate,
   String callResult,
   bool? followUp,
   List<FollowUpDetail> details,

    ) async {
    return await userCollection.doc(docid).set({
      'uid': docid,
      'salesExecutiveId': uid,
      'customerName': customerName,
      'customerType': customerType,
      'mobileNumber': mobileNumber,
      'callDate': callDate,
      'callResult': callResult,
      'followUp': followUp,
      'followUpDetls': ConvertFollowUpDetailstoMap(followupList: details),
    });
  }

  Future<void> deleteUserData(
    ) async {
    return await userCollection.doc(docid).delete();
  }

  Future<void> setFollowUpDetails(
   String date,
   String details,
   String callDetailsId,
    ) async {
      var uniqid = userCollection.doc().id;
    return await userCollection.doc(docid).collection('followUpDetails').doc(uniqid).set({
      'uid': uniqid,
      'date': date,
      'details': details,
      'callDetailsId': callDetailsId,
    });
  }

  Future<void> updateFollowUpDetails(
   String uid,
   String date,
   String details,
   String callDetailsId,
    ) async {
    return await userCollection.doc(docid).collection('followUpDetails').doc(uid).set({
      'uid': uid,
      'date': date,
      'details': details,
      'callDetailsId': callDetailsId,
    });
  }

  static List<Map> ConvertFollowUpDetailstoMap({required List<FollowUpDetail> followupList}) {
    List<Map> steps = [];
    followupList.forEach((FollowUpDetail followup) {
      Map step = followup.toMap();
      steps.add(step);
    });
    return steps;
  }


  Future<void> deleteFollowUpDetails(
    String uid,
    ) async {
    return await userCollection.doc(docid).collection('followUpDetails').doc(uid).delete();
  }

/*   List<CallDetailsModel> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;

      List<FollowUpDetail> details = (data['followUpDetls'] as List<dynamic>).map<FollowUpDetail>((followUpMap) {
        return FollowUpDetail.fromMap(followUpMap as Map<String, dynamic>? ?? {});
      }).toList();

      return CallDetailsModel(
        uid: (doc.data() as Map<String, dynamic>)['uid']?.toString() ?? '',
        salesExecutiveId: (doc.data() as Map<String, dynamic>)['salesExecutiveId']?.toString() ?? '',
        customerName: (doc.data() as Map<String, dynamic>)['customerName']?.toString() ?? '',
        customerType: (doc.data() as Map<String, dynamic>)['customerType']?.toString() ?? '',
        mobileNumber: (doc.data() as Map<String, dynamic>)['mobileNumber']?.toString() ?? '',
        callDate: (doc.data() as Map<String, dynamic>)['callDate']?.toString() ?? '',
        callResult: (doc.data() as Map<String, dynamic>)['callResult']?.toString() ?? '',
        followUp: (doc.data() as Map<String, dynamic>)['followUp'] as bool? ?? false,
        //followUpdetails: (doc.data() as Map<String, dynamic>)['followUpdetails']?.toString() ?? '',
        followUpDetls: details,
      );
    }).toList();
  } */

  List<CallDetailsModel> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;

      List<FollowUpDetail> details = [];

      if (data.containsKey('followUpDetls')) {
        details = (data['followUpDetls'] as List<dynamic>).map<FollowUpDetail>((followUpMap) {
          return FollowUpDetail.fromMap(followUpMap as Map<String, dynamic>);
        }).toList();
      }

      return CallDetailsModel(
        uid: data['uid']?.toString() ?? '',
        salesExecutiveId: data['salesExecutiveId']?.toString() ?? '',
        customerName: data['customerName']?.toString() ?? '',
        customerType: data['customerType']?.toString() ?? '',
        mobileNumber: data['mobileNumber']?.toString() ?? '',
        callDate: data['callDate']?.toString() ?? '',
        callResult: data['callResult']?.toString() ?? '',
        followUp: data['followUp'] as bool? ?? false,
        followUpDetls: details,
      );
    }).toList();
  }


  // get user table stream
  Stream<List<CallDetailsModel>> get callDetailsTable {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}