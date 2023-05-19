import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/product_details_model.dart';

class ProductRepository {
  static final ProductRepository _instance = ProductRepository._internal();
  factory ProductRepository() => _instance;

  List<ProductDetailsModel> productDocuments = [];

  ProductRepository._internal();

  Future<List<ProductDetailsModel>> fetchProductDocuments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();

      List<ProductDetailsModel> productDocuments = querySnapshot.docs.map((DocumentSnapshot doc) {
      return ProductDetailsModel(
        uid: (doc.data() as Map<String, dynamic>)['uid']?.toString() ?? '',
        name: (doc.data() as Map<String, dynamic>)['name']?.toString() ?? '',
        imageUrl: (doc.data() as Map<String, dynamic>)['imageUrl']?.toString() ?? '',
        price: (doc.data() as Map<String, dynamic>)['price']?.toString() ?? '',
        offers: (doc.data() as Map<String, dynamic>)['offers']?.toString() ?? '',
        description: (doc.data() as Map<String, dynamic>)['description']?.toString() ?? '',
      );
    }).toList();
    return productDocuments;
    } catch (error) {
      print('Error fetching product documents: $error');
      return [];
    }
  }
}