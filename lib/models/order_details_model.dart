import 'package:flutter_app/models/orders_product_model.dart';

class OrderDetailsModel {
  final String uid;
  final String salesExecutiveId;
  final String customerId;
  final String customerName;
  final String shipmentID;
  final String mobileNumber;
  final String address1;
  final String address2;
  final String district;
  final String state;
  final String pincode;
  final String deliveryDate;
  final String dropdown;
  final String subTotal;
  final String totalAmount;
  final String orderedDate;
  final List<OrdersProductModel> products;


  OrderDetailsModel({
    required this.uid,
    required this.salesExecutiveId,
    required this.customerId,
    required this.customerName,
    required this.shipmentID,
    required this.mobileNumber,
    required this.address1,
    required this.address2,
    required this.district,
    required this.state,
    required this.pincode,
    required this.deliveryDate,
    required this.dropdown,
    required this.subTotal,
    required this.totalAmount,
    required this.orderedDate,
    required this.products,
  });
}
