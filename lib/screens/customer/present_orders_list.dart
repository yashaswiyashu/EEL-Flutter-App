import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/edit_details_model.dart';
import 'package:flutter_app/models/order_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/screens/sales%20Executive/call%20Details/edit_call.dart';
import 'package:flutter_app/screens/sales%20Executive/call%20Details/view_call_details.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/add_order_details.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/edit_order_details.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/view_order_details.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/order_database.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';

class PresentCustomerOrdersList extends StatefulWidget {
  const PresentCustomerOrdersList({super.key});

  @override
  State<PresentCustomerOrdersList> createState() =>
      _PresentCustomerOrdersListState();
}

class _PresentCustomerOrdersListState extends State<PresentCustomerOrdersList> {
  bool loading = false;
  String status = '';

  String character = '';
  final AuthService _auth = AuthService();

  var canCancel = false;
  String orderStatus = 'All Orders';
  @override
  Widget build(BuildContext context) {
    final orderDetails = Provider.of<List<OrderDetailsModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);
    var details = [];
    var obj;

    void showConfirmation(String uid) {
      showDialog(
          context: context,
          builder: (_) {
            String warn = '';
            orderDetails.forEach((element) {
              if (element.uid == uid) {
                if (element.dropdown == 'Order Placed') {
                  warn = 'Do you want to cancel this order?';
                  canCancel = true;
                } else {
                  warn = 'Cannot cancel Order';
                  canCancel = false;
                }
              }
            });

            return AlertDialog(
              title: Text(warn, style: TextStyle(fontSize: screenHeight / 50),),
              actions: canCancel
                  ? [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, false), // passing false
                        child: Text('No', style: TextStyle(fontSize: screenHeight / 50),),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, true), // passing true
                        child: Text('Yes', style: TextStyle(fontSize: screenHeight / 50),),
                      ),
                    ]
                  : [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, false), // passing false
                        child: Text('Ok', style: TextStyle(fontSize: screenHeight / 50),),
                      ),
                    ],
            );
          }).then((exit) {
        if (exit == null) return;
        if (exit && canCancel) {
          // user pressed Yes button
          orderDetails.forEach((element) {
            if (element.uid == character) {
              OrderDetailsDatabaseService(docid: character)
                  .updateOrderData(
                      element.salesExecutiveId,
                      element.customerId,
                      element.customerName,
                      element.shipmentID,
                      element.mobileNumber,
                      element.address1,
                      element.address2,
                      element.district,
                      element.state,
                      element.pincode,
                      element.deliveryDate,
                      'Cancelled',
                      element.subTotal,
                      element.totalAmount,
                      element.orderedDate,
                      element.products)
                  .then((value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Order cancelled Successfully!!!', style: TextStyle(fontSize: screenHeight / 50),),
                ));
                Navigator.pop(context);
              });
            }
          });
        } else {
          // user pressed No button
          // Navigator.pop(context);
          return;
        }
      });
    }

    if(orderStatus != 'All Orders') {
      orderDetails.forEach((e) => e.customerId == currentUser?.uid &&
              e.dropdown != 'Cancelled' &&
              e.dropdown != 'Delivered' &&
              e.dropdown != 'Returned' && e.dropdown == orderStatus
          ? details.add(e)
          : []);
    } else {
      orderDetails.forEach((e) => e.customerId == currentUser?.uid &&
              e.dropdown != 'Cancelled' &&
              e.dropdown != 'Delivered' &&
              e.dropdown != 'Returned' 
          ? details.add(e)
          : []);
    }

    Widget _verticalDivider = const VerticalDivider(
      color: Colors.black,
      thickness: 0.5,
    );

    List<DataColumn> _createColumns() {
      return [
        DataColumn(label: Text('Cust. Name', style: TextStyle(fontSize: screenHeight / 50),)),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Shipment Id', style: TextStyle(fontSize: screenHeight / 50),)),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Cust Mob.', style: TextStyle(fontSize: screenHeight / 50),)),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Select', style: TextStyle(fontSize: screenHeight / 50),)),
      ];
    }

    List<DataRow> _createRows() {
      return details
          .map((element) => DataRow(cells: [
                DataCell(Text(element.customerName, style: TextStyle(fontSize: screenHeight / 50),)),
                DataCell(_verticalDivider),
                DataCell(Text(element.shipmentID, style: TextStyle(fontSize: screenHeight / 50),)),
                DataCell(_verticalDivider),
                DataCell(Text(element.mobileNumber, style: TextStyle(fontSize: screenHeight / 50),)),
                DataCell(_verticalDivider),
                DataCell(
                  RadioListTile(
                    contentPadding: EdgeInsets.only(
                      bottom: 30,
                    ),
                    value: element.uid,
                    groupValue: character,
                    onChanged: (value) {
                      setState(() {
                        character = value;
                        details.forEach((element) {
                          if (element.uid == character) {
                            obj = element;
                          }
                        });
                      });
                    },
                  ),
                ),
              ]))
          .toList();
    }

    DataTable _createDataTable() {
      return DataTable(
          columnSpacing: 0.0,
          dataRowHeight: 40.0,
          columns: _createColumns(),
          rows: orderDetails.isNotEmpty ? _createRows() : []);
    }

    return Scaffold(
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
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 0.4,
          ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: screenWidth / 3,
                  height: screenHeight / 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset('assets/logotm.jpg'),
                ),
                SizedBox(height: 10),
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
                      value: orderStatus,
                      onChanged: (String? newValue) {
                        setState(() {
                          orderStatus = newValue!;
                        });
                      },
                      items: <String> [
                        'All Orders',
                        'Order Placed',
                        'Payment Pending',
                        'Shipped',
                        'Out for Delivery',
                      ]
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
                SizedBox(height: 10),
                _createDataTable(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  status,
                  style: TextStyle(color: Colors.red, fontSize: screenHeight / 50),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // autogroupmj6kJr3 (UPthN48je9w6Wp7ratMJ6K)
                      margin: EdgeInsets.fromLTRB(0, 0, 7.38, 0),
                      child: TextButton(
                        onPressed: () async {
                          // showSettingsPanel(character);
                          if (character == '') {
                            setState(() {
                              status = 'Please select an option';
                            });
                          } else {
                            setState(() {
                              status = '';
                            });
                            Navigator.pushNamed(context, ViewOrder.routeName,
                                arguments: Parameter(
                                  character,
                                ));
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Container(
                          width: screenWidth / 5,
                          height: screenHeight / 15,
                          decoration: BoxDecoration(
                            color: Color(0xff4d47c3),
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x664d47c3),
                                offset: Offset(0, 4),
                                blurRadius: 30.5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'View',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: screenHeight / 50,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      // autogroupqdj5BoM (UPthV8mGmAE7wuU648qDj5)
                      onPressed: () {
                        if (character == '') {
                          setState(() {
                            status = 'Please select an option';
                          });
                        } else {
                          setState(() {
                            status = '';
                          });
                          showConfirmation(character);
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: screenWidth / 5,
                        height: screenHeight / 15,
                        decoration: BoxDecoration(
                          color: Color(0xff4d47c3),
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x664d47c3),
                              offset: Offset(0, 4),
                              blurRadius: 30.5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Cancel Order',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: screenHeight / 50,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      // autogroupqdj5BoM (UPthV8mGmAE7wuU648qDj5)
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: screenWidth / 5,
                        height: screenHeight / 15,
                        decoration: BoxDecoration(
                          color: Color(0xff4d47c3),
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x664d47c3),
                              offset: Offset(0, 4),
                              blurRadius: 30.5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Back',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: screenHeight / 50,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ]),
        )));
  }
}
