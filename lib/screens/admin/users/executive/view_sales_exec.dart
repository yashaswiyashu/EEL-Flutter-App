import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/screens/common/location.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/sales_database.dart';

import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class ViewExecutiveDetails extends StatefulWidget {
  const ViewExecutiveDetails({super.key});
  static const routeName = '/ViewExecutiveDetails';

  @override
  State<ViewExecutiveDetails> createState() =>
      _ViewExecutiveDetailsState();
}

class _ViewExecutiveDetailsState extends State<ViewExecutiveDetails> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  String numError = '';
  bool approve = false;

  String name = '';
  String education = '';
  String role = '';
  String adhaarNumber = '';
  String phoneNumber = '';
  String email = '';
  String prevEmail = '';
  String password = '';
  String prevPassword = '';
  String address1 = '';
  String address2 = '';
  String city = '';
  String state = 'Select State';
  String pincode = '';
  String pincodeError = '';
  String coOrdNameErr = '';
  String salesCoordId = '';
  bool authCredEdited = false;
  String coOrdName = '';

  bool firstTime = true;

  String error = '';
  bool _passwordVisible = false;
  late FocusNode myFocusNode;


  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
  }

  var snackBar = SnackBar(
    content: Text('Registered Successfully!!!'),
  );

  void showConfirmation() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Please enter valid email.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, true), // passing true
                child: Text('Ok'),
              ),
            ],
          );
        }).then((exit) {
      if (exit) {
        // user pressed Yes button
        myFocusNode.requestFocus();
        return;
      }
    });
  }

