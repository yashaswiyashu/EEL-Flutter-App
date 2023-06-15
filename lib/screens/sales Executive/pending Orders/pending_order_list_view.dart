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
import 'package:flutter_app/screens/sales%20Executive/pending%20Orders/edit_pending_order.dart';
import 'package:flutter_app/screens/sales%20Executive/pending%20Orders/view_pending_order_details.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';

class PendingOrdersList extends StatefulWidget {
  const PendingOrdersList({super.key});
  static const routeName = '/PendingOrderDetailsList';

  @override
  State<PendingOrdersList> createState() => _PendingOrdersListState();
}



class _PendingOrdersListState extends State<PendingOrdersList> {
  bool loading = false;
  String status = '';

  String character = '';
  final AuthService _auth = AuthService();

  var salesExecutive;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Parameter;
    final orderDetails = Provider.of<List<OrderDetailsModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);
    var details = [];
    var obj;
    // var productsList = [];
    if (args.uid == '') {
      orderDetails.forEach((e) => ((e.salesExecutiveId == currentUser?.uid) &&  (e.dropdown != 'Delivered')) ? details.add(e) : []);
    } else {
      orderDetails.forEach((e) => ((e.salesExecutiveId == args.uid) &&  (e.dropdown != 'Delivered')) ? details.add(e) : []);
    }
    // details.forEach((element) {
    //   productsList.add(element.products);
    // });

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
        return details.map((element) => DataRow(cells: [
          DataCell(Text(element.customerName, style: TextStyle(fontSize: screenHeight / 50),)),
          DataCell(_verticalDivider),          
          DataCell(Text(element.shipmentID, style: TextStyle(fontSize: screenHeight / 50),)),
          DataCell(_verticalDivider),
          DataCell(Text(element.mobileNumber, style: TextStyle(fontSize: screenHeight / 50),)),
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
        dataRowHeight: screenHeight / 16,
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

    
    final salesTable = Provider.of<List<SalesPersonModel?>?>(context);

    if (salesTable != null && args.uid == '') {
      salesTable.forEach((element) {
        if (element?.uid == currentUser?.uid) {
          salesExecutive = element;
        }
      });
    } else {
      salesTable?.forEach((element) {
        if (element?.uid == args.uid) {
          salesExecutive = element;
        }
      });
      
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
                      'authWrapper',
                      (Route<dynamic> route) => false);
                  }, 
                  icon: Icon(Icons.person, color: Colors.white,size: screenHeight / 50,), 
                  label: Text('logout', style: TextStyle(color: Colors.white,  fontSize: screenHeight / 50),)
                ),
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
                padding: EdgeInsets.only(right: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  Text(
                    'Name: ${salesExecutive.name}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenHeight / 55,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                ]),
              ),
                    Container(
                      width: screenWidth / 3,
                      height: screenHeight / 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset('assets/logotm.jpg'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: screenHeight / 20,
                          margin: EdgeInsets.only(right: screenWidth / 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xff4d47c3)),
                            onPressed: (){
                              Navigator.pushNamed(
                                      context, 
                                      AddNewOrder.routeName,
                                      arguments: Parameter(
                                        '',
                                      )
                                    );
                            }, 
                            child: Text('Add New +', style: TextStyle(fontSize: screenHeight / 50),),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    _createDataTable(),
                    SizedBox(height: 20,),
                    Text(
                      status,
                      style: TextStyle(color: Colors.red, fontSize: screenHeight / 50),
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
                                  ViewPendingOrder.routeName,
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
                                  EditPendingOrder.routeName,
                                  arguments: EditParameters(
                                    character,
                                    args.uid
                                  )
                                ).then((_) { setState(() {

                                });});
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
                                  'Edit',
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
                    SizedBox(height: 20,),
                  ]
                ),
              )
        )
    );
  }
}
