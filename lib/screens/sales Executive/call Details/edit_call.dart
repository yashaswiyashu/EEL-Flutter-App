import 'package:flutter/material.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/edit_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/screens/sales%20Executive/customer%20Details/add_new_customer.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/sales_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/services/call_details_database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'followup_container.dart';
import 'followup_container_edit.dart';

class EditCallDetails extends StatefulWidget {
  const EditCallDetails({super.key, this.restorationId});
  final String? restorationId;
  static const routeName = '/editCallDetails';

  @override
  State<EditCallDetails> createState() => _EditCallDetailsState();
}

class _EditCallDetailsState extends State<EditCallDetails>
    with RestorationMixin {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final controllerName = TextEditingController();
  final controllerNumber = TextEditingController();
  final controllerFolowUpDetails = TextEditingController();

  String status = '';
  String customerName = '';
  String customerType = 'Individual';
  String customerNumber = '';
  String callDate = '';
  String date = '';
  String result = '';
  String callResult = 'Interested';
  //String followUpDetails = '';
  String type = '';
  bool followUp = false;
  List<FollowUpDetail> followUpDetls = [];

/*   @override
  initState() {
    super.initState();

    // Start listening to changes.
    controllerFolowUpDetails.addListener(_saveFollowUpDetails);
  }
 
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    controllerFolowUpDetails.dispose();
    super.dispose();
  }

  void _saveFollowUpDetails() {
    followUpDetails = controllerFolowUpDetails.text;
  } */

void confirmation(String uid) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Entered customer is not registerd. Please Register here', style: TextStyle(fontSize: screenHeight / 50),),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // passing false
                child: Text('Cancel', style: TextStyle(fontSize: screenHeight / 50),),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // passing true
                child: Text('Register', style: TextStyle(fontSize: screenHeight / 50),),
              ),
            ],
          );
        }).then((exit) {
      if (exit == null) return;
      if (exit) {
        // user pressed Yes button
        Navigator.pushNamed(
          context, 
          AddNewCustomer.routeName,
          arguments: Parameter(
            uid,
          )
        );
      } else {
        // user pressed No button
        // Navigator.pop(context);
        return;
      }
    });
  }

  void showConfirmation(String uid) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Do you want to delete entire document?', style: TextStyle(fontSize: screenHeight / 50),),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // passing false
                child: Text('No', style: TextStyle(fontSize: screenHeight / 50),),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // passing true
                child: Text('Yes', style: TextStyle(fontSize: screenHeight / 50),),
              ),
            ],
          );
        }).then((exit) {
      if (exit == null) return;
      if (exit) {
        // user pressed Yes button
        CallDetailsDatabaseService(docid: uid).deleteUserData();
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
          firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
          lastDate: DateTime(2025),
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
        callDate =
            '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
      });
    }
  }

  var snackBar = SnackBar(
  content: Text('Call Details Updated Successfully!!!', style: TextStyle(fontSize: screenHeight / 50),),
  );

  var firstTime = true;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EditParameters;
    final currentUser = Provider.of<UserModel?>(context);
    final callDetails = Provider.of<List<CallDetailsModel>>(context);
    final salesTable = Provider.of<List<SalesPersonModel?>?>(context);
    final customerList = Provider.of<List<CustomerModel>>(context);

    var obj;
    String salesExecutiveName = '';
    var salesExecutive;
    var inDb = false;
    final AuthService _auth = AuthService();
    if (callDetails != null) {
      callDetails.forEach((element) {
        if (element.uid == args.uid) {
          obj = element;
        }
      });
    }

    if (salesTable != null && args.exec == '') {
      salesTable.forEach((element) {
        if (element?.uid == currentUser?.uid) {
          salesExecutiveName = element!.name;
          salesExecutive = element;
        }
      });
    } else {
      salesTable?.forEach((element) {
        if (element?.uid == args.exec) {
          salesExecutiveName = element!.name;
          salesExecutive = element;
        }
      });
    }

    if (obj != null && firstTime) {
      setState(() {
        firstTime = false;
      });
      customerName = obj?.customerName;
      type = obj?.customerType;
      customerNumber = obj?.mobileNumber;
      //controllerFolowUpDetails.text = obj?.followUpdetails;
      followUpDetls = obj.followUpDetls;
      result = obj?.callResult;
      followUp = obj?.followUp;
      date = obj?.callDate;
    }

    customerList.forEach((element) {
      if(element.customerName == customerName) {
        setState(() {
          inDb = true;
        });
      }
    });

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
              padding: EdgeInsets.only(right: 10, left: 10),
              child: Container(
                // calldetailsedit2is (32:1733)
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 0.4,
                ),
                width: screenWidth,
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
                                  fontSize: screenHeight / 55,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth / 3,
                            height: screenHeight / 10,
                            child: Image.asset('assets/logotm.jpg'),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 110),
                        child: Text(
                          status,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 14.0),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      SizedBox(
                        height: screenHeight / 40,
                        child: Text(
                          "Customer Name:",
                          style: TextStyle(
                            color: Color(0xff090a0a),
                            fontSize: screenHeight / 50,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: screenHeight / 50),
                        initialValue:  customerName,
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
                      SizedBox(
                          height: screenHeight / 40,
                          child: Text(
                            'Customer Type:',
                            style: TextStyle(
                              color: Color(0xff090a0a),
                              fontSize: screenHeight / 50,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      const SizedBox(height: 10.0),
                      // DropdownButtonFormField(
                      //   decoration: const InputDecoration(
                      //     enabledBorder: OutlineInputBorder(
                      //       //<-- SEE HERE
                      //       borderSide:
                      //           BorderSide(color: Colors.black, width: 0),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       //<-- SEE HERE
                      //       borderSide:
                      //           BorderSide(color: Colors.black, width: 2),
                      //     ),
                      //     filled: true,
                      //     fillColor: Color(0xffefefff),
                      //   ),
                      //   dropdownColor: const Color(0xffefefff),
                      //   value:
                      //       customerType == 'Individual' ? type : customerType,
                      //   onChanged: (String? newValue) {
                      //     setState(() {
                      //       customerType = newValue!;
                      //     });
                      //   },
                      //   items: <String>[
                      //     'Individual',
                      //     'Dealer',
                      //     'Distributor'
                      //   ].map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(
                      //         value,
                      //         style: const TextStyle(fontSize: 18),
                      //       ),
                      //     );
                      //   }).toList(),
                      // ),
                      TextFormField(
                        style: TextStyle(fontSize: screenHeight / 50),
                        initialValue:  type,
                        readOnly: true,
                        validator: (value) =>
                            value!.isEmpty ? 'Missing Field' : null,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Enter Customer Type',
                            fillColor: const Color(0xfff0efff)),
                        // onChanged: (val) {
                        //   customerName = val;
                        // },
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                          height: screenHeight / 40,
                          child: Text(
                            'Customer Mobile Number:',
                            style: TextStyle(
                              color: Color(0xff090a0a),
                              fontSize: screenHeight / 50,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        style: TextStyle(fontSize: screenHeight / 50),
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
                      SizedBox(
                        height: screenHeight / 40,
                        child: Text(
                          "Call Date:",
                          style: TextStyle(
                            color: Color(0xff090a0a),
                            fontSize: screenHeight / 50,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: screenWidth,
                        height: screenHeight / 15,
                        child: Row(
                          children: [ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffe3e4e5)),
                            onPressed: () {
                              // _restorableDatePickerRouteFuture.present();
                            },
                            child: Text(
                              date,
                              style: TextStyle(color: Colors.black, fontSize: screenHeight / 50),
                            ),
                          ),]
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                          height: screenHeight / 40,
                          child: Text(
                            'Call Result:',
                            style: TextStyle(
                              color: Color(0xff090a0a),
                              fontSize: screenHeight / 50,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide:
                                BorderSide(color: Colors.black, width: 0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          filled: true,
                          fillColor: Color(0xffefefff),
                        ),
                        dropdownColor: const Color(0xffefefff),
                        value: callResult == 'Interested' ? result : callResult,
                        onChanged: (String? newValue) {
                          setState(() {
                            callResult = newValue!;
                          });
                        },
                        items: <String>[
                          'Interested',
                          'Later',
                          'Not-Interested',
                          'Converted',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: screenHeight / 45),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 30.0),
                      Container(
                        child: Row(children: <Widget>[
                          SizedBox(
                              height: screenHeight / 40,
                              child: Text(
                                'Follow Up Required:',
                                style: TextStyle(
                                  color: Color(0xff090a0a),
                                  fontSize: screenHeight / 50,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            width: screenWidth / 20,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 254, 254),
                            ),
                            child: StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Switch(
                                value: followUp,
                                onChanged: (bool value) {
                                  setState(() {
                                    followUp = value;
                                  });
                                },
                              );
                            }),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        // followupdetailsjeX (32:1762)
                        margin: EdgeInsets.fromLTRB(1, 0, 0, 12),
                        child: Text(
                          'Follow Up Details:',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: screenHeight / 50,
                            fontWeight: FontWeight.w500,
                            height: 1,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      FollowUpDetailsContainerEdit(
                        onChanged: (followUpDetail) {
                          // Handle the edited follow-up detail here
                          // This callback will be triggered when an existing follow-up detail is edited
                        },
                        followUpDetails : followUpDetls,

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
                          validator: (value) =>
                              (followUp && value!.isEmpty) ? 'Missing Field' : null,
                          controller: controllerFolowUpDetails,
                          // onChanged: (val) {
                          //   setState(() {
                          //     followUpDetails = val;
                          //   });
                          // },
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
 */                      const SizedBox(height: 40.0),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 6, 0),
                        width: screenWidth,
                        height: screenHeight / 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            loading ? CircularProgressIndicator() : Container(
                              // autogroupmj6kJr3 (UPthN48je9w6Wp7ratMJ6K)
                              margin: EdgeInsets.fromLTRB(0, 0, 7.38, 0),
                              child: TextButton(
                                onPressed: () async {
                                  if(!inDb && callResult == 'Converted') {
                                    confirmation(salesExecutive.uid);
                                  }
                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    await CallDetailsDatabaseService(
                                            docid: obj!.uid)
                                        .updateUserData(
                                          args.exec == '' ? currentUser!.uid : args.exec,
                                          customerName,
                                          type,
                                          customerNumber,
                                          callDate == '' ? date : callDate,
                                          callResult == result
                                              ? result
                                              : callResult,
                                          followUp,
                                          followUpDetls,
                                        )
                                        .then((value) => setState(() {
                                              loading = false;
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              Navigator.pop(context);
                                            }));
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
                                      'save',
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
                                showConfirmation(obj!.uid);
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
                                    'Delete',
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
                      ),
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
