import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/complaint_details_model.dart';
import 'package:flutter_app/models/order_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/screens/common/utility_functions.dart';
import 'package:flutter_app/screens/sales%20CoOrdinator/complaints/pending_complaints_list.dart';
import 'package:flutter_app/screens/sales%20CoOrdinator/follow%20up/follow_up_details_list.dart';
import 'package:flutter_app/screens/sales%20Executive/call%20Details/call_details_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/complaints/complaint_details_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/customer%20Details/customer_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/order_details_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/sales%20Details/sales_details_list_view.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:provider/provider.dart';

class SalesCoOrdinatorHome extends StatefulWidget {
  const SalesCoOrdinatorHome({super.key});

  @override
  State<SalesCoOrdinatorHome> createState() => _SalesCoOrdinatorHomeState();
}

class _SalesCoOrdinatorHomeState extends State<SalesCoOrdinatorHome> {
  final AuthService _auth = AuthService();

  List<String> executiveList = [
    'Select Executive',
  ];

  String salesExecutive = 'Select Executive';
  String salesExecutiveId = '';
  String error = '';
  bool firstTime = true;
  @override
  Widget build(BuildContext context) {
    final salesTable = Provider.of<List<SalesPersonModel?>?>(context);
    final callDetailsList = Provider.of<List<CallDetailsModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);
    var followUpDetails = [];
    var callDetails = [];
    final complaintDetailsList =
        Provider.of<List<ComplaintDetailsModel>>(context);
    var complaintDetails = [];
    final orderDetailsList = Provider.of<List<OrderDetailsModel>>(context);
    var orderDetails = [];
    List<SalesPersonModel?> salesExecList = [];
    if (salesTable != null) {
      salesTable.forEach((element) {
        if (element?.coOrdinatorId == currentUser?.uid) {
          salesExecList.add(element);
        }
      });
    }
    salesExecList.forEach((element) {
      callDetailsList.forEach((e) => element!.uid == e.salesExecutiveId && e.followUp ? followUpDetails.add(e) : []);
    });

    if (firstTime || executiveList.length == 1) {
      setState(() {
        firstTime = false;
      });
      salesExecList.forEach((element) {
        if (element?.role == 'Sales Executive') {
          executiveList.add(element!.name);
        }
      });
    }

    salesTable?.forEach((element) {
      if (element!.name == salesExecutive) {
        setState(() {
          salesExecutiveId = element.uid;
        });
      }
    });

    callDetailsList.forEach((e) =>
        e.salesExecutiveId == salesExecutiveId ? callDetails.add(e) : []);
    CallDetailDashBoard cdb = getCallsCountConvertedThisMonth(callDetails);
    //String cdbText = "Call Details:\n Calls Made This Month: $cdb.callsCount \nCalls Coverted: $cdb.callsConverted";
    int followupCount = getFollowUpCount(followUpDetails);

    complaintDetailsList.forEach((e) =>
        e.salesExecutiveId == salesExecutiveId ? complaintDetails.add(e) : []);
    int complaintsCount = getPendingComplaintCount(complaintDetails);

