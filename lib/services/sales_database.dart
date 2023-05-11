import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/sales_person_model.dart';

class SalesPersonDatabase {

  final String uid;
  SalesPersonDatabase({ required this.uid});

  //collection reference 
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('SalesPersonsTable');

  Future<void> updateUserData(
    String uid,
    String name, 
    String education,
    String role, 
    String adhaarNumber, 
    String phoneNumber,
    String email, 
    String password, 
    String address1, 
    String address2, 
    String district,
    String state, 
    String pincode,
    ) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'education': education,
      'role': role,
      'adhaarNumber': adhaarNumber,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'address1': address1,
      'address2': address2,
      'city': district,
      'state': state,
      'pincode': pincode,
    });
  }

  List<SalesPersonModel?> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
        return SalesPersonModel(
          uid: (doc.data() as Map<String, dynamic>)['uid']?.toString() ?? '',
          name: (doc.data() as Map<String, dynamic>)['name']?.toString() ?? '',
          education: (doc.data() as Map<String, dynamic>)['education']?.toString() ?? '',
          role: (doc.data() as Map<String, dynamic>)['role']?.toString() ?? '',
          adhaarNumber: (doc.data() as Map<String, dynamic>)['adhaarNumber']?.toString() ?? '',
          phoneNumber: (doc.data() as Map<String, dynamic>)['phoneNumber']?.toString() ?? '',
          email: (doc.data() as Map<String, dynamic>)['email']?.toString() ?? '',
          password: (doc.data() as Map<String, dynamic>)['password']?.toString() ?? '',
          address1: (doc.data() as Map<String, dynamic>)['address1']?.toString() ?? '',
          address2: (doc.data() as Map<String, dynamic>)['address2']?.toString() ?? '',
          district: (doc.data() as Map<String, dynamic>)['district']?.toString() ?? '',
          state: (doc.data() as Map<String, dynamic>)['state']?.toString() ?? '',
          pincode: (doc.data() as Map<String, dynamic>)['pincode']?.toString() ?? '',
        );
      }).toList();
  }

  // get user table stream
  Stream<List<SalesPersonModel?>> get salesPersonTable {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}