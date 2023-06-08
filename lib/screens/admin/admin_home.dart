import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';

import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/complaint_details_model.dart';
import 'package:flutter_app/models/order_details_model.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/utility_functions.dart';
import 'package:flutter_app/screens/sales%20Executive/call%20Details/call_details_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/complaints/complaint_details_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/customer%20Details/customer_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/add_order_details.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/order_details_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/sales%20Details/sales_details_list_view.dart';
// import 'package:flutter_app/screens/salesPerson/executive/call_details.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:provider/provider.dart';

import '../../models/call_details_model.dart';
import '../../models/complaint_details_model.dart';
import '../common/utility_functions.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final AuthService _auth = AuthService();
  var salesExecutive;
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    final currentUser = Provider.of<UserModel?>(context);
    final salesTable = Provider.of<List<SalesPersonModel?>?>(context);


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
                  width: 180,
                  height: 60,
                  child: Image.asset('assets/logotm.jpg'),
                ),
                SizedBox(height: 20.80),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'productListView');
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
                                              text: "Products:",
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
                                      "Total Products Added: ",
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
                    Navigator.pushNamed(context, 'selectUser');
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
                                              text: "Users:",
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
                                      "Total Sales Co-Ordinators: \nTotal Sales Executive: \nTotal Customers:",
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
                    Navigator.pushNamed(context, 'complaintDetialsAdmin');
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
                                              text: "Complaints:",
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
                                      "Total Complaints(This Month): \n Total Pending Complaints",
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
                    Navigator.pushNamed(context, 'ordersListAdmin');
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
                                              text: "Orders:",
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
                                      "Total Orders(This Month): \nTotal Pending Orders:",
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
                    Navigator.pushNamed(context, 'callDetailsListAdmin');
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
                                    SizedBox(height: 10,),
                                    Text(
                                      "Total Calls(This Month): ",
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
                    Navigator.pushNamed(context, 'feedbackDetailsAdmin');
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
                                              text: "Feedback Details:",
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
                                      "Total Feedbacks: ",
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
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
