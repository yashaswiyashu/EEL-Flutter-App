import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/order_details_model.dart';
import 'package:flutter_app/models/orders_product_model.dart';

class OrderDetailsDatabaseService {
  final String? docid;
  OrderDetailsDatabaseService({required this.docid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('OrderDetailsTable');

  Future<String> setOrderData(
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
    String subTotal,
    String totalAmount,

  ) async {
    var uniqid = userCollection.doc().id;
    await userCollection.doc(uniqid).set({
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
      'subTotal': subTotal,
      'totalAmount': totalAmount,
    });
    return uniqid;
  }

  Future<void> updateOrderData(
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
    String subTotal,
    String totalAmount,
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
      'subTotal': subTotal,
      'totalAmount': totalAmount,
    });
  }

  Future<void> deleteUserData() async {
    return await userCollection.doc(docid).delete();
  }

  Future<void> setOrderedProductDetails(
   String productName,
   String quantity,
   String amount,
    ) async {
      var uniqid = userCollection.doc().id;
    return await userCollection.doc(docid).collection('OrdersProductDetails').doc(uniqid).set({
      'uid': uniqid,
      'productName': productName,
      'quantity': quantity,
      'amount': amount,
    });
  }

  Future<void> updateOrderedProductDetails(
   String uid,
   String productName,
   String quantity,
   String amount,
    ) async {
    return await userCollection.doc(docid).collection('OrdersProductDetails').doc(uid).set({
      'uid': uid,
      'productName': productName,
      'quantity': quantity,
      'amount': amount,
    });
  }

  Future<void> deleteOrderedProductDetails(
    String uid,
    ) async {
    return await userCollection.doc(docid).collection('OrdersProductDetails').doc(uid).delete();
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
        subTotal:
            (doc.data() as Map<String, dynamic>)['subTotal']?.toString() ?? '',
        totalAmount:
            (doc.data() as Map<String, dynamic>)['totalAmount']?.toString() ?? '',
      );
    }).toList();
  }

  // get user table stream
  Stream<List<OrderDetailsModel>> get orderDetailsTable {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  // get all documents in OrdersTable collection and get a list of documents in sub collection OrderedProducts table and it stream
  Stream<List<OrdersProductModel>> get orderedProductDetailsTable {
    return userCollection.snapshots().asyncMap((QuerySnapshot snapshot) async {
      final List<OrdersProductModel> productList = [];

      for (final DocumentSnapshot doc in snapshot.docs) {
        final Map<String, dynamic> documentData = doc.data() as Map<String, dynamic>;

        // Fetch subcollection data
        final QuerySnapshot subCollectionSnapshot =
            await doc.reference.collection('OrdersProductDetails').get();

        for (final DocumentSnapshot subDoc in subCollectionSnapshot.docs) {
          final Map<String, dynamic> subDocumentData = subDoc.data() as Map<String, dynamic>;

          productList.add(
            OrdersProductModel(
              uid: documentData['uid']?.toString() ?? '',
              amount: documentData['amount']?.toString() ?? '',
              productName: documentData['productName']?.toString() ?? '',
              quantity: documentData['quantity']?.toString() ?? '',
            ),
          );
        }
      }

      return productList;
    });
  }
}
