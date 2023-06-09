import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/complaint_details_model.dart';
import 'package:flutter_app/models/edit_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/complaint_details_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/services/complaint_details_database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'complaint_container_edit.dart';

class EditComplaintDetails extends StatefulWidget {
  const EditComplaintDetails({super.key, this.restorationId});
  final String? restorationId;
  static const routeName = '/editComplaintDetails';


  @override
  State<EditComplaintDetails> createState() => _EditComplaintDetailsState();
}


class _EditComplaintDetailsState extends State<EditComplaintDetails>
    with RestorationMixin {
  //String callDate = 'Select Date';
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final controllerResult = TextEditingController();
  final controllerComplaintDetails = TextEditingController();


  String status = '';
  String customerName = '';
  String customerNumber = '';
  String complaintDate = '';
  String complaintResult = 'Open';
  String res = '';
  //String complaintDetails = '';
  String error = '';
  List<ComplaintDetail> complaintDetls = [];


  @override
  initState() {
    super.initState();


    // Start listening to changes.
    controllerResult.addListener(_saveResult);

    //controllerComplaintDetails.addListener(_controllerComplaintDetails);
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    controllerResult.dispose();

    //controllerComplaintDetails.dispose();
    super.dispose();
  }


  void _saveResult() {
    complaintResult = controllerResult.text;
  }


  /* void _controllerComplaintDetails() {
    complaintDetails = controllerComplaintDetails.text;
  }
 */

  void showConfirmation(String uid) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Do you want to delete entire document?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // passing false
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // passing true
                child: Text('Yes'),
              ),
            ],
          );
        }).then((exit) {
      if (exit == null) return;
      if (exit) {
        // user pressed Yes button
        ComplaintDetailsDatabaseService(docid: uid).deleteUserData();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
          content: Text(
              'Complaint details deleted Successfully!!!'),
        ));
        Navigator.pop(context);
      } else {
        // user pressed No button
        // Navigator.pop(context);
        return;
      }
    });
  }


  @override
  String? get restorationId => widget.restorationId;


  final RestorableDateTime _selectedDate = RestorableDateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );


  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2023),
          lastDate: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
        );
      },
    );
  }


  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }


  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        complaintDate =
            '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
      });
    }
  }


  var snackBar = SnackBar(
    content: Text('Call Details Updated Successfully!!!'),
  );


  String date = '';

  var firstTime = true;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as EditParameters;
    final currentUser = Provider.of<UserModel?>(context);
    final complaintDetailslist = Provider.of<List<ComplaintDetailsModel>>(context);
    final ComplaintDetailsTable =
        Provider.of<List<ComplaintDetailsModel?>?>(context);
    final salesTable = Provider.of<List<SalesPersonModel?>>(context);


    var obj;
    String salesExecutiveName = '';
    var salesExecutive;
    final AuthService _auth = AuthService();
    if (complaintDetailslist != null) {
      complaintDetailslist.forEach((element) {
        if (element.uid == args.uid) {
          obj = element;
        }
      });
    }


    if (salesTable != null && args.exec == '') {
      salesTable.forEach((element) {
        if (element?.uid == currentUser?.uid) {
          salesExecutive = element;
        }
      });
    } else {
      salesTable.forEach((element) {
        if (element?.uid == args.exec) {
          salesExecutive = element;
        }
      });
    }


    if (obj != null && firstTime) {
      setState(() {
        firstTime = false;
      });
      customerName= obj?.customerName;
      customerNumber = obj?.mobileNumber;
      controllerResult.text = obj?.complaintResult;
      res = obj?.complaintResult;
      date = obj?.complaintDate;
      //controllerComplaintDetails.text = obj?.complaintDetails;
      complaintDetls = obj.complaintDetls;
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
          padding: EdgeInsets.only(right: 10, left: 10),
          child: Container(
            // call detailsedit2is (32:1733)
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 0.4,
            ),
            width: 440,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 110),
                    width: 180,
                    height: 60,
                    child: Image.asset('assets/logotm.jpg'),
                  ),
                  const SizedBox(height: 20.0),
                  const SizedBox(height: 5.0),
                  Container(
                    margin: const EdgeInsets.only(left: 110),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  const SizedBox(
                    height: 20.0,
                    child: Text(
                      "Customer Name:",
                      style: TextStyle(
                        color: Color(0xff090a0a),
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: customerName,
                    readOnly: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Missing Field' : null,
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Enter Customer Name',
                        fillColor: const Color(0xfff0efff)),
                    // onChanged: (val) {
                    //   customerName = val;
                    // },
                  ),
                  const SizedBox(height: 20.0),
                  const SizedBox(
                      height: 20.0,
                      child: Text(
                        'Customer Mobile Number:',
                        style: TextStyle(
                          color: Color(0xff090a0a),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    initialValue: customerNumber,
                    readOnly: true,
                    validator: (value) =>
                        value?.length == 10 ? null : 'Enter valid number',
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Enter Customer Mobile Number',
                    ),
                    // onChanged: (val) {
                    //   customerNumber = val;
                    // },
                  ),
                  const SizedBox(height: 20.0),
                  const SizedBox(
                    height: 20.0,
                    child: Text(
                      "Complaint Date:",
                      style: TextStyle(
                        color: Color(0xff090a0a),
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 440,
                    height: 50,
                    child: Row(children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffe3e4e5)),
                        onPressed: () {
                         // _restorableDatePickerRouteFuture.present();
                        },
                        child: Text(
                          complaintDate == '' ? date : complaintDate,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ]),
                  ),


                  const SizedBox(height: 20.0),
                  const SizedBox(
                      height: 20.0,
                      child: Text(
                        'Complaint Status:',
                        style: TextStyle(
                          color: Color(0xff090a0a),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  DropdownButtonFormField(
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
                    value: complaintResult == 'Open' ? res : complaintResult,
                    onChanged: (String? newValue) {
                      setState(() {
                        complaintResult = newValue!;
                      });
                    },
                    items: <String>[
                      'Open',
                      'ReOpen',
                      'Closed',
                      'In Process',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // complaintDetailsjeX (32:1762)
                    margin: EdgeInsets.fromLTRB(1, 0, 0, 12),
                    child: Text(
                      'Complaint Details:',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                      ComplaintDetailsContainerEdit(
                        onChanged: (complaintDetail) {
                          // Handle the edited follow-up detail here
                          // This callback will be triggered when an existing follow-up detail is edited
                        },
                        complaintDetails : complaintDetls,

                      ),

/*                       Container(
                    width: 440,
                    height: 83,
                    padding: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xffe3e4e5)),
                      color: Color(0xfff0efff),
                    ),
                    child: TextFormField(
                      controller: controllerComplaintDetails,
                      validator: (value) =>
                          value!.isEmpty ? 'Missing Field' : null,
                      onChanged: (val) {
                        setState(() {});
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),*/
                  const SizedBox(height: 5.0),
                  Container(
                    margin: const EdgeInsets.only(left: 110),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 6, 0),
                    width: 440,
                    height: 59,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        loading
                            ? CircularProgressIndicator()
                            : Container(
                                // autogroupmj6kJr3 (UPthN48je9w6Wp7ratMJ6K)
                                margin: EdgeInsets.fromLTRB(0, 0, 7.38, 0),
                                child: TextButton(
                                  onPressed: () async {
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      await ComplaintDetailsDatabaseService(
                                              docid: obj!.uid)
                                          .updateUserData(
                                            (args.exec == '' ? currentUser?.uid : args.exec)!,
                                            customerName,
                                            customerNumber,
                                            complaintDate == '' ? date : complaintDate,
                                            complaintResult == 'Open' ? res : complaintResult,
                                            complaintDetls,
                                          )
                                          .then((value) => setState(() {
                                                loading = false;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                Navigator.pop(context);
                                              }));
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
                                        'Save',
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
                            showConfirmation(obj!.uid);
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
                                'Delete',
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
                  ),
                  // import table from database
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
