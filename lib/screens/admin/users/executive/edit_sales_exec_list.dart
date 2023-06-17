import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/screens/common/location.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/sales_database.dart';

import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class EditSalesExecutiveDetails extends StatefulWidget {
  const EditSalesExecutiveDetails({super.key});
  static const routeName = '/EditSalesExecutiveDetails';

  @override
  State<EditSalesExecutiveDetails> createState() =>
      _EditSalesExecutiveDetailsState();
}

class _EditSalesExecutiveDetailsState extends State<EditSalesExecutiveDetails> {
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

  bool firstTime = true;

  String error = '';
  bool _passwordVisible = false;
  late FocusNode myFocusNode;

  final nameController = TextEditingController();
  final educationController = TextEditingController();  
  final aadharController = TextEditingController();  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final coOrdinatorName = TextEditingController();
  final address1Controller = TextEditingController();
  final talukController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final numberController = TextEditingController();
  final pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    myFocusNode = FocusNode();
    nameController.addListener(_nameLatestValue);
    educationController.addListener(_educationValue);
    aadharController.addListener(_aadharValue);
    emailController.addListener(_emailValue);
    passwordController.addListener(_passwordValue);
    coOrdinatorName.addListener(_coOrdinatorName);
    address1Controller.addListener(_address1Value);
    cityController.addListener(_cityLatestValue);
    talukController.addListener(_talukLatestValue);
    stateController.addListener(_stateLatestValue);
    numberController.addListener(_numberLatestValue);
    pincodeController.addListener(_pincodeValue);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    nameController.dispose();
    educationController.dispose();
    aadharController.dispose();
    emailController.dispose();
    passwordController.dispose();
    coOrdinatorName.dispose();
    address1Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    talukController.dispose();
    numberController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  void _cityLatestValue() {
    city = cityController.text;
  }

  void _educationValue() {
    education = educationController.text;
  }

  void _aadharValue() {
    adhaarNumber = aadharController.text;
  }

  void _emailValue() {
    email = emailController.text;
  }

  void _passwordValue() {
    password = passwordController.text;
  }

  void _stateLatestValue() {
    state = stateController.text;
  }

  void _talukLatestValue() {
    address2 = talukController.text;
  }

  void _nameLatestValue() {
    name = nameController.text;
  }

  void _coOrdinatorName() {
    print(coOrdinatorName.text);
  }

  void _address1Value() {
    address1 = address1Controller.text;
  }

  void _numberLatestValue() {
    phoneNumber = numberController.text;
  }

