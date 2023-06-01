class OrdersProductModel{
  final String uid;
  final String productName;
  final String quantity;
  final String amount;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'productName': productName,
      'quantity': quantity,
      'amount': amount,
    };
  }

  OrdersProductModel({
    required this.uid,
    required this.productName,
    required this.quantity,
    required this.amount,
  });

  factory OrdersProductModel.fromMap(Map<String, dynamic> map) {
    return OrdersProductModel(
      productName: map['productName']?.toString() ?? '',
      uid: map['uid']?.toString() ?? '',
      quantity: map['quantity']?.toString() ?? '',
      amount: map['amount']?.toString() ?? '',
    );
  }

}