Future<bool> updateAddressFields() async {
    Location? loc = await getLocation(pincode);
    
    if(loc != null){
      setState(() {
        city = loc.district;
        state = loc.state;
        address1 = loc.name;
        address2 = loc.taluk;
      });
      return true;
    } else {
      return false;
    }
  }

  void fillFields(SalesPersonModel salesCoOrd) {
    setState(() {
      name = salesCoOrd.name;
      phoneNumber = salesCoOrd.phoneNumber;
      education= salesCoOrd.education;
      role = salesCoOrd.role;
      salesCoordId = salesCoOrd.coOrdinatorId;
      adhaarNumber = salesCoOrd.adhaarNumber;
      email = salesCoOrd.email;
      password = salesCoOrd.password;
      address1 = salesCoOrd.address1;
      address2 = salesCoOrd.address2;
      city = salesCoOrd.district;
      state = salesCoOrd.state;
      pincode = salesCoOrd.pincode;
      approve = salesCoOrd.approved;
    });

  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Parameter;
    final salesTable = Provider.of<List<SalesPersonModel?>>(context);

        //[Viru:2/6/23] Added to support customer mob search list
    List<SalesPersonModel?> details = [];
    salesTable.forEach((e) => details.add(e));


    if(firstTime) {
      setState(() {
        firstTime = false;
      });
      salesTable.forEach((e) {
        if(e!.role == 'Sales Executive' && e.uid == args.uid){
          fillFields(e);
        }
      });
    }

    salesTable.forEach((e) {
      if(e?.uid == salesCoordId) {
        coOrdName = e!.name;
      } 
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Efficient Lights'),
        backgroundColor: const Color(0xff4d47c3),
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
              Container(
                margin: const EdgeInsets.only(left: 75),
                width: 180,
                height: 60,
                child: Image.asset('assets/logotm.jpg'),
              ),
              const SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                        const SizedBox(
                            height: 20.0,
                            child: Text(
                              'Approve Co-Ordinator:',
                              style: TextStyle(
                                color: Color(0xff090a0a),
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          width: 27.46,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 254, 254),
                          ),
                          child: StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Switch(
                              value: approve,
                              onChanged: (bool value) {
                                // setState(() {
                                //   approve = value;
                                // });
                              },
                            );
                          }),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 10.0),
              const SizedBox(
                height: 20.0,
                child: Text(
                  "Name:",
                  style: TextStyle(
                    color: Color(0xff090a0a),
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextFormField(
                initialValue: name,
                readOnly: true,
                validator: (value) => value!.isEmpty ? 'Missing Field' : null,
                decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Your Name',
                    fillColor: const Color(0xfff0efff)),
                // onChanged: (val) {
                //   name = val;
                // },
              ),
              const SizedBox(height: 20.0),
              const SizedBox(
                  height: 20.0,
                  child: Text(
                    'Phone Number:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),

              TextFormField(
                initialValue: phoneNumber,
                readOnly: true,
                validator: (value) => value!.isEmpty ? 'Missing Field' : null,
                decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Your Number',
                    fillColor: const Color(0xfff0efff)),
                // onChanged: (val) {
                //   name = val;
                // },
              ),
              SizedBox(child: Text(numError,
                     style: TextStyle(color: Color.fromARGB(190, 193, 2, 2),),),),


              const SizedBox(
                  height: 20.0,
                  child: Text(
                    'Education:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              TextFormField(
                initialValue:  education,
                readOnly: true,
                validator: (value) => value!.isEmpty ? 'Missing Field' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Education Details',
                ),
                // onChanged: (val) {
                //   education = val;
                // },
              ),
              const SizedBox(height: 20.0),
              const SizedBox(
                  height: 20.0,
                  child: Text(
                    'Sales Co-Ordinator:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                  TextFormField(
                initialValue:  coOrdName,
                readOnly: true,
                validator: (value) => value!.isEmpty ? 'Missing Field' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Education Details',
                ),
                // onChanged: (val) {
                //   education = val;
                // },
              ),
              const SizedBox(height: 20.0),
              const SizedBox(
                  height: 20.0,
                  child: Text(
                    'Adhaar Number:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              TextFormField(
                initialValue: adhaarNumber,
                readOnly: true,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.length == 12 ? null : 'Enter valid Aadhar number',
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Your Adhaar Number',
                ),
                // onChanged: (val) {
                //   adhaarNumber = val;
                // },
              ),
              const SizedBox(height: 20.0),
/*               const SizedBox(
                  height: 20.0,
                  child: Text(
                    'Phone Number:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
 */              /* TextFormField(
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.length == 10 ? null : 'Enter valid number',
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Phone Number',
                ),
                onChanged: (val) {
                  phoneNumber = val;
                },
              ), */

              //const SizedBox(height: 20.0),
              const SizedBox(
                  height: 20.0,
                  child: Text(
                    'Email:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              TextFormField(
                initialValue: email,
                readOnly: true,
                focusNode: myFocusNode,
                validator: (value) =>
                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!)
                        ? null
                        : 'Missing Field',
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Your Email',
                ),
                // onChanged: (val) {
                //   setState(() {
                //     authCredEdited = true;
                //   });
                // },
              ),
              const SizedBox(height: 20.0),
              const SizedBox(
                  height: 20.0,
                  child: Text(
                    'Password:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              TextFormField(
                initialValue: password,
                readOnly: true,
                validator: (value) => value!.length < 6
                    ? 'Enter a password of more than 6 characters'
                    : null,
                keyboardType: TextInputType.text,
                obscureText: !_passwordVisible,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                // onChanged: (val) {
                //   setState(() {
                //     authCredEdited = true;
                //   });
                // },
              ),
              const SizedBox(height: 20.0),
              const SizedBox(
                  height: 20.0,
                  child: Text(
                    'Full Address:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              TextFormField(
                initialValue: address1,
                readOnly: true,
                validator: (value) =>
                    value!.isEmpty ? 'Missing address field' : null,
                decoration: textInputDecoration.copyWith(
                    hintText:
                        'Please enter the pincode to autofill postal address'),
                // onChanged: (val) {
                //   address1 = val;
                // },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: address2,
                readOnly: true,
                validator: (value) =>
                    value!.isEmpty ? 'Missing address field' : null,
                decoration: textInputDecoration.copyWith(hintText: 'talluk'),
                // onChanged: (val) {
                //   address2 = val;
                // },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: city,
                readOnly: true,
                validator: (value) =>
                    value!.isEmpty ? 'Enter valid city' : null,
                decoration: textInputDecoration.copyWith(hintText: 'District'),
                // onChanged: (val) {
                //   city = val;
                // },
              ),
              const SizedBox(height: 10.0),
              // DropdownButtonFormField(
              //     decoration: const InputDecoration(
              //       enabledBorder: OutlineInputBorder(
              //         //<-- SEE HERE
              //         borderSide:
              //             BorderSide(color: Colors.black, width: 0),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         //<-- SEE HERE
              //         borderSide:
              //             BorderSide(color: Colors.black, width: 2),
              //       ),
              //       filled: true,
              //       fillColor: Color(0xffefefff),
              //     ),
              //     dropdownColor: const Color(0xffefefff),
              //     value: state,
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         state = newValue!;
              //       });
              //     },
              //     items: <String>[
              //       'Select State',
              //       'Karnataka',
              //       'Kerala',
              //       'Tamil Nadu',
              //       'Andra Pradesh'
              //     ].map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(
              //           value,
              //           style: const TextStyle(fontSize: 18),
              //         ),
              //       );
              //     }).toList(),
              //   ),
              TextFormField(
                initialValue: state,
                readOnly: true,
                decoration: textInputDecoration.copyWith(hintText: 'state'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter Customer Full Address' : null,
                // onChanged: (val) {
                //   //updateCity(val);
                //   setState(() {
                //     state = val;
                //   });
                // },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: pincode,
                readOnly: true,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    RegExp(r'^\d+$').hasMatch(pincode) && pincode.length == 6
                        ? null
                        : 'Enter Valid pincode',
                decoration: textInputDecoration.copyWith(hintText: 'pincode'),
                // onChanged: (val) {
                //   setState(() {
                //     pincode = val;
                //   });
                //   // if (pincode.length == 6) {
                //   //   updateAddressFields().then((value) {
                //   //     if(!value) {
                //   //       setState(() {
                //   //         pincodeError = 'Please enter valid pincode';
                //   //       });
                //   //     }
                //   //   });
                //   // }
                // },
              ),
              const SizedBox(height: 12.0),
              Text(
                pincodeError,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              const SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(left: 120),
                child: Text(
                  error,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                      height: 59,
                      width: 420,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
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
                                      "Back",
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
