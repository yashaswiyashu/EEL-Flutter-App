import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/edit_details_model.dart';
import 'package:flutter_app/models/order_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/sales%20Executive/call%20Details/edit_call.dart';
import 'package:flutter_app/screens/sales%20Executive/call%20Details/view_call_details.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/add_order_details.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/edit_order_details.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/view_order_details.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';

class OrderDetailsAdmin extends StatefulWidget {
  const OrderDetailsAdmin({super.key});

  @override
  State<OrderDetailsAdmin> createState() => _OrderDetailsAdminState();
}



class _OrderDetailsAdminState extends State<OrderDetailsAdmin> {
  bool loading = false;
  String status = '';

  String character = '';
  final AuthService _auth = AuthService();
  
  String salesExec = 'Select Exec';
  var salesExecutive;
  String execID = '';
  String orderStatus = 'Order Placed';

  @override
  Widget build(BuildContext context) {
    final orderDetails = Provider.of<List<OrderDetailsModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);
    final salesTable = Provider.of<List<SalesPersonModel?>?>(context);

    var details = [];
    var obj;
    List<String> salesExecList = ['Select Exec',];
    if (salesTable != null) {
      salesTable.forEach((element) {
        if (element?.role == 'Sales Executive') {
          salesExecList.add(element!.name);
        }
      });
    }

    salesTable?.forEach((element) {
      if(element!.name == salesExec) {
        execID = element.uid;
      }
    });


    if(execID != '') {
      orderDetails.forEach((e) => (e.salesExecutiveId == execID && e.dropdown == orderStatus) ? details.add(e) : []);
    } else {
      orderDetails.forEach((e) => (e.dropdown == orderStatus) ? details.add(e) : []);
    }

    // details.forEach((element) {
    //   productsList.add(element.products);
    // });
    void setExec(String id) {
      setState(() {
        execID = id;
      });
    }

    Widget _verticalDivider = const VerticalDivider(
        color: Colors.black,
        thickness: 0.5,
    );

    List<DataColumn> _createColumns() {
      return [
        DataColumn(label: Text('Cust. Name')),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Shipment Id')),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Cust Mob.')),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Select')),
      ];
    }
    List<DataRow> _createRows() {
        return details.map((element) => DataRow(cells: [
          DataCell(Text(element.customerName)),
          DataCell(_verticalDivider),          
          DataCell(Text(element.shipmentID)),
          DataCell(_verticalDivider),
          DataCell(Text(element.mobileNumber)),
          DataCell(_verticalDivider),
          DataCell(RadioListTile(
            contentPadding: EdgeInsets.only(bottom: 30, ),
            value: element.uid,
            groupValue: character,
            onChanged: (value) {
              setState(() {
                character = value;
                details.forEach((element) {
                  if(element.uid == character){
                    obj = element;
                  }
                });
              });
            },
          ),),
        ]))
        .toList();
    }
    DataTable _createDataTable() {
      return DataTable(
        columnSpacing: 0.0,
        dataRowHeight: 40.0,
        columns: _createColumns(), 
        rows: orderDetails.isNotEmpty ? _createRows() : []
      );
    }

    // void showSettingsPanel(String name) {
    //   showModalBottomSheet(
    //     context: context, 
    //     builder: (context) {
    //       return Container(
    //         padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
    //         child: SingleCallDetailsView(name: name),
    //       );
    //     }
    //   );
    // }

    
    if (salesTable != null  && execID == '') {
      salesTable.forEach((element) {
        if (element?.uid == currentUser?.uid) {
          salesExecutive = element;
        }
      });
    } else {
      salesTable?.forEach((element) {
        if (element?.uid == execID) {
          salesExecutive = element;
        }
      });
    }



    return Scaffold(
            appBar: AppBar(
              title: const Text('Energy Efficient Lights'),
              backgroundColor: const Color(0xff4d47c3),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    await _auth.signout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                      'authWrapper',
                      (Route<dynamic> route) => false);
                  }, 
                  icon: const Icon(Icons.person, color: Colors.white,), 
                  label: const Text('logout', style: TextStyle(color: Colors.white),)
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                width: 440,
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
                padding: EdgeInsets.only(right: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                      width: 270,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset('assets/logotm.jpg'),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 250),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xff4d47c3)),
                        onPressed: (){
                          Navigator.pushNamed(
                                  context, 
                                  AddNewOrder.routeName,
                                  arguments: Parameter(
                                    execID,
                                  )
                                );
                        }, 
                        child: Text('Add New +'),
                      ),
                    ),
                  SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  SizedBox(
                    height: 60,
                    width: 175,
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
                      value: salesExec,
                      onChanged: (String? newValue) {
                        setState(() {
                          salesExec = newValue!;
                          execID = '';
                        });
                      },
                      items: salesExecList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: 175,
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
                        'Order Placed',
                        'Payment Pending',
                        'Shipped',
                        'Out for Delivery',
                        'Delivered',
                        'Cancelled',
                        'Returned'
                      ]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ]),
                    SizedBox(height: 10),
                    _createDataTable(),
                    SizedBox(height: 20,),
                    Text(
                      status,
                      style: const TextStyle(color: Colors.pink, fontSize: 14.0),
                    ),
                    SizedBox(height: 20,),
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
                              if(character == ''){
                                setState(() {  
                                  status ='Please select an option';
                                });
                              }else{
                                setState(() {
                                  status ='';
                                });
                                Navigator.pushNamed(
                                  context, 
                                  ViewOrder.routeName,
                                  arguments: Parameter(
                                    character,
                                  )
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              width: 95.63,
                              height: 59,
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // autogroupmj6kJr3 (UPthN48je9w6Wp7ratMJ6K)
                          margin: EdgeInsets.fromLTRB(0, 0, 7.38, 0),
                          child: TextButton(
                            onPressed: ()  {
                              // showSettingsPanel(character);
                              if(character == ''){
                                setState(() {
                                  status ='Please select an option';
                                });
                              }else{
                                setState(() {
                                  status ='';
                                });
                                Navigator.of(context).pushNamed(
                                  EditOrder.routeName,
                                  arguments: EditParameters(
                                    character,
                                    execID
                                  )
                                ).then((_) { setState(() {

                                });});
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              width: 95.63,
                              height: 59,
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
                                  'Edit',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
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
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            width: 95.63,
                            height: 59,
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
                                  fontSize: 16,
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
                    SizedBox(height: 20,),
                  ]
                ),
              )
        )
    );
  }
}
