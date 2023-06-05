import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/screens/common/location.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/sales_database.dart';

import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class SalesPersonRegistration extends StatefulWidget {
  const SalesPersonRegistration({super.key});
  static const routeName = '/salesPersonRegistration';

  @override
  State<SalesPersonRegistration> createState() =>
      _SalesPersonRegistrationState();
}

class _SalesPersonRegistrationState extends State<SalesPersonRegistration> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  String numError = '';

  String name = '';
  String education = '';
  String role = 'Sales Executive';
  String adhaarNumber = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
  String address1 = '';
  String address2 = '';
  String city = '';
  String state = 'Select State';
  String pincode = '';
  String pincodeError = '';
  String coOrdNameErr = '';
  String salesCoordId = '';

  String error = '';
  bool _passwordVisible = false;
  late FocusNode myFocusNode;

  final nameController = TextEditingController();
  final coOrdinatorName = TextEditingController();
  final talukController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    myFocusNode = FocusNode();
    nameController.addListener(_nameLatestValue);
    coOrdinatorName.addListener(_coOrdinatorName);
    cityController.addListener(_cityLatestValue);
    talukController.addListener(_talukLatestValue);
    stateController.addListener(_stateLatestValue);
    numberController.addListener(_numberLatestValue);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    nameController.dispose();
    coOrdinatorName.dispose();
    cityController.dispose();
    stateController.dispose();
    talukController.dispose();
    numberController.dispose();
    super.dispose();
  }

  void _cityLatestValue() {
    print('Viru:: ${cityController.text}');
  }

  void _stateLatestValue() {
    print('Viru:: ${stateController.text}');
  }

  void _talukLatestValue() {
    print('Viru:: ${talukController.text}');
  }

  void _nameLatestValue() {
    print('Viru:: ${nameController.text}');
  }

  void _coOrdinatorName() {
    print('Viru:: ${coOrdinatorName.text}');
  }

  void _numberLatestValue() {
    phoneNumber = numberController.text;
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
        nameController.text = loc.name;
        address2 = loc.taluk;
        talukController.text = loc.taluk;

      });
      return true;
    } else {
      return false;
    }
   /*  print("Viru: $city");
    print("Viru: $state");
    print("Viru: $address1");
    print("Viru: $address2"); */
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    final salesTable = Provider.of<List<SalesPersonModel?>>(context);
    List<String> salesCoOrd = [];
    setState(() {
      role = args;
    });

        //[Viru:2/6/23] Added to support customer mob search list
    List<SalesPersonModel?> details = [];
    salesTable.forEach((e) => details.add(e));

    salesTable.forEach((element) {
      if(element!.name == coOrdinatorName.text) {
        salesCoordId = element.uid;
      }
    });

    if(salesTable != null) {
      salesTable.forEach((e) {
        if(e!.role == 'Sales Co-Ordinator'){
          salesCoOrd.add(e.name);
        }
      });
    }

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
                validator: (value) => value!.isEmpty ? 'Missing Field' : null,
                decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Your Name',
                    fillColor: const Color(0xfff0efff)),
                onChanged: (val) {
                  name = val;
                },
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

              TypeAheadFormField(
                  
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: numberController,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Enter Phone Number',
                      fillColor: const Color(0xfff0efff),
                    ),
                    inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow numerical values
                    ],
                    onChanged: (value) {
                      setState(() {
                        numError = ''; // Clear the error message
                        // numberController.text = value;
                      });
                    },
                  ),

                  suggestionsCallback: (pattern) async {
                    // Filter the customer list based on the search pattern
                    return details
                    .where((salesPerson) =>
                    salesPerson != null &&
                    salesPerson.phoneNumber.contains(pattern))
                    .toList();
                  },

                  itemBuilder: (context, SalesPersonModel? suggestion) {
                    if (suggestion == null) return const SizedBox.shrink();
                    return ListTile(
                      title: Text(suggestion.phoneNumber),
                    );
                  },

                  onSuggestionSelected: (SalesPersonModel? suggestion) {
                    if (suggestion != null) {
                      setState(() {
                        numError = 'SalesPerson with this number already exists';
                        numberController.clear();
                      });
                    } else {
                      numberController.text.length != 10 ? 'Enter Phone Number' : null;
                      setState(() {
                        numError = '';
                      });
                    }
                },
                validator: (value) {
                if (value != null && value.length != 10) {
                return 'Enter a valid 10-digit mobile number';
                }
                return null;
                },
                onSaved: (value) {
                setState(() {
                numError = ''; // Clear the error message
                });
              },

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
                validator: (value) => value!.isEmpty ? 'Missing Field' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Education Details',
                ),
                onChanged: (val) {
                  education = val;
                },
              ),
              role == 'Sales Executive' ? const SizedBox(height: 20.0) : const SizedBox(height: 0,),
              role == 'Sales Executive' ? const SizedBox(
                  height: 20.0,
                  child: Text(
                    'Sales Co-Ordinator:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )) : const SizedBox(height: 0,),
              role == 'Sales Executive' ? SizedBox(
                child: TypeAheadFormField(
                  
                  textFieldConfiguration: TextFieldConfiguration(
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
              ) : const SizedBox(height: 0,),
              Container(
                child: Text(
                  coOrdNameErr,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13.0,
                  ),
                ),
              ),
              //const SizedBox(height: 20.0),
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
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.length == 12 ? null : 'Enter valid Aadhar number',
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Your Adhaar Number',
                ),
                onChanged: (val) {
                  adhaarNumber = val;
                },
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
                focusNode: myFocusNode,
                validator: (value) =>
                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!)
                        ? null
                        : 'Missing Field',
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Your Email',
                ),
                onChanged: (val) {
                  email = val;
                },
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
                onChanged: (val) {
                  password = val;
                },
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
                controller: nameController,
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
                controller: talukController,
                validator: (value) =>
                    value!.isEmpty ? 'Missing address field' : null,
                decoration: textInputDecoration.copyWith(hintText: 'talluk'),
                onChanged: (val) {
                  address2 = val;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
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
                controller: stateController,
                decoration: textInputDecoration.copyWith(hintText: 'state'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter Customer Full Address' : null,
                onChanged: (val) {
                  //updateCity(val);
                  setState(() {
                    state = val;
                  });
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    RegExp(r'^\d+$').hasMatch(pincode) && pincode.length == 6
                        ? null
                        : 'Enter Valid pincode',
                decoration: textInputDecoration.copyWith(hintText: 'pincode'),
                onChanged: (val) {
                  setState(() {
                    pincode = val;
                  });
                  if (pincode.length == 6) {
                    updateAddressFields().then((value) {
                      if(!value) {
                        setState(() {
                          pincodeError = 'Please enter valid pincode';
                        });
                      }
                    });
                  }
                },
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
                          loading
                              ? const Loading()
                              : ElevatedButton(
                                  onPressed: () async {
                                    if (_formkey.currentState!.validate() && (!(role == 'Sales Executive' && coOrdinatorName.text == ''))) {
                                      setState(() {
                                        loading = true;
                                        coOrdNameErr = '';
                                      });
                                      dynamic result = await _auth
                                          .registerWithEmailAndPassword(
                                              email, password);
                                      if (result == null) {
                                        setState(() {
                                          error = 'please supply a valid email';
                                          loading = false;
                                        });
                                        showConfirmation();
                                      } else {
                                        if (result?.uid != null) {
                                          await SalesPersonDatabase(docid: '')
                                              .setUserData(
                                                  result?.uid,
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
                                                  false)
                                              .then((value) {
                                            setState(() {
                                              loading = false;
                                            });
                                            Navigator.pushNamed(
                                                context, 'authWrapper');
                                          });
                                        }
                                      }
                                    } else {
                                      if (role == 'Sales Executive' && coOrdinatorName.text == '') {
                                        setState(() {
                                          coOrdNameErr = 'Please enter a Co-Ordinator Name';
                                        });
                                      }
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        SizedBox(
                                          width: 90,
                                          child: Text(
                                            "Register",
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
