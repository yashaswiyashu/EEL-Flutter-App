import 'package:flutter/material.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/complaint_details_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/screens/sales%20Executive/customer%20Details/add_new_customer.dart';
import 'package:flutter_app/screens/sales%20Executive/customer%20Details/customer_list_view.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/customer_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/services/sales_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';

import 'complaint_container.dart';

import 'package:flutter_app/services/complaint_details_database.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddNewComplaint extends StatefulWidget {
  const AddNewComplaint({super.key, this.restorationId});
  final String? restorationId;
  static const routeName = '/addComplaintDetails';

  @override
  State<AddNewComplaint> createState() => _AddNewComplaintState();
}


class _AddNewComplaintState extends State<AddNewComplaint>
    with RestorationMixin {
  final _formkey = GlobalKey<FormState>();
final AuthService _auth = AuthService();

  bool loading = false;


  String customerName = '';
  String customerNumber = '';
  String complaintDate = 'Select Date';
  String complaintResult = 'Open';
  //String complaintDetails = '';
  String error = '';
  String status = '';
  String nameErr = '';
  final numberController = TextEditingController();
  final nameController = TextEditingController();
  List<ComplaintDetail> complaintDetls = [];

  @override
  String? get restorationId => widget.restorationId;


  void initState() {
    numberController.addListener(_numberLatestValue);
    nameController.addListener(_nameLatestValue);
  }

@override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    numberController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _numberLatestValue() {
    customerNumber = numberController.text;
    //print('Viru:: ${numberController.text}');
  }

  void _nameLatestValue() {
    customerName = nameController.text;
    //print('Viru:: ${numberController.text}');
  }

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
          firstDate: DateTime(2022),
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
        complaintDate =
            '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
      });
    }
  }


  var salesExecutive;
  var isCust = false;

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
    //[Viru:27/5/23] Added to support customer name search list
    //final customerList = Provider.of<List<CustomerModel>>(context);
    List<CustomerModel> details = [];
    final args = ModalRoute.of(context)!.settings.arguments as Parameter;
    final currentUser = Provider.of<UserModel?>(context);
    final salesTable = Provider.of<List<SalesPersonModel?>>(context);
    final complaintDetailsList = Provider.of<List<ComplaintDetailsModel>>(context);
    var InDb = false;
    var isDupName = false;
    
    if (salesTable != null && args.uid == '') {
      salesTable.forEach((element) {
        if (element?.uid == currentUser?.uid) {
          salesExecutive = element;
        }
      });
    } else {
      salesTable.forEach((element) {
        if (element?.uid == args.uid) {
          salesExecutive = element;
        }
      });
    }


    //[Viru:27/5/23] Added to support customer name search list
    final customerList = Provider.of<List<CustomerModel>>(context);
    if(args.uid == '') {
      customerList.forEach((e) => e.uid == currentUser?.uid ? details.add(e) : []);
    } else {
      customerList.forEach((e) => e.salesExecutiveId == args.uid ? details.add(e) : []);
    }

    customerList.forEach((element) {
      if(element.customerName == customerName) {
        setState(() {
          // nameErr = '';
          InDb = true;
        });
      }
    });

    complaintDetailsList.forEach((e) {
      if(e.customerName == customerName && e.complaintResult != 'Closed') {
        setState(() {
          // nameErr = '';
          isDupName = true;
        });
      }
    });

    customerList.forEach((element) {
      if(element.uid == currentUser?.uid) {
        setState(() {
          isCust = true;
        });
      }
    });

    customerList.forEach((element) {
      if(element.uid == currentUser?.uid) {
        customerName = element.customerName;
        customerNumber = element.mobileNumber;
      }
    });

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
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              !isCust ? Container(
                padding: EdgeInsets.only(right: 15, top: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(
                    'Name: ${salesExecutive.name}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ) : const SizedBox(height: 0.0),
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
                validator: (value) => value!.isEmpty ? 'Missing Field' : null,
                decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Customer Name',
                    fillColor: const Color(0xfff0efff)),
                onChanged: (val) {
                  customerName = val;
                },
              ),
 
              //[Viru:27/5/23] Added to support customer name search list
            //     TypeAheadFormField(
                  
            //       textFieldConfiguration: TextFieldConfiguration(
            //         controller: nameController,
            //         decoration: textInputDecoration.copyWith(
            //           hintText: 'Enter Customer Name',
            //           fillColor: const Color(0xfff0efff),
            //         ),
            //         onChanged: (val) {
            //           setState(() {
            //             nameErr = '';
            //           });
            //         }, 
            //       ),

            //       suggestionsCallback: (pattern) async {
            //         // Filter the customer list based on the search pattern
        
            //         return details
            //         .where((customer) =>
            //         customer != null &&
            //         customer.customerName.toLowerCase().contains(pattern.toLowerCase()))
            //         .toList();
            //       },

            //       itemBuilder: (context, CustomerModel? suggestion) {
            //         if (suggestion == null) return const SizedBox.shrink();
            //         return ListTile(
            //           title: Text(suggestion.customerName),
            //         );
            //       },

            //       onSuggestionSelected: (CustomerModel? suggestion) {
            //         if (suggestion != null) {
            //           setState(() {
            //             //customerName = suggestion.customerName;
            //             nameController.text = suggestion.customerName;
            //             numberController.text = suggestion.mobileNumber;
            //         });
            //       }
            //   },

            // ),
            const SizedBox(height: 5.0),
              Container(
                child: Text(
                  nameErr,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ),

              const SizedBox(height: 10.0),
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
                initialValue: customerNumber,
                readOnly: true,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.length == 10 ? null : 'Enter valid number',
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Customer Mobile Number',
                ),
                /* onChanged: (val) {
                  customerNumber = val;
                }, */
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
                      _restorableDatePickerRouteFuture.present();
                    },
                    child: Text(
                      complaintDate,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
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
                value: complaintResult,
                onChanged: (String? newValue) {
                  setState(() {
                    complaintResult = newValue!;
                  });
                },
                items: <String>[
                  'Open',
                  'ReOpen',
                  'Closed',
                  'In Process'
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
              Container(
                              width: 440,
                              height: 83,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Color(0xffe3e4e5)),
                                color: Color(0xfff0efff),
                              ),
                              child: Row(children: <Widget>[
                                  Expanded(child: ComplaintDetailsContainer(
                                      onChanged: (detail) {
                                        print("Viru: "+ detail.details);
                                        /* setState(() {
                                          complaintDetls.add(detail);
                                        }); */
                                      },
                                      complaintDetails : complaintDetls,
                                    ))
                                  ,
                  ])),
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
              ),
              loading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: 59,
                      width: 420,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                nameErr = '';
                              });
                              if(isDupName) {
                                setState(() {
                                  nameErr = 'Entered customer complaint already exists. Please edit existing complaint';
                                });
                              } 
                              if(!InDb) {
                                showConfirmation(salesExecutive.uid);
                              }
                              if (_formkey.currentState!.validate() &&
                                  complaintDate != 'Select Date' && nameErr == '') {
                                setState(() {
                                  loading = true;
                                });
                                await ComplaintDetailsDatabaseService(docid: '')
                                    .setUserData(
                                  (args.uid == '' ? currentUser?.uid : args.uid)!,
                                  customerName,
                                  customerNumber,
                                  complaintDate,
                                  complaintResult,
                                  complaintDetls,
                                )
                                    .then((value) => setState(() {
                                    loading = false;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Compliaint Details added Successfully!!!'),
                                    ));
                                  
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
                              width: 100,
                              height: 59,
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
                                children: const [
                                  SizedBox(
                                    width: 90,
                                    child: Text(
                                      "Save",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
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
                              width: 100,
                              height: 59,
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
                                children: const [
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      "Cancel",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
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
    );
  }
}