    orderDetailsList.forEach((e) =>
        e.salesExecutiveId == salesExecutiveId ? orderDetails.add(e) : []);
    SaleOrderDashBoard sdb = getSalesOrderCountAmtThisMonth(orderDetails);
    int pendingOrderCount = getPendingOrderCount(orderDetails);

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
                  style: TextStyle(color: Colors.white, fontSize: screenHeight / 50),
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            color: Colors.white,
            padding: const EdgeInsets.only(
              left: 19,
              right: 16,
              top: 10,
              bottom: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width:  screenWidth / 3,
                  height: screenHeight / 10,
                  child: Image.asset('assets/logotm.jpg'),
                ),
                SizedBox(height: 20.80),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    height: screenHeight / 10,
                    width: screenWidth / 2.2,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          //<-- SEE HERE
                          borderSide: BorderSide(color: Colors.black, width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          //<-- SEE HERE
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        filled: true,
                        fillColor: Color(0xffefefff),
                      ),
                      dropdownColor: const Color(0xffefefff),
                      value: salesExecutive,
                      onChanged: (String? newValue) {
                        setState(() {
                          salesExecutive = newValue!;
                        });
                      },
                      items: executiveList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: screenHeight / 50),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: screenHeight / 60),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 10.0,
                ),
                TextButton(
                  onPressed: () {
                    if (salesExecutiveId != '') {
                      setState(() {
                        error = '';
                      });
                      Navigator.pushNamed(
                          context, CallDetailsList.routeName,
                          arguments: Parameter(
                            salesExecutiveId,
                          ));
                    } else {
                      setState(() {
                        error = 'Please select an executive';
                      });
                    }
                  },
                  child: Container(
                    width: screenWidth / 1.5,
                    height: screenHeight / 9,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth / 1.5,
                          height: screenHeight / 9,
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
                                        padding: EdgeInsets.only(
                                            bottom:
                                                4), // Add padding below the underline
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors
                                                  .white, // Set the underline color
                                              width:
                                                  2, // Set the underline thickness
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
                                                text: "Call Details:",
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Calls Made This Month: ${cdb.callsCount}\nCalls Converted: ${cdb.callsConverted}",
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
                SizedBox(height: 20.80),
                TextButton(
                  onPressed: () {
                    if (salesExecutiveId != '') {
                      setState(() {
                        error = '';
                      });
                      Navigator.pushNamed(
                          context, SalesDetailsList.routeName,
                          arguments: Parameter(
                            salesExecutiveId,
                          ));
                    } else {
                      setState(() {
                        error = 'Please select an executive';
                      });
                    }
                  },
                  child: Container(
                    width: screenWidth / 1.5,
                    height: screenHeight / 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth / 1.5,
                          height: screenHeight / 8,
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
                                        padding: EdgeInsets.only(
                                            bottom:
                                                4), // Add padding below the underline
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors
                                                  .white, // Set the underline color
                                              width:
                                                  2, // Set the underline thickness
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
                                                text: "Sales Details:",
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Orders Delivered This Month: ${sdb.salesCount}\nTotal Sales Amount: ${sdb.salesAmount.toStringAsFixed(2)}\nBonus Earned: ${sdb.bonus}",
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
                SizedBox(height: 20.80),
                TextButton(
                  onPressed: () {
                    if (salesExecutiveId != '') {
                      setState(() {
                        error = '';
                      });
                      Navigator.pushNamed(
                          context, FollowUpDetails.routeName,
                          arguments: Parameter(
                            salesExecutiveId,
                          ));
                    } else {
                      setState(() {
                        error = 'Please select an executive';
                      });
                    }
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
                                        padding: EdgeInsets.only(
                                            bottom:
                                                4), // Add padding below the underline
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors
                                                  .white, // Set the underline color
                                              width:
                                                  2, // Set the underline thickness
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
                                                text: "Follow Up:",
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Total Follow Up Required: $followupCount",
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
                SizedBox(height: 20.80),
                TextButton(
                  onPressed: () {
                    if (salesExecutiveId != '') {
                      setState(() {
                        error = '';
                      });
                      Navigator.pushNamed(
                          context, PendingComplaintDetailsList.routeName,
                          arguments: Parameter(
                            salesExecutiveId,
                          ));
                    } else {
                      setState(() {
                        error = 'Please select an executive';
                      });
                    }
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
                                        padding: EdgeInsets.only(
                                            bottom:
                                                4), // Add padding below the underline
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors
                                                  .white, // Set the underline color
                                              width:
                                                  2, // Set the underline thickness
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
                                                text: "Pending Complaints:",
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Total Complaints Pending: $complaintsCount",
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
                SizedBox(height: 30.80),
                SizedBox(
                  height: screenHeight / 10,
                  width: screenWidth,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (salesExecutiveId != '') {
                            setState(() {
                              error = '';
                            });
                            Navigator.pushNamed(
                                context, CustomerListView.routeName,
                                arguments: Parameter(
                                  salesExecutiveId,
                                ));
                          } else {
                            setState(() {
                              error = 'Please select an executive';
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff4d47c3),
                        ),
                        child: Container(
                          height: screenHeight / 15,
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
                            children: [
                              SizedBox(
                                width: screenWidth / 5,
                                child: Text(
                                  "Customer",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenHeight / 50,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (salesExecutiveId != '') {
                            setState(() {
                              error = '';
                            });
                            Navigator.pushNamed(
                                context, OrderDetailsList.routeName,
                                arguments: Parameter(
                                  salesExecutiveId,
                                ));
                          } else {
                            setState(() {
                              error = 'Please select an executive';
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff4d47c3),
                        ),
                        child: Container(
                          height: screenHeight / 15,
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
                            children: [
                              SizedBox(
                                width: screenWidth / 5,
                                child: Text(
                                  "Order",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenHeight / 50,
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
