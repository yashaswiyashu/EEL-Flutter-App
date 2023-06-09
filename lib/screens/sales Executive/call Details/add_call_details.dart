import 'package:flutter/material.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/screens/sales%20Executive/customer%20Details/add_new_customer.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/sales_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/services/call_details_database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'followup_container.dart';

class AddCallDetails extends StatefulWidget {
  const AddCallDetails({super.key, this.restorationId});
  final String? restorationId;
  static const routeName = '/addCallDetails';
  @override
  State<AddCallDetails> createState() => _AddCallDetailsState();
}

class _AddCallDetailsState extends State<AddCallDetails> with RestorationMixin {
  final _formkey = GlobalKey<FormState>();
  bool followUp = false;
  bool loading = false;
  String customerType = 'Individual';
  String customerName = '';
  String customerNumber = '';
  String callDate = 'Select Date';
  String callResult = 'Interested';
  //String followUpDetails = '';
  String error = '';
  String status = '';
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    List<List<String>> tableData = [
                        ['', ''],
                       ];
    List<FollowUpDetail> followUpDetls = [];


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
          /* firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
          lastDate: DateTime(2025), */
          //[Viru:25/5/23] Changed the first date, last date to pick from the current date and previous
          firstDate: DateTime(DateTime.now().year - 1),
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
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //       'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        // ));
        callDate =
            '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
      });
    }
  }
  var salesExecutive;
  void initState() {
    nameController.addListener(_nameLatestValue);
    numberController.addListener(_numberLatestValue);
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  void _nameLatestValue() {
    customerName = nameController.text;
    //print('Viru:: ${numberController.text}');
  }

  void _numberLatestValue() {
    customerNumber = numberController.text;
    //print('Viru:: ${numberController.text}');
  }

  void showConfirmation(String uid) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Entered customer is not registerd. Please Register here'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // passing false
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // passing true
                child: Text('Register'),
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

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Parameter;
    final currentUser = Provider.of<UserModel?>(context);
    final salesTable = Provider.of<List<SalesPersonModel?>?>(context);
    final AuthService _auth = AuthService();
    final customerList = Provider.of<List<CustomerModel>>(context);
    List<CustomerModel> details = [];
    var inDb = false;

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

    if(args.uid == '') {
      customerList.forEach((e) => e.salesExecutiveId == currentUser?.uid ? details.add(e) : []);
    } else {
      customerList.forEach((e) => e.salesExecutiveId == args.uid ? details.add(e) : []);
    }

    details.forEach((element) {
      if(element.customerName == customerName) {
        setState(() {
          inDb = true;
        });
        numberController.text = element.mobileNumber;
      }
    });

      var snackBar = SnackBar(
  content: Text('Call Details added Successfully!!!'),
  );

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
                width: screenWidth,
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      TypeAheadFormField(
                    
                    textFieldConfiguration: TextFieldConfiguration(
                      style: TextStyle(fontSize: screenHeight / 50),
                      controller: nameController,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Enter Customer Name',
                        fillColor: const Color(0xfff0efff),
                      ),
                      /* onChanged: (val) {
                        customerName = val;
                      }, */
                    ),
              
                    suggestionsCallback: (pattern) async {
                      // Filter the customer list based on the search pattern
                      return details
                      .where((customer) =>
                      customer != null &&
                      customer.customerName.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                    },
              
                    itemBuilder: (context, CustomerModel? suggestion) {
                      if (suggestion == null) return const SizedBox.shrink();
                      return ListTile(
                        title: Text(suggestion.customerName),
                      );
                    },
              
                    onSuggestionSelected: (CustomerModel? suggestion) {
                      if (suggestion != null) {
                        setState(() {
                          //customerName = suggestion.customerName;
                          nameController.text = suggestion.customerName;
                      });
                    }
                },
              
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
                        value: customerType,
                        onChanged: (String? newValue) {
                          setState(() {
                            customerType = newValue!;
                          });
                        },
                        items: <String>[
                          'Individual',
                          'Dealer',
                          'Distributor',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: screenHeight / 50),
                            ),
                          );
                        }).toList(),
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
                        controller: numberController,
                        keyboardType: TextInputType.phone,
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
                            color: const Color(0xff090a0a),
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
                              _restorableDatePickerRouteFuture
                                  .present();
                            },
                            child: Text(
                              callDate,
                              style: TextStyle(color: Colors.black, fontSize: screenHeight / 50,),
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
                      const SizedBox(height: 10.0),
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
                        value: callResult,
                        onChanged: (String? newValue) {
                          setState(() {
                            callResult = newValue!;
                          });
                        },
                        items: <String>[
                          'Interested',
                          'Later',
                          'Not-Interested',
                          'Converted'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: screenHeight / 50),
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
                            child: /* StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return */ Switch(
                                value: followUp,
                                onChanged: (bool value) {
                                  setState(() {
                                    followUp = value;
                                  });
                                },
                              ),
                            //}),
                          ),
                        ]),
                      ),
                      SizedBox(height: 40,),
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
                              Container(
                                width: screenWidth,
                                height: screenHeight / 10,
                                padding: EdgeInsets.only(left: 5, right: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Color(0xffe3e4e5)),
                                  color: Color(0xfff0efff),
                                ),
                                child: Row(children: <Widget>[followUp ?
                                    Expanded(child: FollowUpDetailsContainer(
                                        onChanged: (detail) {
                                          /* setState(() {
                                            followUpDetls.add(detail);
                                          }); */
                                        },
                                        followUpDetails : followUpDetls,
                                        followUp: followUp,
                                      ))
                                    : const SizedBox(height: 0.0),
                    ])),
                              
                        const SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                status,
                                style:
                                 TextStyle(color: Colors.red, fontSize: screenHeight / 55),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                      const SizedBox(
                        height: 20.0,
                      ),
                      loading ? CircularProgressIndicator() : SizedBox(
                        height: screenHeight / 15,
                        width: screenWidth,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if(!inDb && callResult == 'Converted') {
                                  showConfirmation(salesExecutive.uid);
                                }
                                if (_formkey.currentState!.validate() && callDate != 'Select Date') {
                                      setState(() {
                                        loading = true;
                                      });
                                      await CallDetailsDatabaseService(docid: '')
                                        .setUserData(
                                          (args.uid == '' ? currentUser?.uid : args.uid)!,
                                          customerName,
                                          customerType,
                                          customerNumber,
                                          callDate,
                                          callResult,
                                          followUp,
                                          followUpDetls,
                                        )
                                        .then((value) => setState(() {
                                          loading = false;
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          Navigator.pop(context);
                                        }));
                                    } else {
                                      setState(() {
                                        loading = false;
                                        status = 'Please fill all the fields';
                                      });
                                    }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff4d47c3),
                              ),
                              child: Container(
                                width: screenWidth / 6,
                                height: screenHeight / 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x664d47c3),
                                      blurRadius: 61,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  color: const Color(0xff4d47c3),
                                ),
                                padding: const EdgeInsets.only(
                                  top: 18,
                                  bottom: 17,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: screenWidth / 6,
                                      child: Text(
                                        "Save",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenHeight / 50,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 65,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff4d47c3),
                              ),
                              child: Container(
                                width: screenWidth / 6,
                                height: screenHeight / 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x664d47c3),
                                      blurRadius: 61,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  color: const Color(0xff4d47c3),
                                ),
                                padding: const EdgeInsets.only(
                                  top: 18,
                                  bottom: 17,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: screenWidth / 6,
                                      child: Text(
                                        "Cancel",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenHeight / 50,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
