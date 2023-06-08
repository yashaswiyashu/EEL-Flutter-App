import 'package:flutter/material.dart';
import 'package:flutter_app/models/orders_product_model.dart';
import 'package:flutter_app/services/firebase_storage.dart';

class OrderedProductsTile extends StatelessWidget {
  // UserList({super.key});
  final OrdersProductModel? product;
  final String imageUrls;
  const OrderedProductsTile({super.key ,required this.product, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    final StorageService storage = StorageService(); 

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            child: FutureBuilder(
              future: storage.downloadURL(imageUrls),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData){
                  return CircularProgressIndicator();
                }

                if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                  return Image.network(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  );
                } 

                return Container();
              },
            ),
          ),
          title: Text(product!.quantity),
          subtitle: Text('Total Amount(in Rs.): ${product!.amount}'),
        ),
      ),
    );
  }
}
