import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/complaint_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/sales%20Executive/complaints/edit_complaint.dart';
import 'package:flutter_app/screens/sales%20Executive/complaints/view_complaint_details.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';


class ComplaintDetailsList extends StatefulWidget {
  const ComplaintDetailsList({super.key});


  @override
  State<ComplaintDetailsList> createState() => _ComplaintDetailsListState();
}


class _ComplaintDetailsListState extends State<ComplaintDetailsList> {
  bool loading = false;
  String status = '';


  String character = '';
  final AuthService _auth = AuthService();


  var salesExecutive;


  @override
  Widget build(BuildContext context) {
    final complaintDetails = Provider.of<List<ComplaintDetailsModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);
    var details = [];
    var obj;


    complaintDetails.forEach(
        (e) => e.salesExecutiveId == currentUser?.uid ? details.add(e) : []);


    Widget _verticalDivider = const VerticalDivider(
      color: Colors.black,
      thickness: 0.5,
    );


    List<DataColumn> _createColumns() {
      return [
        DataColumn(label: Text('Complaint ID')),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Cust. Name')),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Cust Mob.')),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Select')),
      ];
    }


    List<DataRow> _createRows() {
      return details
          .map((element) => DataRow(cells: [
                DataCell(Text(element.complaintDate)),
                DataCell(_verticalDivider),
                DataCell(Text(element.customerName)),
                DataCell(_verticalDivider),
                DataCell(Text(element.mobileNumber)),
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
          rows: complaintDetails.isNotEmpty ? _createRows() : []);
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


    final complaintsTable = Provider.of<List<ComplaintDetailsModel?>?>(context);


    if (complaintsTable != null) {
      complaintsTable.forEach((element) {
        if (element?.uid == currentUser?.uid) {
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
                  Navigator.pushNamed(context, 'home');
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
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(
                      'Name: Sales Executive',
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
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff4d47c3)),
                    onPressed: () {
                      Navigator.pushNamed(context, 'addNewComplaints');
                    },
                    child: Text('Add New +'),
                  ),
                ),
                SizedBox(height: 10),
                _createDataTable(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  status,
                  style: const TextStyle(color: Colors.pink, fontSize: 14.0),
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
                                context, ViewComplaintDetails.routeName,
                                arguments: Parameter(
                                  character,
                                ));
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
                        onPressed: () {
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
                                context, EditComplaintDetails.routeName,
                                arguments: Parameter(
                                  character,
                                ));
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
                SizedBox(
                  height: 20,
                ),
              ]),
        )));
  }
}
