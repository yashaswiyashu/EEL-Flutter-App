import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/order_details_model.dart';
import 'package:flutter_app/models/orders_product_model.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/admin/products/view_product_details.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/screens/common/utility_functions.dart';
import 'package:flutter_app/screens/customer/complaints/customer_complaints_list.dart';
import 'package:flutter_app/screens/customer/feedback/add_new_feedback.dart';
import 'package:flutter_app/screens/customer/feedback/customer_feedback_list.dart';
import 'package:flutter_app/screens/sales%20Executive/complaints/add_new_complaints.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/add_order_details.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/firebase_storage.dart';
import 'package:provider/provider.dart';


class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});


  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}


class _CustomerHomeState extends State<CustomerHome> {
  final AuthService _auth = AuthService();

  String execId = '';

  @override
  Widget build(BuildContext context) {
    final StorageService storage = StorageService();
    final productDetails = Provider.of<List<ProductDetailsModel>>(context);
    final orderDetails = Provider.of<List<OrderDetailsModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);
    orderDetails.forEach((element) {
      if(element.customerId == currentUser?.uid) {
        execId = element.salesExecutiveId;
      }
    });
    OrderDetailsModel obj = OrderDetailsModel(
        uid: '',
        salesExecutiveId: '',
        customerId: '',
        customerName: '',
        shipmentID: '',
        mobileNumber: '',
        address1: '',
        address2: '',
        district: '',
        state: '',
        pincode: '',
        deliveryDate: '',
        dropdown: '',
        subTotal: '',
        totalAmount: '',
        orderedDate: '',
        products: []);


    orderDetails.forEach((element) {
      if (element.customerId == currentUser?.uid) {
        obj = element;
      }
    });
    var pendingOrders = getTotalPendingOrders(currentUser!.uid, orderDetails);
    var totalOrders = getTotalOrders(currentUser.uid, orderDetails);

    var tileHeight = 100 * productDetails.length;


    Widget showProducts(List<OrdersProductModel?> productList) {
      List<ProductDetailsModel> products = [];
      productDetails.forEach((element) {
        productList.forEach((e) {
          if (e?.productName == element.name) {
            products.add(element);
          }
        });
      });


      products.map((e) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: FutureBuilder(
                future: storage.downloadURL(e.imageUrl),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return CircularProgressIndicator();
                  }


                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Image.network(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    );
                  }


                  return Container();
                },
              ),
            ),
            SizedBox(
              width: 86,
              height: 16,
              child: Text(
                e.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      });
      return Container();
    }


    //return home or auth widget
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Energy Efficient Lights', style: TextStyle(fontSize: screenHeight / 50)),
            backgroundColor: const Color(0xff4d47c3),
            actions: [
              TextButton.icon(
                  onPressed: () async {
                    await _auth.signout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        'authWrapper', (Route<dynamic> route) => false);
                  },
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: screenHeight / 50,
                  ),
                  label: Text(
                    'logout',
                    style: TextStyle(color: Colors.white, fontSize: screenWidth / 35),
                  )),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              width: screenWidth,
              height: screenHeight,
              color: Colors.white,
              padding: const EdgeInsets.only(
                top: 21,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth / 3,
                    height: screenHeight / 10,
                    child: Image.asset('assets/logotm.jpg'),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'presentCustomerOrdersList');
                  },
                  child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth / 1.5,
                          height: screenHeight / 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x664d47c3),
                                blurRadius: 61,
                                offset: Offset(0, 4),
                              ),
                            ],
                            color: Color(0xff4d47c3),
                          ),
                          padding: const EdgeInsets.only(
                            top: 9,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                              fit: FlexFit.loose,
                              child: Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 4), // Add padding below the underline
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.white, // Set the underline color
                                            width: 2, // Set the underline thickness
                                          ),
                                        ),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenHeight / 50,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Present Orders:",
                                              style: TextStyle(
                                                decoration: TextDecoration.none,

                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      "Total Pending Orders: $pendingOrders",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenHeight / 60,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),


                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                  SizedBox(height: 20),
                  Container(
                    width: screenWidth / 1.5,
                    height: screenHeight / 4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth / 1.5,
                          height: double.parse(tileHeight.toString()),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x664d47c3),
                                blurRadius: 61,
                                offset: Offset(0, 4),
                              ),
                            ],
                            color: Color(0xff4d47c3),
                          ),
                          child: ListView.builder(itemCount: productDetails.length, itemBuilder: (context, index) {
                      if(productDetails.length != null) {
                        return TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                    context, ViewProductAdmin.routeName,
                                    arguments: Parameter(
                                      productDetails[index].uid,
                                    ));
                          },
                          child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Card(
                            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 10.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 40.0,
                                backgroundColor: Colors.white,
                                child: FutureBuilder(
                                            future: storage.downloadURL(productDetails[index].imageUrl),
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
                              title: Text('Price(in Rs.): \n ${productDetails[index].price}', style: TextStyle(fontSize: screenHeight / 50),),
                              subtitle: Text('Offer : ${productDetails[index].offers}% \n Delivered In: ${productDetails[index].numOfDays} Days', style: TextStyle(fontSize: screenHeight / 50),),
                            ),
                          ),
                                              ),
                        );
                      }
                    }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                 TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'pastCustomerOrdersList');
                  },
                  child: Container(
                    width: screenWidth / 1.5,
                    height: screenHeight / 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth / 1.5,
                          height: screenHeight / 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x664d47c3),
                                blurRadius: 61,
                                offset: Offset(0, 4),
                              ),
                            ],
                            color: Color(0xff4d47c3),
                          ),
                          padding: const EdgeInsets.only(
                            top: 9,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                              fit: FlexFit.loose,
                              child: Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(bottom: 4), // Add padding below the underline
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.white, // Set the underline color
                                            width: 2, // Set the underline thickness
                                          ),
                                        ),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenHeight / 50,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Past Orders:",
                                              style: TextStyle(
                                                decoration: TextDecoration.none,

                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      "Total Past Orders: $totalOrders",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenHeight / 60,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),


                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                  SizedBox(height: 20.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: screenWidth,
                        height: screenHeight / 10,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // width: screenWidth / 4,
                              // height: screenHeight / 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x664d47c3),
                                    blurRadius: 61,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                color: Color(0xff4d47c3),
                              ),
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 17,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, 
                                      CustomerComplaintDetailsList.routeName,
                                      arguments: Parameter(
                                        execId,
                                      )
                                    );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: screenWidth / 5,
                                      child: Text(
                                        "Complaint",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenHeight / 55,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 7),
                            Container(
                              // width: 106,
                              // height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x664d47c3),
                                    blurRadius: 61,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                color: Color(0xff4d47c3),
                              ),
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 17,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, 
                                      CustomerFeedbackList.routeName,
                                      arguments: Parameter(
                                        execId,
                                      )
                                    );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: screenWidth / 5,
                                      // height: 25,
                                      child: Text(
                                        "Feedback",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenHeight / 55,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 7),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x664d47c3),
                                    blurRadius: 61,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                color: Color(0xff4d47c3),
                              ),
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 17,
                              ),
                              child: TextButton(
                                onPressed: (){
                                  Navigator.pushNamed(
                                      context, 
                                      AddNewOrder.routeName,
                                      arguments: Parameter(
                                        execId,
                                      )
                                    );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: screenWidth / 5,
                                      child: Text(
                                        "New Order",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenHeight / 55,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          )),
    );
  }
}
