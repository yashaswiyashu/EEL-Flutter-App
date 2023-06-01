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
    String orderedDate,
    List<OrdersProductModel> products,

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
      'orderedDate': orderedDate,
      'products': ConvertProductModeltoMap(productList: products),

      // 'products': products.map((element) {
      //   OrderDetailsDatabaseService(docid: uniqid).setOrderedProductDetails(uniqid, element.productName, element.quantity, element.amount);
      // }),
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
    String orderedDate,
    List<OrdersProductModel> products,
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
      'orderedDate': orderedDate,
      'products': ConvertProductModeltoMap(productList: products),
    });
  }

  Future<void> deleteUserData() async {
    return await userCollection.doc(docid).delete();
  }

  static List<Map> ConvertProductModeltoMap({required List<OrdersProductModel> productList}) {
    List<Map> steps = [];
    productList.forEach((OrdersProductModel product) {
      Map step = product.toMap();
      steps.add(step);
    });
    return steps;
  }

  Future<void> setOrderedProductDetails(
   String orderId,
   String productName,
   String quantity,
   String amount,
    ) async {
      var uniqid = userCollection.doc().id;
    return await userCollection.doc(docid).collection('OrdersProductDetails').doc(uniqid).set({
      'uid': uniqid,
      'orderId': orderId,
      'productName': productName,
      'quantity': quantity,
      'amount': amount,
    });
  }

  Future<void> updateOrderedProductDetails(
   String uid,
   String orderId,
   String productName,
   String quantity,
   String amount,
    ) async {
    return await userCollection.doc(docid).collection('OrdersProductDetails').doc(uid).set({
      'uid': uid,
      'orderId': orderId,
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
    final data = doc.data() as Map<String, dynamic>;

    List<OrdersProductModel> orderedProducts = (data['products'] as List<dynamic>).map<OrdersProductModel>((productMap) {
      return OrdersProductModel.fromMap(productMap);
    }).toList();

    return OrderDetailsModel(
      uid: data['uid']?.toString() ?? '',
      salesExecutiveId: data['salesExecutiveId']?.toString() ?? '',
      customerId: data['customerId']?.toString() ?? '',
      customerName: data['customerName']?.toString() ?? '',
      shipmentID: data['shipmentID']?.toString() ?? '',
      mobileNumber: data['mobileNumber']?.toString() ?? '',
      address1: data['address1']?.toString() ?? '',
      address2: data['address2']?.toString() ?? '',
      district: data['district']?.toString() ?? '',
      state: data['state']?.toString() ?? '',
      pincode: data['pincode']?.toString() ?? '',
      deliveryDate: data['deliveryDate']?.toString() ?? '',
      dropdown: data['dropdown']?.toString() ?? '',
      subTotal: data['subTotal']?.toString() ?? '',
      totalAmount: data['totalAmount']?.toString() ?? '',
      orderedDate: data['orderedDate']?.toString() ?? '',
      products: orderedProducts,
    );
  }).toList();
}

  // get user table stream
  Stream<List<OrderDetailsModel>> get orderDetailsTable {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

//   Stream<List<OrdersProductModel>> get orderedProductDetailsTable {
//   return userCollection.snapshots().asyncMap((QuerySnapshot snapshot) async {
//     final List<OrdersProductModel> productList = [];

//     for (final DocumentSnapshot doc in snapshot.docs) {
//       final Map<String, dynamic> documentData = doc.data() as Map<String, dynamic>;

//       // Fetch subcollection data
//       final QuerySnapshot subCollectionSnapshot =
//           await doc.reference.collection('OrdersProductDetails').get();

//       for (final DocumentSnapshot subDoc in subCollectionSnapshot.docs) {
//         final Map<String, dynamic> subDocumentData = subDoc.data() as Map<String, dynamic>;

//         productList.add(
//           OrdersProductModel(
//             uid: subDocumentData['uid']?.toString() ?? '',
//             amount: subDocumentData['amount']?.toString() ?? '',
//             productName: subDocumentData['productName']?.toString() ?? '',
//             quantity: subDocumentData['quantity']?.toString() ?? '',
//           ),
//         );
//       }
//     }

//     return productList;
//   });
// }
}
