import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/screens/admin/products/edit_product_details.dart';
import 'package:flutter_app/screens/admin/products/view_product_details.dart';
import 'package:flutter_app/screens/admin/users/co-ordinator/edit_co_ord.dart';
import 'package:flutter_app/screens/admin/users/co-ordinator/view_co_ord.dart';
import 'package:flutter_app/screens/admin/users/executive/edit_sales_exec_list.dart';
import 'package:flutter_app/screens/admin/users/executive/view_sales_exec.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/screens/sales%20Common/sales_person_registration.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/models/user_model.dart';


class SalesExecList extends StatefulWidget {
  const SalesExecList({super.key});


  @override
  State<SalesExecList> createState() => _SalesExecListState();
}


enum SingingCharacter { lafayette, jefferson, yash }


class _SalesExecListState extends State<SalesExecList> {
  bool loading = false;
  String status = '';
  String? select = '';
  String error = '';

  final AuthService _auth = AuthService();
  String salesCoOrdinator = 'Select Co-Ordinator';

  @override
  Widget build(BuildContext context) {
    final salesTable = Provider.of<List<SalesPersonModel?>>(context);
    final currentUser = Provider.of<UserModel?>(context);
    var obj;
    var execList = [];
    String coOrdId = '';
    List<String> salesCoOrdList = ['Select Co-Ordinator',];

    salesTable.forEach((element) {
      if (element!.name == salesCoOrdinator) {
        setState(() {
          coOrdId = element.uid;
        });
      }
    });


    if(coOrdId == '') {
      salesTable.forEach((element) {
        if(element?.role == 'Sales Executive'){
          execList.add(element);
        }
      });
    } else {
      salesTable.forEach((element) {
        if(element?.role == 'Sales Executive' && element?.coOrdinatorId == coOrdId){
          execList.add(element);
        }
      });
    }

    salesTable.forEach((element) {
      if(element?.role == 'Sales Co-Ordinator'){
        salesCoOrdList.add(element!.name);
      }
    });



    Widget _verticalDivider = const VerticalDivider(
      color: Colors.black,
      thickness: 0.5,
    );


    List<DataColumn> _createColumns() {
      return [
        DataColumn(label: Text('Exec Name',style: TextStyle(fontSize: screenHeight / 50),)),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Mob No.',style: TextStyle(fontSize: screenHeight / 50),)),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Select',style: TextStyle(fontSize: screenHeight / 50),)),
      ];
    }


    List<DataRow> _createRows() {
      return execList
          .map((element) => DataRow(cells: [
                DataCell(Text(element.name,style: TextStyle(fontSize: screenHeight / 50),)),
                DataCell(_verticalDivider),
                DataCell(Text(element.phoneNumber,style: TextStyle(fontSize: screenHeight / 50),)),
                DataCell(_verticalDivider),
                DataCell(
                  RadioListTile(
                    contentPadding: EdgeInsets.only(
                      bottom: 30,
                    ),
                    value: element.uid,
                    groupValue: select,
                    onChanged: (value) {
                      setState(() {
                        select = value;
                        execList.forEach((element) {
                          if (element.uid == select) {
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
          dataRowHeight: screenHeight / 16,
          columns: _createColumns(),
          rows: execList.isNotEmpty ? _createRows() : []);
    }


    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Energy Efficient Lights', style: TextStyle(fontSize: screenHeight / 50),),
              backgroundColor: const Color(0xff4d47c3),
              actions: [
                TextButton.icon(
                    onPressed: () async {
                      await _auth.signout();
                      Navigator.of(context).pushNamedAndRemoveUntil('authWrapper',(Route<dynamic> route) => false);
                    },
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: screenHeight / 50,
                    ),
                    label: Text(
                      'logout',
                      style: TextStyle(color: Colors.white,  fontSize: screenHeight / 50),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: screenHeight / 20,
                          margin: EdgeInsets.only(right: screenWidth / 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff4d47c3)),
                            onPressed: () {
                              Navigator.pushNamed(
                                context, SalesPersonRegistration.routeName,
                                arguments: 'Sales Executive');
                              },
                                    child: Text('Add New +', style: TextStyle(fontSize: screenHeight / 50),),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
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
                      value: salesCoOrdinator,
                      onChanged: (String? newValue) {
                        setState(() {
                          salesCoOrdinator = newValue!;
                        });
                      },
                      items: salesCoOrdList
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
                // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                //   Container(
                //     margin: const EdgeInsets.only(left: 110),
                //     child: Text(
                //       error,
                //       style: const TextStyle(color: Colors.red, fontSize: 14.0),
                //     ),
                //   ),
                // ]),
                SizedBox(
                  height: 10.0,
                ),
                    _createDataTable(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      status,
                      style:
                         TextStyle(color: Colors.red, fontSize: screenHeight / 60),
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
                              if (select == '') {
                                setState(() {
                                  status = 'Please select an option';
                                });
                              } else {
                                setState(() {
                                  status = '';
                                });
                                Navigator.pushNamed(
                                  context, ViewExecutiveDetails.routeName,
                                  arguments: Parameter(
                                    select!,
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
                            onPressed: () {
                              // showSettingsPanel(character);
                              if (select == '') {
                                setState(() {
                                  status = 'Please select an option';
                                });
                              } else {
                                setState(() {
                                  status = '';
                                });
                                Navigator.pushNamed(
                                  context, EditSalesExecutiveDetails.routeName,
                                  arguments: Parameter(
                                    select!,
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
