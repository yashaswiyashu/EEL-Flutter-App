import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/edit_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/screens/sales%20Executive/call%20Details/add_call_details.dart';
import 'package:flutter_app/screens/sales%20Executive/call%20Details/edit_call.dart';
import 'package:flutter_app/screens/sales%20Executive/call%20Details/view_call_details.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';

class CallDetailsAdmin extends StatefulWidget {
  const CallDetailsAdmin({super.key});
  @override
  State<CallDetailsAdmin> createState() => _CallDetailsAdminState();
}



class _CallDetailsAdminState extends State<CallDetailsAdmin> {
  bool loading = false;
  String status = '';

  String character = '';
  final AuthService _auth = AuthService();
String salesExec = 'Select Exec';
  var salesExecutive;
    String execID = '';
  String callStatus = 'Interested';

  @override
  Widget build(BuildContext context) {
    final callDetails = Provider.of<List<CallDetailsModel>>(context);
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
      callDetails.forEach((e) => e.salesExecutiveId == execID && e.callResult == callStatus ? details.add(e) : []);
    } else {
      callDetails.forEach((e) => e.callResult == callStatus ? details.add(e) : []);
    }

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
        DataColumn(label: Text('Call Date', style: TextStyle(fontSize: screenHeight / 50),)),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Cust. Name', style: TextStyle(fontSize: screenHeight / 50),)),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Cust Mob.', style: TextStyle(fontSize: screenHeight / 50),)),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Select', style: TextStyle(fontSize: screenHeight / 50),)),
      ];
    }
    List<DataRow> _createRows() {
        return details.map((element) => DataRow(cells: [
          DataCell(Text(element.callDate, style: TextStyle(fontSize: screenHeight / 50),)),
          DataCell(_verticalDivider),          
          DataCell(Text(element.customerName, style: TextStyle(fontSize: screenHeight / 50),)),
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
        rows: callDetails.isNotEmpty ? _createRows() : []
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

    
    if ((salesTable != null) && (execID == '')) {
      salesTable.forEach((element) {
        if (element?.uid == currentUser?.uid) {
          salesExecutive = element;
        }
      });
    } else if (salesTable != null){
      salesTable.forEach((element) {
        if (element?.uid == execID) {
          salesExecutive = element;
        }
      });
    }



    return Scaffold(
            appBar: AppBar(
              title: Text('Energy Efficient Lights', style: TextStyle(fontSize: screenHeight / 50),),
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
                  label: Text('logout', style: TextStyle(color: Colors.white, fontSize: screenHeight / 50),)
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
                      fontSize: screenHeight / 50,
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
                    Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: screenHeight / 20,
                          margin: EdgeInsets.only(right: screenWidth / 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xff4d47c3)),
                            onPressed: (){
                              Navigator.pushNamed(
                                      context, 
                                      AddCallDetails.routeName,
                                      arguments: Parameter(
                                        execID,
                                      )
                                    );
                            }, 
                            child: Text('Add New +', style: TextStyle(fontSize: screenHeight / 50),),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  SizedBox(
                    height: screenHeight / 15,
                    width: screenWidth / 3,
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
                          setExec(execID);
                        });
                      },
                      items: salesExecList
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
                  SizedBox(
                    height: screenHeight / 15,
                    width: screenWidth / 3,
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
                      value: callStatus,
                      onChanged: (String? newValue) {
                        setState(() {
                          callStatus = newValue!;
                        });
                      },
                      items: <String> [
                        'Interested',
                        'Later',
                        'Not-Interested',
                        'Converted'
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
                                  ViewCallDetails.routeName,
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
                                Navigator.pushNamed(
                                  context, 
                                  EditCallDetails.routeName,
                                  arguments: EditParameters(
                                    character,
                                    execID,
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
