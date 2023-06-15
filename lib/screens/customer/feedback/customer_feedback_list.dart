import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/complaint_details_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/edit_details_model.dart';
import 'package:flutter_app/models/feedback_details_mode.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/screens/customer/feedback/add_new_feedback.dart';
import 'package:flutter_app/screens/customer/feedback/view_feedback_details.dart';
import 'package:flutter_app/screens/sales%20Executive/complaints/add_new_complaints.dart';
import 'package:flutter_app/screens/sales%20Executive/complaints/edit_complaint.dart';
import 'package:flutter_app/screens/sales%20Executive/complaints/view_complaint_details.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';


class CustomerFeedbackList extends StatefulWidget {
  const CustomerFeedbackList({super.key});
static const routeName = '/CustomerFeedbackList';

  @override
  State<CustomerFeedbackList> createState() => _CustomerFeedbackListState();
}


class _CustomerFeedbackListState extends State<CustomerFeedbackList> {
  bool loading = false;
  String status = '';


  String character = '';
  final AuthService _auth = AuthService();


  var salesExecutive;
  String custName = '';
  String execId = '';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Parameter;
    final feedbackDetails = Provider.of<List<FeedbackDetailsModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);
    final salesTable = Provider.of<List<SalesPersonModel?>?>(context);
    final customerList = Provider.of<List<CustomerModel>>(context);

    if (salesTable != null && args.uid == '') {
      salesTable.forEach((element) {
        if (element?.uid == currentUser?.uid) {
          salesExecutive = element;
          execId = element!.uid;
        }
      });
    } else {
      salesTable!.forEach((element) {
        if (element?.uid == args.uid) {
          salesExecutive = element;
          execId = element!.uid;
        }
      });
    }

    customerList.forEach((element) {
      if(element.uid == currentUser?.uid) {
        custName = element.customerName;
      }
    });

    var details = [];
    var obj;

    // if (args.uid == '') {
    //   complaintDetailsList.forEach((e) => ((e.salesExecutiveId == currentUser?.uid) && (e.complaintResult != 'Closed')) ? details.add(e) : []);
    // } else {
    //   complaintDetailsList.forEach((e) => ((e.salesExecutiveId == args.uid) && (e.complaintResult != 'Closed')) ? details.add(e) : []);
    // }


    feedbackDetails.forEach((e) => ((e.customerName == custName)) ? details.add(e) : []);
    // customerList.forEach((element) {
    //     if(e.customerName == element.customerName){

    //     }
    // });



    Widget _verticalDivider = const VerticalDivider(
      color: Colors.black,
      thickness: 0.5,
    );


    List<DataColumn> _createColumns() {
      return [
        DataColumn(label: Text('FeedBack Date', style: TextStyle(fontSize: screenHeight / 50))),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Cust. Name', style: TextStyle(fontSize: screenHeight / 50))),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Cust. Mob', style: TextStyle(fontSize: screenHeight / 50))),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Select', style: TextStyle(fontSize: screenHeight / 50))),
      ];
    }


    List<DataRow> _createRows() {
      return details
          .map((element) => DataRow(cells: [
                DataCell(Text(element.feedbackDate, style: TextStyle(fontSize: screenHeight / 50))),
                DataCell(_verticalDivider),
                DataCell(Text(element.customerName, style: TextStyle(fontSize: screenHeight / 50))),
                DataCell(_verticalDivider),
                DataCell(Text(element.mobileNumber, style: TextStyle(fontSize: screenHeight / 50))),
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
          dataRowHeight: screenHeight / 16,
          columns: _createColumns(),
          rows: feedbackDetails.isNotEmpty ? _createRows() : []);
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
                                      context, 
                                      CustomerFeedback.routeName,
                                      arguments: Parameter(
                                        execId,
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
                SizedBox(
                  height: 20,
                ),
                Text(
                  status,
                  style: TextStyle(color: Colors.pink, fontSize: screenHeight / 60),
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
                            Navigator.pushNamed(
                                context, ViewCustomerFeedback.routeName,
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
