import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/order_details_model.dart';

class OrderDetailsDatabaseService {
  final String? docid;
  OrderDetailsDatabaseService({required this.docid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('OrderDetailsTable');

  Future<void> setUserData(
    String salesExecutiveId,
    String customerId,
    String customerName,
    String shipmentID,
    String mobileNumber,
    String address1,
    String address2,
    String district,
    String state,
    String pincode,
    String deliveryDate,
    String dropdown,

  ) async {
    var uniqid = userCollection.doc().id;
    return await userCollection.doc(uniqid).set({
      'uid': uniqid,
      'salesExecutiveId': salesExecutiveId,
      'customerId': customerId,
      'customerName': customerName,
      'shipmentID': shipmentID,
      'mobileNumber': mobileNumber,
      'address1': address1,
      'address2': address2,
      'district': district,
      'state': state,
      'pincode': pincode,
      'deliveryDate': deliveryDate,
      'dropdown': dropdown,
    });
  }

  Future<void> updateUserData(
    String salesExecutiveId,
    String customerId,
    String customerName,
    String shipmentID,
    String mobileNumber,
    String address1,
    String address2,
    String district,
    String state,
    String pincode,
    String deliveryDate,
    String dropdown,
  ) async {
    return await userCollection.doc(docid).set({
      'uid': docid,
      'salesExecutiveId': salesExecutiveId,
      'customerId': customerId,
      'customerName': customerName,
      'shipmentID': shipmentID,
      'mobileNumber': mobileNumber,
      'address1': address1,
      'address2': address2,
      'district': district,
      'state': state,
      'pincode': pincode,
      'deliveryDate': deliveryDate,
      'dropdown': dropdown,
    });
  }

  Future<void> deleteUserData() async {
    return await userCollection.doc(docid).delete();
  }

  List<OrderDetailsModel> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return OrderDetailsModel(
        uid: (doc.data() as Map<String, dynamic>)['uid']?.toString() ?? '',
        salesExecutiveId:
            (doc.data() as Map<String, dynamic>)['salesExecutiveId']
                    ?.toString() ??
                '',
        customerId:
            (doc.data() as Map<String, dynamic>)['customerId']
                    ?.toString() ??
                '',
        customerName:
            (doc.data() as Map<String, dynamic>)['customerName']?.toString() ??
                '',
        shipmentID:
            (doc.data() as Map<String, dynamic>)['shipmentID']?.toString() ??
                '',
        mobileNumber:
            (doc.data() as Map<String, dynamic>)['mobileNumber']?.toString() ??
                '',
        address1:
            (doc.data() as Map<String, dynamic>)['address1']?.toString() ?? '',
        address2:
            (doc.data() as Map<String, dynamic>)['address2']?.toString() ?? '',
        district:
            (doc.data() as Map<String, dynamic>)['district']?.toString() ?? '',
        state: (doc.data() as Map<String, dynamic>)['state']?.toString() ?? '',
        pincode:
            (doc.data() as Map<String, dynamic>)['pincode']?.toString() ?? '',
        deliveryDate:
            (doc.data() as Map<String, dynamic>)['deliveryDate']?.toString() ??
                '',
        dropdown:
            (doc.data() as Map<String, dynamic>)['dropdown']?.toString() ?? '',
      );
    }).toList();
  }

  // get user table stream
  Stream<List<OrderDetailsModel>> get orderDetailsTable {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}
