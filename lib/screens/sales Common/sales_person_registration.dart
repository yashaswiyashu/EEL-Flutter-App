import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/screens/common/location.dart';
import 'package:flutter_app/screens/sales%20CoOrdinator/sales_co_ordinator_home.dart';
import 'package:flutter_app/screens/sales%20Executive/sales_executive_home.dart';
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
  bool isAdmin = false;

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

  var isDupNum = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    final salesTable = Provider.of<List<SalesPersonModel?>>(context);
    final currentUser = Provider.of<UserModel?>(context);

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
    salesCoOrd.map((e){
      print(e);
    });

    salesTable.forEach((element) {
      if(element?.phoneNumber == phoneNumber){
        setState(() {
          isDupNum = true;
        });
      }
    });

    salesTable.forEach((element) {
      if(element?.phoneNumber == numberController.text){
        setState(() {
          isDupNum = true;
        });
      }
    });

    salesTable.forEach((element) {
      if(currentUser?.uid == element!.uid) {
        if(element.role == 'Admin') {
          setState(() {
            isAdmin = true;
          });
        } 
      }
    });
    print(isDupNum);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Efficient Lights'),
        backgroundColor: const Color(0xff4d47c3),
        actions: currentUser?.uid != null
            ? [
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
              ]
            : null
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Container(
                    width: screenWidth / 3,
                    height: screenHeight / 10,
                    child: Image.asset('assets/logotm.jpg'),
                  ),]
                ),
                const SizedBox(height: 20.0),
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
                  validator: (value) => value!.isEmpty ? 'Missing Field' : null,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Enter Your Name',
                      fillColor: const Color(0xfff0efff)),
                  onChanged: (val) {
                    name = val;
                  },
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
                  validator: (value) {
                  if (value != null && value.length != 10) {
                  return 'Enter a valid 10-digit mobile number';
                  }
                  return null;
                  },
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Enter Your Name',
                      fillColor: const Color(0xfff0efff)),
                  onChanged: (val) {
                    phoneNumber = val;
                    setState(() {
                      isDupNum = false;
                      numError='';
                    });
                    salesTable.forEach((element) {
                      if(element?.phoneNumber == phoneNumber){
                        setState(() {
                          isDupNum = true;
                          numError = "SalesPerson with this number already exists";
                        });
                      }
                    });
                  },
                ),
                isAdmin ? TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      style: TextStyle(fontSize: screenHeight / 50),
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
                          isDupNum = false;// numberController.text = value;
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
                        title: Text(suggestion.phoneNumber, style: TextStyle(fontSize: screenHeight / 50),),
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
        
                ) : const SizedBox(height: 0,),
                SizedBox(child: Text(numError,
                       style: TextStyle(color: Color.fromARGB(190, 193, 2, 2), fontSize: screenHeight / 60),),),
        
        
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
                  validator: (value) => value!.isEmpty ? 'Missing Field' : null,
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Education Details',
                  ),
                  onChanged: (val) {
                    education = val;
                  },
                ),
                role == 'Sales Executive' ? const SizedBox(height: 20.0) : const SizedBox(height: 0,),
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
                    )) : const SizedBox(height: 0,),
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
                        title: Text(suggestion, style: TextStyle(fontSize: screenHeight / 50),),
                      );
                    },
        
                    onSuggestionSelected: (String? suggestion) {
                      if(suggestion == null) {
                        coOrdNameErr = 'Please select a Co-Ordinator from the list';
                      }
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
                coOrdNameErr != '' ? Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    child: Text(
                      coOrdNameErr,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ) : const SizedBox(height: 0,),
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
                SizedBox(
                    height: screenHeight / 40,
                    child: Text(
                      'Email:',
                      style: TextStyle(
                        color: Color(0xff090a0a),
                        fontSize: screenHeight / 50,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                TextFormField(
                  style: TextStyle(fontSize: screenHeight / 50),
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
                  style: TextStyle(fontSize: screenHeight / 50),
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
                  onChanged: (val) {
                    //updateCity(val);
                    setState(() {
                      state = val;
                    });
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  style: TextStyle(fontSize: screenHeight / 50),
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
                  style: TextStyle(color: Colors.red, fontSize: screenHeight / 60),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Container(
                    child: Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: screenHeight / 60,
                      ),
                    ),
                  ),]
                ),
                const SizedBox(
                  height: 20.0,
                ),
                loading
                    ? CircularProgressIndicator()
                    : SizedBox(
                        height: screenHeight / 15,
                        width: screenWidth - 20,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            loading
                                ? const Loading()
                                : ElevatedButton(
                                    onPressed: () async {
                                      if (_formkey.currentState!.validate() && (!(role == 'Sales Executive' && coOrdinatorName.text == '')) && !isDupNum) {
                                        setState(() {
                                          loading = true;
                                          coOrdNameErr = '';
                                          numError = '';
                                          pincodeError = '';
                                        });
                                        var cred;
                                        salesTable.forEach((element) {
                                          if(currentUser?.uid == element!.uid) {
                                            if(element.role == 'Admin') {
                                              cred = element;
                                              setState(() {
                                                isAdmin = true;
                                              });
                                            } 
                                          }
                                        });
                                        AuthCredential? credential;
                                        if(cred != null){
                                          credential =
                                              EmailAuthProvider.credential(
                                            email: cred?.email,
                                            password: cred?.password,
                                          );
                                        }
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
                                                .then((value) async {
                                              setState(() {
                                                loading = false;
                                              });
                                                if(isAdmin){
                                                  if(credential != null) {
                                                    await FirebaseAuth.instance.signOut();
                                                    await FirebaseAuth.instance
                                                        .signInWithCredential(credential);
                                                  Navigator.pop(context);
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                    content: Text('Your account has been registered. Please wait for approval!!'),
                                                  ));
                                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                                      'authWrapper', (Route<dynamic> route) => false);
                                                }

                                                // if(result?.uid == element!.uid) {
                                                //   if(element.role != 'Admin') {
                                                    
                                                //   } else {
                                                    
                                                //   }
                                                // }
                                                
                                            });
                                          }
                                        }
                                      } else {
                                        if (role == 'Sales Executive' && coOrdinatorName.text == '') {
                                          setState(() {
                                            coOrdNameErr = 'Please enter a Co-Ordinator Name';
                                          });
                                        }
        
                                        if (isDupNum) {
                                          setState(() {
                                            numError = 'SalesPerson with this number already exists';
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