  void _pincodeValue() {
    pincode = pincodeController.text;
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
        cityController.text = loc.district;
        state = loc.state;
        stateController.text = loc.state;
        address1 = loc.name;
        address1Controller.text = loc.name;
        address2 = loc.taluk;
        talukController.text = loc.taluk;

      });
      return true;
    } else {
      return false;
    }
  }

  void fillFields(SalesPersonModel salesCoOrd) {
    setState(() {
      nameController.text = salesCoOrd.name;
      numberController.text = salesCoOrd.phoneNumber;
      educationController.text = salesCoOrd.education;
      role = salesCoOrd.role;
      salesCoordId = salesCoOrd.coOrdinatorId;
      aadharController.text = salesCoOrd.adhaarNumber;
      emailController.text = salesCoOrd.email;
      prevEmail = salesCoOrd.email;
      passwordController.text = salesCoOrd.password;
      prevPassword = salesCoOrd.password;
      address1Controller.text = salesCoOrd.address1;
      talukController.text = salesCoOrd.address2;
      cityController.text = salesCoOrd.district;
      stateController.text = salesCoOrd.state;
      pincodeController.text = salesCoOrd.pincode;
      approve = salesCoOrd.approved;
    });

  }

  void confirmDeletion(String uid) {
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
        SalesPersonDatabase(docid: uid).deleteUserData();
        Navigator.pop(context);
      } else {
        // user pressed No button
        // Navigator.pop(context);
        return;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    if(prevEmail != email || prevPassword != password) {
      setState(() {
        authCredEdited = true;
      });
    }
    final args = ModalRoute.of(context)!.settings.arguments as Parameter;
    final salesTable = Provider.of<List<SalesPersonModel?>>(context);

        //[Viru:2/6/23] Added to support customer mob search list
    List<SalesPersonModel?> details = [];
    List<String> salesCoOrd = [];

    salesTable.forEach((e) => details.add(e));

    salesTable.forEach((element) {
      if(element!.name == coOrdinatorName.text) {
        salesCoordId = element.uid;
      }
    });

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

    if(salesTable != null) {
      salesTable.forEach((e) {
        if(e!.role == 'Sales Co-Ordinator'){
          salesCoOrd.add(e.name);
        }
      });
    }

    if(salesTable != null) {
      salesTable.forEach((e) {
        if(e!.uid == salesCoordId){
          coOrdinatorName.text = e.name;
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
                      Navigator.of(context).pushNamedAndRemoveUntil('authWrapper',(Route<dynamic> route) => false);
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
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                              width: screenWidth / 3,
                              height: screenHeight / 10,
                    child: Image.asset('assets/logotm.jpg'),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(right: screenWidth / 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                         SizedBox(
                            height: screenHeight / 40,
                            child: Text(
                              'Approve Co-Ordinator:',
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
                              value: approve,
                              onChanged: (bool value) {
                                setState(() {
                                  approve = value;
                                });
                              },
                            );
                          }),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 10.0),
               SizedBox(
                height: screenHeight / 40,
                child: Text(
                  "Name:",
                  style: TextStyle(
                    color: Color(0xff090a0a),
                    fontSize: screenHeight / 50,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextFormField(
                style: TextStyle(fontSize: screenHeight / 50),
                controller: nameController,
                validator: (value) => value!.isEmpty ? 'Missing Field' : null,
                decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Your Name',
                    fillColor: const Color(0xfff0efff)),
                // onChanged: (val) {
                //   name = val;
                // },
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                  height: screenHeight / 40,
                  child: Text(
                    'Phone Number:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: screenHeight / 50,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),

              TextFormField(
                style: TextStyle(fontSize: screenHeight / 50),
                controller: numberController,
                validator: (value) => value!.isEmpty ? 'Missing Field' : null,
                decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Your Number',
                    fillColor: const Color(0xfff0efff)),
                // onChanged: (val) {
                //   name = val;
                // },
              ),
              SizedBox(child: Text(numError,
                     style: TextStyle(color: Color.fromARGB(190, 193, 2, 2), fontSize: screenHeight / 60,),),),


             SizedBox(
                  height: screenHeight / 40,
                  child: Text(
                    'Education:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: screenHeight / 50,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              TextFormField(
                style: TextStyle(fontSize: screenHeight / 50),
                controller: educationController,
                validator: (value) => value!.isEmpty ? 'Missing Field' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Education Details',
                ),
                // onChanged: (val) {
                //   education = val;
                // },
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                  height: screenHeight / 40,
                  child: Text(
                    'Role:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: screenHeight / 50,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                  Container(
                    height: screenHeight / 15,
                    width: screenWidth,
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
                        value: role,
                        onChanged: (String? newValue) {
                          setState(() {
                            role = newValue!;
                          });
                        },
                        items: <String>[
                          'Sales Executive',
                          'Sales Co-Ordinator'
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
                  ),
              // role == 'Sales Executive' ? const SizedBox(height: 20.0) : const SizedBox(width: 0, height: 0,),
              role == 'Sales Executive' ? SizedBox(
                  height: screenHeight / 40,
                  child: Text(
                    'Sales Co-Ordinator:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: screenHeight / 50,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )) : const SizedBox(width: 0, height: 0,),
              role == 'Sales Executive' ? SizedBox(
                child: TypeAheadFormField(
                  
                  textFieldConfiguration: TextFieldConfiguration(
                    style: TextStyle(fontSize: screenHeight / 50),
                    controller: coOrdinatorName,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Enter Co-ordinator Name',
                      fillColor: const Color(0xfff0efff),
                    ),
                    /* onChanged: (val) {
                      customerName = val;
                    }, */
                  ),

                  suggestionsCallback: (pattern) async {
                    // Filter the customer list based on the search pattern
                    return salesCoOrd
                    .where((customer) =>
                    customer != null &&
                    customer.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
                  },

                  itemBuilder: (context, String? suggestion) {
                    if (suggestion == null) return const SizedBox.shrink();
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },

                  onSuggestionSelected: (String? suggestion) {
                    if (suggestion != null) {
                      setState(() {
                        //customerName = suggestion.customerName;
                        coOrdinatorName.text = suggestion;
                        coOrdNameErr = '';
                    });
                  }
              },
            ),
              ) : const SizedBox(width: 0, height: 0,),
              const SizedBox(height: 20.0),
               SizedBox(
                  height: screenHeight / 40,
                  child: Text(
                    'Adhaar Number:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: screenHeight / 50,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              TextFormField(
                style: TextStyle(fontSize: screenHeight / 50),
                controller: aadharController,
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
               SizedBox(
                  height: screenHeight / 40,
                  child: Text(
                    'Email:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: screenHeight/ 50,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              TextFormField(
                style: TextStyle(fontSize: screenHeight / 50),
                controller: emailController,
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
              SizedBox(
                  height: screenHeight / 40,
                  child: Text(
                    'Password:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: screenHeight / 50,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              TextFormField(
                style: TextStyle(fontSize: screenHeight / 50),
                controller: passwordController,
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
              SizedBox(
                  height: screenHeight / 40,
                  child: Text(
                    'Full Address:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: screenHeight / 50,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              TextFormField(
                style: TextStyle(fontSize: screenHeight / 50),
                controller: address1Controller,
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
                style: TextStyle(fontSize: screenHeight / 50),
                controller: talukController,
                validator: (value) =>
                    value!.isEmpty ? 'Missing address field' : null,
                decoration: textInputDecoration.copyWith(hintText: 'talluk'),
                // onChanged: (val) {
                //   address2 = val;
                // },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                style: TextStyle(fontSize: screenHeight / 50),
                controller: cityController,
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
                style: TextStyle(fontSize: screenHeight / 50),
                controller: stateController,
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
                style: TextStyle(fontSize: screenHeight / 50),
                controller: pincodeController,
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
                style: TextStyle(color: Colors.red, fontSize: screenHeight / 60),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: screenHeight / 60,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              loading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: screenHeight / 15,
                      width: screenWidth,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          loading
                              ? const Loading()
                              : ElevatedButton(
                                  onPressed: () async {
                                    if(role == 'Sales Co-Ordinator') {
                                      setState(() {
                                        coOrdinatorName.text = '';
                                        salesCoordId = '';
                                      });
                                    }
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        loading = true;
                                        coOrdNameErr = '';
                                      });
                                      
                                      if(authCredEdited) {
                                        dynamic result = await _auth.updateEmailAndPassword(args.uid, email, password);
                                        // dynamic result = '';
                                        if (!result) {
                                          setState(() {
                                            error = 'Failed to update Email and Password';
                                            loading = false;
                                          });
                                        } else {
                                        if (result) {
                                          await SalesPersonDatabase(docid: args.uid)
                                              .updateUserData(
                                                  name,
                                                  education,
                                                  role,
                                                  salesCoordId,
                                                  adhaarNumber,
                                                  phoneNumber,
                                                  email,
                                                  password,
                                                  address1,
                                                  address2,
                                                  city,
                                                  state,
                                                  pincode,
                                                  approve
                                                  )
                                              .then((value) {
                                            setState(() {
                                              loading = false;
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text('Executive Details Updated Successfully!!!'),
                                              ));
                                              Navigator.pop(context);
                                          });
                                        }
                                      }
                                      } else {
                                        await SalesPersonDatabase(docid: args.uid)
                                              .updateUserData(
                                                  name,
                                                  education,
                                                  role,
                                                  salesCoordId,
                                                  adhaarNumber,
                                                  phoneNumber,
                                                  email,
                                                  password,
                                                  address1,
                                                  address2,
                                                  city,
                                                  state,
                                                  pincode,
                                                  approve
                                                  )
                                              .then((value) {
                                            setState(() {
                                              loading = false;
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text('Executive Details Updated Successfully!!!'),
                                              ));
                                              Navigator.pop(context);
                                          });
                                      } 
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: screenWidth / 6,
                                          child: Text(
                                            "Register",
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
                          ElevatedButton(
                              // autogroupqdj5BoM (UPthV8mGmAE7wuU648qDj5)
                              onPressed: () {
                                confirmDeletion(args.uid);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Container(
                                width: screenWidth / 6,
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
    );
  }
}
