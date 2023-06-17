import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/edit_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/screens/common/location.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/customer_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';


class ViewCustomerAdmin extends StatefulWidget {
  const ViewCustomerAdmin({super.key});
  static const routeName = '/ViewCustomerAdmin';

  @override
  State<ViewCustomerAdmin> createState() => _ViewCustomerAdminState();
}

class _ViewCustomerAdminState extends State<ViewCustomerAdmin> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  String numError = '';
  String dropdownInt1 = 'Suraksha';
  String dropdownInt2 = 'Suraksha';
  String dropdownInt3 = 'Suraksha';
  String dropdownInt4 = 'Suraksha';
  String dropdownUses1 = 'House';
  String dropdownUses2 = 'House';
  String dropdownUses3 = 'House';
  String dropdownUses4 = 'House';

  // text field state
  String customerName = '';
  String mobileNumber = '';
  String email = '';
  String prevEmail = '';
  String password = '';
  String prevPassword = '';
  String address1 = '';
  String address2 = '';
  String city = '';
  String state = '';
  String pincode = '';
  String pincodeError = '';
  bool authCredEdited = false;
  bool firstTime = true;
  String error = '';
  bool _passwordVisible = false;

  final custNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final address1Controller = TextEditingController();
  final talukController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final numberController = TextEditingController();
  final pincodeController = TextEditingController();

  void initState() {
    _passwordVisible = false;
    custNameController.addListener(_nameLatestValue);
    emailController.addListener(_emailLatestValue);
    passwordController.addListener(_passwordLatestValue);
    cityController.addListener(_cityLatestValue);
    talukController.addListener(_talukLatestValue);
    address1Controller.addListener(_address1LatestValue);
    stateController.addListener(_stateLatestValue);
    custNameController.addListener(_custNameLatestValue);
    numberController.addListener(_numberLatestValue);
    pincodeController.addListener(_pincodeLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    custNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cityController.dispose();
    stateController.dispose();
    address1Controller.dispose();
    talukController.dispose();
    numberController.dispose();
    super.dispose();
  }

  void _cityLatestValue() {
    city = cityController.text;
  }

  void _nameLatestValue() {
    customerName =  custNameController.text;
  }
  
  void _emailLatestValue() {
    email = emailController.text;
  }

  void _passwordLatestValue() {
    password = passwordController.text;
  }

  void _stateLatestValue() {
    state = stateController.text;
  }

  void _address1LatestValue() {
    address1 = address1Controller.text;
  }

  void _talukLatestValue() {
    address2 =  talukController.text;
  }

  void _numberLatestValue() {
    mobileNumber = numberController.text;
  }
  
  void _custNameLatestValue() {
    customerName = custNameController.text;
  }

  void _pincodeLatestValue() {
    pincode = pincodeController.text;
  }



  var customer;
  var salesExecutive;

  Future<bool> updateAddressFields() async {
    Location? loc = await getLocation(pincode);

    if (loc != null) {
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
    /*  print("Viru: $city");
    print("Viru: $state");
    print("Viru: $address1");
    print("Viru: $address2"); */
  }

  void fillDetails(CustomerModel customer) {
    customerName = customer.customerName;
    mobileNumber = customer.mobileNumber;
    email = customer.email;
    password = customer.password;
    address1 = customer.address1;
    address2 = customer.address2;
    city = customer.city;
    state = customer.state;
    pincode = customer.pincode;
    dropdownInt1 = customer.product1;
    dropdownInt2 = customer.product2;
    dropdownInt3 = customer.product3;
    dropdownInt4 = customer.product4;
    dropdownUses1 = customer.place1;
    dropdownUses2 = customer.place2;
    dropdownUses3 = customer.place3;
    dropdownUses4 = customer.place4;
  }

  // var isDupNum = false;

  @override
  Widget build(BuildContext context) {
    if(prevEmail != email || prevPassword != password) {
      setState(() {
        authCredEdited = true;
      });
    }
    final args = ModalRoute.of(context)!.settings.arguments as EditParameters;
    final currentUser = Provider.of<UserModel?>(context);
    final salesTable = Provider.of<List<SalesPersonModel?>>(context);

    //[Viru:2/6/23] Added to support customer mob search list
    List<CustomerModel> details = [];
    final customerList = Provider.of<List<CustomerModel>>(context);

    if(firstTime) {
      setState(() {
        firstTime = false;
      });
      customerList.forEach((element) {
        if(element.uid == args.uid) {
          fillDetails(element);
        }
      });
    }


    if (args.exec == '') {
      customerList.forEach(
          (e) => e.salesExecutiveId == currentUser?.uid ? details.add(e) : []);
    } else {
      customerList
          .forEach((e) => e.salesExecutiveId == args.exec ? details.add(e) : []);
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

    // customerList.forEach((element) {
    //   if(element.mobileNumber == numberController.text) {
    //     isDupNum = true;
    //   }
    // });

    return Scaffold(
      appBar: AppBar(
        title: Text('Energy Efficient Lights', style: TextStyle(fontSize: screenHeight / 50),),
        backgroundColor: const Color(0xff4d47c3),
        actions: currentUser?.uid != null
            ? [
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
              ]
            : null,
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
                  width: screenWidth / 3,
                  height: screenHeight / 10,
                  child: Image.asset('assets/logotm.jpg'),
                ),
                const SizedBox(height: 20.0),
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
                TextFormField(
                  style: TextStyle(fontSize: screenHeight / 50),
                  initialValue: customerName,
                  readOnly: true,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Enter Customer Name',
                      fillColor: const Color(0xfff0efff)),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter Customer Name' : null,
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
                 TextFormField(
                  style: TextStyle(fontSize: screenHeight / 50),
                  initialValue: mobileNumber,
                  keyboardType: TextInputType.phone,
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Customer Mobile Number',
                  ),
                  validator: (value) =>
                      value!.length < 10 ? 'Enter Customer Mobile Number' : null,
                  // onChanged: (val) {
                  //   mobileNumber = val;
                  // },
                ),
        
                //[Viru:2/6/23] Added to support customer name search list
                // TypeAheadFormField(
                //   textFieldConfiguration: TextFieldConfiguration(
                //     controller: numberController,
                //     decoration: textInputDecoration.copyWith(
                //       hintText: 'Enter Customer Mobile Number',
                //       fillColor: const Color(0xfff0efff),
                //     ),
                //     inputFormatters: [
                //       FilteringTextInputFormatter.allow(
                //           RegExp(r'[0-9]')), // Only allow numerical values
                //     ],
                //     onChanged: (value) {
                //       setState(() {
                //         numError = ''; // Clear the error message
                //         // numberController.text = value;
                //       });
                //     },
                //   ),
                //   suggestionsCallback: (pattern) async {
                //     // Filter the customer list based on the search pattern
                //     return details
                //         .where((customer) =>
                //             customer != null &&
                //             customer.mobileNumber.contains(pattern))
                //         .toList();
                //   },
                //   itemBuilder: (context, CustomerModel? suggestion) {
                //     if (suggestion == null) return const SizedBox.shrink();
                //     return ListTile(
                //       title: Text(suggestion.mobileNumber),
                //     );
                //   },
                //   onSuggestionSelected: (CustomerModel? suggestion) {
                //     if (suggestion != null) {
                //       setState(() {
                //         numError = 'Customer with this number already exists';
                //         numberController.clear();
                //       });
                //     } else {
                //       numberController.text.length != 10
                //           ? 'Enter Customer Mobile Number'
                //           : null;
                //       setState(() {
                //         numError = '';
                //       });
                //     }
                //   },
                //   validator: (value) {
                //     if (value != null && value.length != 10) {
                //       return 'Enter a valid 10-digit mobile number';
                //     }
                //     return null;
                //   },
                //   onSaved: (value) {
                //     setState(() {
                //       numError = ''; // Clear the error message
                //     });
                //   },
                // ),
                SizedBox(
                  child: Text(
                    numError,
                    style: TextStyle(
                      color: Color.fromARGB(190, 193, 2, 2),
                      fontSize: screenHeight / 60,
                    ),
                  ),
                ),
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
                  initialValue: email,
                  readOnly: true,
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Customer Email',
                  ),
                  validator: (value) =>
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!)
                          ? null
                          : 'Enter Valid Email',
                  // onChanged: (val) {
                  //   setState(() {
                  //     email = val;
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
                  initialValue: password,
                  readOnly: true,
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
                  validator: (value) => value!.length < 6
                      ? 'Enter a password of more than 6 characters'
                      : null,
                  // onChanged: (val) {
                  //   setState(() {
                  //     password = val;
                  //   });
                  // },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                    height: screenHeight / 40,
                    child: Text(
                      'Customer Full Address:',
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
                  initialValue: address1,
                  readOnly: true,
                  decoration: textInputDecoration.copyWith(
                      hintText:
                          'Please enter the pincode to autofill postal address'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter Customer Full Address' : null,
                  // onChanged: (val) {
                  //   setState(() {
                  //     address1 = val;
                  //   });
                  // },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  style: TextStyle(fontSize: screenHeight / 50),
                  initialValue: address2,
                  readOnly: true,
                  decoration:
                      textInputDecoration.copyWith(hintText: 'town, taluk'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter Customer Full Address' : null,
                  // onChanged: (val) {
                  //   setState(() {
                  //     address2 = val;
                  //   });
                  // },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  style: TextStyle(fontSize: screenHeight / 50),
                  initialValue: city,
                  readOnly: true,
                  decoration: textInputDecoration.copyWith(hintText: 'city'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter Customer Full Address' : null,
                  // onChanged: (val) {
                  //   //updateCity(val);
                  //   setState(() {
                  //     city = val;
                  //   });
                  // },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  style: TextStyle(fontSize: screenHeight / 50),
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
                /* DropdownButtonFormField(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.black, width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.black, width: 0),
                    ),
                    filled: true,
                    fillColor: Color(0xffefefff),
                  ),
                  dropdownColor: const Color(0xffefefff),
                  value: state,
                  onChanged: (String? newValue) {
                    setState(() {
                      state = newValue!;
                    });
                  },
                  items: <String>[
                    'Select State',
                    'Karnataka',
                    'Kerala',
                    'Tamil Nadu',
                    'Andra Pradesh'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                ), */
                const SizedBox(height: 10.0),
                TextFormField(
                  style: TextStyle(fontSize: screenHeight / 50),
                  initialValue: pincode,
                  readOnly: true,
                  keyboardType: TextInputType.phone,
                  decoration: textInputDecoration.copyWith(hintText: 'pincode'),
                  validator: (value) =>
                      RegExp(r'^\d+$').hasMatch(pincode) && pincode.length == 6
                          ? null
                          : 'Enter Valid pincode',
                  onChanged: (val) {
                    // setState(() {
                    //   pincode = val;
                    // });
                    // if (pincode.length == 6) {
                    //   updateAddressFields().then((value) {
                    //     if (!value) {
                    //       setState(() {
                    //         pincodeError = 'Please enter valid pincode';
                    //       });
                    //     }
                    //   });
                    // }
                  },
                ),
                const SizedBox(height: 12.0),
                Text(
                  pincodeError,
                  style: TextStyle(color: Colors.red, fontSize: screenHeight / 60),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: screenHeight / 40,
                  child: Text(
                    'Interested in:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: screenHeight / 50,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
        
                //curousel
                SizedBox(
                  height: screenHeight / 9,
                  width: screenWidth - 50,
                  child: ListView(children: [
                    CarouselSlider(
                      items: [
                        Container(
                          // margin: const EdgeInsets.only(right: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: TextFormField(
                                    style: TextStyle(fontSize: screenHeight / 50),
                                      initialValue: dropdownInt1,
                                      readOnly: true,
                                      decoration: textInputDecoration.copyWith(hintText: 'city'),
                                      // onChanged: (val) {
                                      //   //updateCity(val);
                                      //   setState(() {
                                      //     city = val;
                                      //   });
                                      // },
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(right: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: TextFormField(
                                    style: TextStyle(fontSize: screenHeight / 50),
                                    initialValue: dropdownInt2,
                                    readOnly: true,
                                    decoration: textInputDecoration.copyWith(hintText: 'city'),
                                    validator: (value) =>
                                        value!.isEmpty ? 'Enter Customer Full Address' : null,
                                    // onChanged: (val) {
                                    //   //updateCity(val);
                                    //   setState(() {
                                    //     city = val;
                                    //   });
                                    // },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(right: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: TextFormField(
                                    style: TextStyle(fontSize: screenHeight / 50),
                                    initialValue: dropdownInt3,
                                    readOnly: true,
                                    decoration: textInputDecoration.copyWith(hintText: 'city'),
                                    validator: (value) =>
                                        value!.isEmpty ? 'Enter Customer Full Address' : null,
                                    // onChanged: (val) {
                                    //   //updateCity(val);
                                    //   setState(() {
                                    //     city = val;
                                    //   });
                                    // },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(right: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: TextFormField(
                                    style: TextStyle(fontSize: screenHeight / 50),
                                    initialValue: dropdownInt4,
                                    readOnly: true,
                                    decoration: textInputDecoration.copyWith(hintText: 'city'),
                                    validator: (value) =>
                                        value!.isEmpty ? 'Enter Customer Full Address' : null,
                                    // onChanged: (val) {
                                    //   //updateCity(val);
                                    //   setState(() {
                                    //     city = val;
                                    //   });
                                    // },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        height: screenHeight / 9,
                        enlargeCenterPage: true,
                        autoPlay: false,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: false,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 10.0),
               SizedBox(
                  height: screenHeight / 40,
                  child: Text(
                    'Uses at:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: screenHeight / 50,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
        
                //curousel
                SizedBox(
                  height: screenHeight / 9,
                  width: screenWidth - 50,
                  child: ListView(children: [
                    CarouselSlider(
                      items: [
                        Container(
                          // margin: const EdgeInsets.only(right: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: TextFormField(
                                    style: TextStyle(fontSize: screenHeight / 50),
                                    initialValue: dropdownUses1,
                                    readOnly: true,
                                    decoration: textInputDecoration.copyWith(hintText: 'city'),
                                    validator: (value) =>
                                        value!.isEmpty ? 'Enter Customer Full Address' : null,
                                    // onChanged: (val) {
                                    //   //updateCity(val);
                                    //   setState(() {
                                    //     city = val;
                                    //   });
                                    // },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(right: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: TextFormField(
                                    style: TextStyle(fontSize: screenHeight / 50),
                                    initialValue: dropdownUses2,
                                    readOnly: true,
                                    decoration: textInputDecoration.copyWith(hintText: 'city'),
                                    validator: (value) =>
                                        value!.isEmpty ? 'Enter Customer Full Address' : null,
                                    // onChanged: (val) {
                                    //   //updateCity(val);
                                    //   setState(() {
                                    //     city = val;
                                    //   });
                                    // },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(right: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: TextFormField(
                                    style: TextStyle(fontSize: screenHeight / 50),
                                      initialValue: dropdownUses3,
                                      readOnly: true,
                                      decoration: textInputDecoration.copyWith(hintText: 'city'),
                                      validator: (value) =>
                                          value!.isEmpty ? 'Enter Customer Full Address' : null,
                                      // onChanged: (val) {
                                      //   //updateCity(val);
                                      //   setState(() {
                                      //     city = val;
                                      //   });
                                      // },
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(right: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: TextFormField(
                                    style: TextStyle(fontSize: screenHeight / 50),
                                    initialValue: dropdownUses4,
                                    readOnly: true,
                                    decoration: textInputDecoration.copyWith(hintText: 'city'),
                                    validator: (value) =>
                                        value!.isEmpty ? 'Enter Customer Full Address' : null,
                                    // onChanged: (val) {
                                    //   //updateCity(val);
                                    //   setState(() {
                                    //     city = val;
                                    //   });
                                    // },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        height: screenHeight / 9,
                        enlargeCenterPage: true,
                        autoPlay: false,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: false,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 12.0),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: screenHeight / 60),
                  ),
                ]),
        
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                        height: screenHeight / 15,
                        width: screenWidth,
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
                                        "Back",
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
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
