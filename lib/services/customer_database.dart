import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/customer_model.dart';

class CustomerDatabaseService {

  final String docid;
  CustomerDatabaseService({ required this.docid});

  //collection reference 
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('CustomerTable');

  Future<void> setUserData(
    String uid,
    String salesExecutiveId,
    String customerName, 
    String mobileNumber, 
    String email, 
    String password, 
    String address1, 
    String address2, 
    String city, 
    String state, 
    String pincode,
    String product1,
    String product2,
    String product3,
    String product4,
    String place1,
    String place2,
    String place3,
    String place4,
    ) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'salesExecutiveId': salesExecutiveId,
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'email': email,
      'password': password,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'product1': product1,
      'product2': product2,
      'product3': product3,
      'product4': product4,
      'place1': place1,
      'place2': place2,
      'place3': place3,
      'place4': place4,
    });
  }
  
  Future<void> updateUserData(
    String salesExecutiveId,
    String customerName, 
    String mobileNumber, 
    String email, 
    String password, 
    String address1, 
    String address2, 
    String city, 
    String state, 
    String pincode,
    String product1,
    String product2,
    String product3,
    String product4,
    String place1,
    String place2,
    String place3,
    String place4,
    ) async {
    return await userCollection.doc(docid).set({
      'uid': docid,
      'salesExecutiveId': salesExecutiveId,
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'email': email,
      'password': password,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'product1': product1,
      'product2': product2,
      'product3': product3,
      'product4': product4,
      'place1': place1,
      'place2': place2,
      'place3': place3,
      'place4': place4,
    });
  }

  Future<void> deleteUserData(
    ) async {
    return await userCollection.doc(docid).delete();
  }

  List<CustomerModel?> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
        return CustomerModel(
          uid: (doc.data() as Map<String, dynamic>)['uid']?.toString() ?? '',
          salesExecutiveId: (doc.data() as Map<String, dynamic>)['salesExecutiveId']?.toString() ?? '',
          customerName: (doc.data() as Map<String, dynamic>)['customerName']?.toString() ?? '',
          mobileNumber: (doc.data() as Map<String, dynamic>)['mobileNumber']?.toString() ?? '',
          email: (doc.data() as Map<String, dynamic>)['email']?.toString() ?? '',
          password: (doc.data() as Map<String, dynamic>)['password']?.toString() ?? '',
          address1: (doc.data() as Map<String, dynamic>)['address1']?.toString() ?? '',
          address2: (doc.data() as Map<String, dynamic>)['address2']?.toString() ?? '',
          city: (doc.data() as Map<String, dynamic>)['city']?.toString() ?? '',
          state: (doc.data() as Map<String, dynamic>)['state']?.toString() ?? '',
          pincode: (doc.data() as Map<String, dynamic>)['pincode']?.toString() ?? '',
          product1: (doc.data() as Map<String, dynamic>)['product1']?.toString() ?? '',
          product2: (doc.data() as Map<String, dynamic>)['product2']?.toString() ?? '',
          product3: (doc.data() as Map<String, dynamic>)['product3']?.toString() ?? '',
          product4: (doc.data() as Map<String, dynamic>)['product4']?.toString() ?? '',
          place1: (doc.data() as Map<String, dynamic>)['place1']?.toString() ?? '',
          place2: (doc.data() as Map<String, dynamic>)['place2']?.toString() ?? '',
          place3: (doc.data() as Map<String, dynamic>)['place3']?.toString() ?? '',
          place4: (doc.data() as Map<String, dynamic>)['place4']?.toString() ?? '',
        );
      }).toList();
  }

  // get user table stream
  Stream<List<CustomerModel?>> get customerTable {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}