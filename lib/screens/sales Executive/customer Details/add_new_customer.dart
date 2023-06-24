import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/customer_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../common/location.dart';

class AddNewCustomer extends StatefulWidget {
  const AddNewCustomer({super.key});
  static const routeName = '/addCustomerDetails';

  @override
  State<AddNewCustomer> createState() => _AddNewCustomerState();
}

class _AddNewCustomerState extends State<AddNewCustomer> {
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
  String password = '';
  String address1 = '';
  String address2 = '';
  String city = '';
  String state = 'Select State';
  String pincode = '';
  String pincodeError = '';

  String error = '';
  bool _passwordVisible = false;

  final nameController = TextEditingController();
  final talukController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final numberController = TextEditingController();
  //final custNameController = TextEditingController();

  void initState() {
    _passwordVisible = false;
    cityController.addListener(_cityLatestValue);
    talukController.addListener(_talukLatestValue);
    nameController.addListener(_nameLatestValue);
    stateController.addListener(_stateLatestValue);
    //custNameController.addListener(_custNameLatestValue);
    numberController.addListener(_numberLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    cityController.dispose();
    stateController.dispose();
    nameController.dispose();
    talukController.dispose();
    //custNameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  void _cityLatestValue() {
    print('Viru:: ${cityController.text}');
  }

  void _stateLatestValue() {
    print('Viru:: ${stateController.text}');
  }

  void _nameLatestValue() {
    print('Viru:: ${nameController.text}');
  }

  void _talukLatestValue() {
    print('Viru:: ${talukController.text}');
  }

  void _numberLatestValue() {
    mobileNumber = numberController.text;
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
    final args = ModalRoute.of(context)!.settings.arguments as Parameter;
    final currentUser = Provider.of<UserModel?>(context);
    final salesTable = Provider.of<List<SalesPersonModel?>>(context);

    //[Viru:2/6/23] Added to support customer mob search list
    List<CustomerModel> details = [];
    var iscust = false;
    final customerList = Provider.of<List<CustomerModel>>(context);
      customerList.forEach(
          (e) => details.add(e));


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

    customerList.forEach((element) {
      if(element.mobileNumber == numberController.text) {
        isDupNum = true;
      }
    });

    customerList.forEach((element) {
      if(element.uid == currentUser?.uid) {
        setState(() {
          iscust = true;
        });
      }
    });


    return Scaffold(
      appBar: AppBar(
        title: Text('Energy Efficient Lights', style: TextStyle(fontSize: screenHeight / 50)),
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
                !iscust ? Container(
                  padding: EdgeInsets.only(right: 15, top: 10),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(
                      'Name: ${salesExecutive.name}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenHeight / 55,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ) : const SizedBox(height: 0,width: 0,),
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
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Enter Customer Name',
                      fillColor: const Color(0xfff0efff)),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter Customer Name' : null,
                  onChanged: (val) {
                    customerName = val;
                  },
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
        /*               TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Customer Mobile Number',
                  ),
                  validator: (value) =>
                      value!.length < 10 ? 'Enter Customer Mobile Number' : null,
                  onChanged: (val) {
                    mobileNumber = val;
                  },
                ),
         */
                //[Viru:2/6/23] Added to support customer name search list
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    style: TextStyle(fontSize: screenHeight / 50),
                    controller: numberController,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Enter Customer Mobile Number',
                      fillColor: const Color(0xfff0efff),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]')), // Only allow numerical values
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
                        .where((customer) =>
                            customer != null &&
                            customer.mobileNumber.contains(pattern))
                        .toList();
                  },
                  itemBuilder: (context, CustomerModel? suggestion) {
                    if (suggestion == null) return const SizedBox.shrink();
                    return ListTile(
                      title: Text(suggestion.mobileNumber),
                    );
                  },
                  onSuggestionSelected: (CustomerModel? suggestion) {
                    if (suggestion != null) {
                      setState(() {
                        numError = 'Customer with this number already exists';
                        numberController.clear();
                      });
                    } else {
                      numberController.text.length != 10
                          ? 'Enter Customer Mobile Number'
                          : null;
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
                numError != '' ? SizedBox(
                  child: Text(
                    numError,
                    style: TextStyle(
                      color: Color.fromARGB(190, 193, 2, 2),
                    ),
                  ),
                ) : const SizedBox(height: 0,),
                const SizedBox(height: 20.0),
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
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Customer Email',
                  ),
                  validator: (value) =>
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!)
                          ? null
                          : 'Enter Valid Email',
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
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
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
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
                  controller: nameController,
                  decoration: textInputDecoration.copyWith(
                      hintText:
                          'Please enter the pincode to autofill postal address'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter Customer Full Address' : null,
                  onChanged: (val) {
                    setState(() {
                      address1 = val;
                    });
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  style: TextStyle(fontSize: screenHeight / 50),
                  controller: talukController,
                  decoration:
                      textInputDecoration.copyWith(hintText: 'town, taluk'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter Customer Full Address' : null,
                  onChanged: (val) {
                    setState(() {
                      address2 = val;
                    });
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  style: TextStyle(fontSize: screenHeight / 50),
                  controller: cityController,
                  decoration: textInputDecoration.copyWith(hintText: 'city'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter Customer Full Address' : null,
                  onChanged: (val) {
                    //updateCity(val);
                    setState(() {
                      city = val;
                    });
                  },
                ),
                const SizedBox(height: 10.0),
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
                  keyboardType: TextInputType.phone,
                  decoration: textInputDecoration.copyWith(hintText: 'pincode'),
                  validator: (value) =>
                      RegExp(r'^\d+$').hasMatch(pincode) && pincode.length == 6
                          ? null
                          : 'Enter Valid pincode',
                  onChanged: (val) {
                    setState(() {
                      pincode = val;
                    });
                    if (pincode.length == 6) {
                      updateAddressFields().then((value) {
                        if (!value) {
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xffefefff),
                                    ),
                                    dropdownColor: const Color(0xffefefff),
                                    value: dropdownInt1,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownInt1 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Suraksha',
                                      'Suraksha Eye',
                                      'other',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: screenHeight / 55),
                                        ),
                                      );
                                    }).toList(),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xffefefff),
                                    ),
                                    dropdownColor: const Color(0xffefefff),
                                    value: dropdownInt2,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownInt2 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Suraksha',
                                      'Suraksha Eye',
                                      'other',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: screenHeight / 55),
                                        ),
                                      );
                                    }).toList(),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xffefefff),
                                    ),
                                    dropdownColor: const Color(0xffefefff),
                                    value: dropdownInt3,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownInt3 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Suraksha',
                                      'Suraksha Eye',
                                      'other',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: screenHeight / 55),
                                        ),
                                      );
                                    }).toList(),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xffefefff),
                                    ),
                                    dropdownColor: const Color(0xffefefff),
                                    value: dropdownInt4,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownInt4 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Suraksha',
                                      'Suraksha Eye',
                                      'other',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: screenHeight / 55),
                                        ),
                                      );
                                    }).toList(),
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
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xffefefff),
                                    ),
                                    dropdownColor: const Color(0xffefefff),
                                    value: dropdownUses1,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownUses1 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'House',
                                      'Farm',
                                      'Fields',
                                      'Warehouse',
                                      'Yard',
                                      'Road',
                                      'Gully',
                                      'Fisheries',
                                      'Boats',
                                      'Construction site',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: screenHeight / 55),
                                        ),
                                      );
                                    }).toList(),
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
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xffefefff),
                                    ),
                                    dropdownColor: const Color(0xffefefff),
                                    value: dropdownUses2,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownUses2 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'House',
                                      'Farm',
                                      'Fields',
                                      'Warehouse',
                                      'Yard',
                                      'Road',
                                      'Gully',
                                      'Fisheries',
                                      'Boats',
                                      'Construction site',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: screenHeight / 55),
                                        ),
                                      );
                                    }).toList(),
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
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xffefefff),
                                    ),
                                    dropdownColor: const Color(0xffefefff),
                                    value: dropdownUses3,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownUses3 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'House',
                                      'Farm',
                                      'Fields',
                                      'Warehouse',
                                      'Yard',
                                      'Road',
                                      'Gully',
                                      'Fisheries',
                                      'Boats',
                                      'Construction site',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: screenHeight / 55),
                                        ),
                                      );
                                    }).toList(),
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
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xffefefff),
                                    ),
                                    dropdownColor: const Color(0xffefefff),
                                    value: dropdownUses4,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownUses4 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'House',
                                      'Farm',
                                      'Fields',
                                      'Warehouse',
                                      'Yard',
                                      'Road',
                                      'Gully',
                                      'Fisheries',
                                      'Boats',
                                      'Construction site',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style:  TextStyle(fontSize: screenHeight / 55),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        height: screenHeight  / 9,
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
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ]),
        
                const SizedBox(
                  height: 10.0,
                ),
                loading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        height: screenHeight / 6,
                        width: screenWidth,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (_formkey.currentState!.validate() &&
                                    state != 'Select State' && !isDupNum) {
                                  setState(() {
                                    loading = true;
                                    numError = '';
                                  });
                                  try {
                                    var cred;
                                    User? currentExistingUser =
                                        FirebaseAuth.instance.currentUser;
        
                                    if (salesTable != null) {
                                      salesTable.forEach((element) {
                                        if (element?.uid ==
                                            currentExistingUser?.uid) {
                                          cred = element;
                                        }
                                      });
                                    }
        
                                    AuthCredential credential =
                                        EmailAuthProvider.credential(
                                      email: cred.email,
                                      password: cred.password,
                                    );
        
                                    // Register the new user
                                    UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                      email: email,
                                      password: password,
                                    );
        
                                    await FirebaseAuth.instance.signOut();
                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential);
                                    // Perform any additional actions with the new user
                                    // ...
                                    if (userCredential.user?.uid != null) {
                                      await CustomerDatabaseService(
                                              docid: userCredential.user!.uid)
                                          .setUserData(
                                        userCredential.user!.uid,
                                        args.uid == ''
                                            ? currentUser!.uid
                                            : args.uid,
                                        customerName,
                                        mobileNumber,
                                        email,
                                        password,
                                        address1,
                                        address2,
                                        city,
                                        state,
                                        pincode,
                                        dropdownInt1,
                                        dropdownInt2,
                                        dropdownInt3,
                                        dropdownInt4,
                                        dropdownUses1,
                                        dropdownUses2,
                                        dropdownUses3,
                                        dropdownUses4,
                                      )
                                          .then((value) {
                                        setState(() {
                                          loading = false;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'New Customer Details Added Successfully!!!'),
                                          ));
                                        });
                                        Navigator.pop(context);
                                      });
                                    }
                                  } catch (e) {
                                    setState(() {
                                      error = e.toString();
                                      loading = false;
                                    });
                                  }
                                } else {
                                  if (isDupNum) {
                                    setState(() {
                                      numError = 'Customer with this number already exists';
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:  [
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
                const SizedBox(height: 20.0),
                // ElevatedButton(
                //   style:
                //       ElevatedButton.styleFrom(backgroundColor: Colors.pink[400]),
                //   onPressed: () async {
                //     // if(_formkey.currentState!.validate()){
                //     //   setState(() {
                //     //     loading = true;
                //     //   });
                //     //   dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                //     //   if(result == null){
                //     //     setState(() {
                //     //       error = 'unknown user please register';
                //     //       loading = false;
                //     //     });
                //     //   }
                //     // }
                //   },
                //   child: const Text(
                //     'Sign In',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
                // const SizedBox(height: 12.0),
                // Text(
                //   error,
                //   style: const TextStyle(color: Colors.red, fontSize: 14.0),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
