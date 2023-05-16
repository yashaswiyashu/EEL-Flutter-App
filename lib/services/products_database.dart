import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/follow_up_model.dart';
import 'package:flutter_app/models/product_details_model.dart';

class ProductDatabaseService {

  final String? docid;
  ProductDatabaseService({ required this.docid});

  //collection reference 
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('ProductDetailsTable');

  Future<void> setUserData(
   String uid,
   String name,
   String imageUrl,
   String price,
   String offers,
   String description,

    ) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'offers': offers,
      'description': description,
 
    });
  }

  Future<void> updateUserData(
   String name,
   String imageUrl,
   String price,
   String offers,
   String description,

    ) async {
    return await userCollection.doc(docid).set({
      'uid': docid,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'offers': offers,
      'description': description,
    });
  }

  Future<void> deleteUserData(
    ) async {
    return await userCollection.doc(docid).delete();
  }


  List<ProductDetailsModel> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return ProductDetailsModel(
        uid: (doc.data() as Map<String, dynamic>)['uid']?.toString() ?? '',
        name: (doc.data() as Map<String, dynamic>)['name']?.toString() ?? '',
        imageUrl: (doc.data() as Map<String, dynamic>)['imageUrl']?.toString() ?? '',
        price: (doc.data() as Map<String, dynamic>)['price']?.toString() ?? '',
        offers: (doc.data() as Map<String, dynamic>)['offers']?.toString() ?? '',
        description: (doc.data() as Map<String, dynamic>)['description']?.toString() ?? '',
      );
    }).toList();
  }

  // get user table stream
  Stream<List<ProductDetailsModel>> get callDetailsTable {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}