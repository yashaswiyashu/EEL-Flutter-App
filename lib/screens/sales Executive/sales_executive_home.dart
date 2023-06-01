import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
<<<<<<< HEAD
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/complaint_details_model.dart';
=======
>>>>>>> 537bd16977ea968044814b58dc0c53d05a1251a9
import 'package:flutter_app/models/order_details_model.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/utility_functions.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/add_order_details.dart';
// import 'package:flutter_app/screens/salesPerson/executive/call_details.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:provider/provider.dart';

import '../../models/call_details_model.dart';
import '../../models/complaint_details_model.dart';

class SalesExecutiveHome extends StatefulWidget {
  const SalesExecutiveHome({super.key});

  @override
  State<SalesExecutiveHome> createState() => _SalesExecutiveHomeState();
}

class _SalesExecutiveHomeState extends State<SalesExecutiveHome> {
  final AuthService _auth = AuthService();
  var salesExecutive;
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    final currentUser = Provider.of<UserModel?>(context);
    final salesTable = Provider.of<List<SalesPersonModel?>?>(context);
    final productDetails = Provider.of<List<ProductDetailsModel>>(context);
    final callDetailsList = Provider.of<List<CallDetailsModel>>(context);
    var callDetails = [];
    final complaintDetailsList = Provider.of<List<ComplaintDetailsModel>>(context);
    var complaintDetails = [];
    final orderDetailsList = Provider.of<List<OrderDetailsModel>>(context);
    var orderDetails = [];
<<<<<<< HEAD
=======

>>>>>>> 537bd16977ea968044814b58dc0c53d05a1251a9

    if (salesTable != null) {
      salesTable.forEach((element) {
        if (element?.uid == currentUser?.uid) {
          salesExecutive = element;
        }
      });
    }

    callDetailsList.forEach((e) => e.salesExecutiveId == currentUser?.uid ? callDetails.add(e) : []);
    CallDetailDashBoard cdb = getCallsCountConvertedThisMonth(callDetails);
    //String cdbText = "Call Details:\n Calls Made This Month: $cdb.callsCount \nCalls Coverted: $cdb.callsConverted";

    complaintDetailsList.forEach((e) => e.salesExecutiveId == currentUser?.uid ? complaintDetails.add(e) : []);
    int complaintsCount = getPendingComplaintCount(complaintDetails);

    orderDetailsList.forEach((e) => e.salesExecutiveId == currentUser?.uid ? orderDetails.add(e) : []);
    SaleOrderDashBoard sdb = getSalesOrderCountAmtThisMonth(orderDetails);
    int pendingOrderCount = getPendingOrderCount(orderDetails);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Energy Efficient Lights'),
          backgroundColor: const Color(0xff4d47c3),
          actions: [
            TextButton.icon(
                onPressed: () async {
                  await _auth.signout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'authWrapper', (Route<dynamic> route) => false);
                },
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: const Text(
                  'logout',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: 440,
            height: 800,
            color: Colors.white,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 0.4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 15, top: 10),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(
                      'Name: ${salesExecutive.name}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                Container(
                  width: 180,
                  height: 60,
                  child: Image.asset('assets/logotm.jpg'),
                ),
                SizedBox(height: 20.80),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'callDetailsList');
                  },
                  child: Container(
                    width: 297,
                    height: 115,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 297,
                          height: 115,
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
                                            fontSize: 16,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Call Details:",
                                              style: TextStyle(
<<<<<<< HEAD
                                                decoration: TextDecoration.none,
=======
                                                decoration: TextDecoration.underline,
>>>>>>> 537bd16977ea968044814b58dc0c53d05a1251a9
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      "Calls Made This Month: ${cdb.callsCount}\nCalls Converted: ${cdb.callsConverted}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
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
                SizedBox(height: 20.80),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'salesDetailsList');
                  },
                  child: Container(
                    width: 323,
                    height: 115,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 297,
                          height: 115,
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
                                            fontSize: 16,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Sales Details:",
                                              style: TextStyle(
<<<<<<< HEAD
                                                decoration: TextDecoration.none,
=======
                                                decoration: TextDecoration.underline,
>>>>>>> 537bd16977ea968044814b58dc0c53d05a1251a9
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
<<<<<<< HEAD
                                      "Orders Delivered This Month: ${sdb.salesCount}\nTotal Sales Amount: ${sdb.salesAmount}\nBonus Earned: ${sdb.bonus}",
=======
                                      "Orders Delivered This Month: ${sdb.salesCount}\nTotal Sales Amount: ${sdb.salesAmount}",
>>>>>>> 537bd16977ea968044814b58dc0c53d05a1251a9
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
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
                SizedBox(height: 20.80),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'pendingOrderList');
                  },
                  child: Container(
                    width: 323,
                    height: 115,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 297,
                          height: 115,
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
                                            fontSize: 16,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Pending Orders:",
                                              style: TextStyle(
<<<<<<< HEAD
                                                decoration: TextDecoration.none,
=======
                                                decoration: TextDecoration.underline,
>>>>>>> 537bd16977ea968044814b58dc0c53d05a1251a9
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      "Total Pending Orders: $pendingOrderCount",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
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
                SizedBox(height: 20.80),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'complaintList');
                  },
                  child: Container(
                    width: 323,
                    height: 105,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 297,
                          height: 115,
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
                                            fontSize: 16,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Pending Complaints:",
                                              style: TextStyle(
<<<<<<< HEAD
                                                decoration: TextDecoration.none,
=======
                                                decoration: TextDecoration.underline,
>>>>>>> 537bd16977ea968044814b58dc0c53d05a1251a9
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      "Total Complaints Pending: $complaintsCount",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
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
                SizedBox(height: 20.80),
                SizedBox(
                  height: 59,
                  width: 350,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'customerList');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff4d47c3),
                        ),
                        child: Container(
                          width: 100,
                          height: 59,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x664d47c3),
                                blurRadius: 61,
                                offset: Offset(0, 4),
                              ),
                            ],
                            color: const Color(0xff4d47c3),
                          ),
                          padding: const EdgeInsets.only(
                            top: 18,
                            bottom: 17,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  "Customer",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 55,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'oderDetailsList');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff4d47c3),
                        ),
                        child: Container(
                          width: 100,
                          height: 59,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x664d47c3),
                                blurRadius: 61,
                                offset: Offset(0, 4),
                              ),
                            ],
                            color: const Color(0xff4d47c3),
                          ),
                          padding: const EdgeInsets.only(
                            top: 18,
                            bottom: 17,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              SizedBox(
                                width: 70,
                                child: Text(
                                  "Order",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
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
          ),
        ),
      ),
    );
  }
}
