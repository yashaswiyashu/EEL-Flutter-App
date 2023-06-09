import 'package:flutter/material.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/edit_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/customer_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class EditCustomerDetails extends StatefulWidget {
  const EditCustomerDetails({super.key});
  static const routeName = '/editCustomerDetails';

  @override
  State<EditCustomerDetails> createState() => _EditCustomerDetailsState();
}

class _EditCustomerDetailsState extends State<EditCustomerDetails> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  String dropdownInt1 = 'Suraksha';
  String dropdownInt2 = 'Suraksha';
  String dropdownInt3 = 'Suraksha';
  String dropdownInt4 = 'Suraksha';
  String dropdownUses1 = 'House';
  String dropdownUses2 = 'House';
  String dropdownUses3 = 'House';
  String dropdownUses4 = 'House';

  //controllers
  final controllerName = TextEditingController();
  final controllerNumber = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerAddress1 = TextEditingController();
  final controllerAddress2 = TextEditingController();
  final controllerCity = TextEditingController();
  final controllerState = TextEditingController();
  final controllerPincode = TextEditingController();
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

  String error = '';
  bool _passwordVisible = false;

  void initState() {
    _passwordVisible = false;
    super.initState();

    // Start listening to changes.
    controllerName.addListener(_saveName);
    controllerNumber.addListener(_saveNumber);
    controllerEmail.addListener(_saveEmail);
    controllerPassword.addListener(_savePassword);
    controllerAddress1.addListener(_saveAddress1);
    controllerAddress2.addListener(_saveAddress2);
    controllerCity.addListener(_saveCity);
    controllerState.addListener(_saveState);
    controllerPincode.addListener(_savePincode);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    controllerName.dispose();
    controllerNumber.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerAddress1.dispose();
    controllerAddress2.dispose();
    controllerCity.dispose();
    controllerState.dispose();
    controllerPincode.dispose();
    super.dispose();
  }

  var customer;

  void _saveName() {
    customerName = controllerName.text;
  }

  void _saveNumber() {
    mobileNumber = controllerNumber.text;
  }

  void _saveEmail() {
    email = controllerEmail.text;
  }

  void _savePassword() {
    password = controllerPassword.text;
  }

  void _saveAddress1() {
    address1 = controllerAddress1.text;
  }

  void _saveAddress2() {
    address2 = controllerAddress2.text;
  }

  void _saveCity() {
    city = controllerCity.text;
  }

  void _saveState() {
    state = controllerState.text;
  }

  void _savePincode() {
    pincode = controllerPincode.text;
  }

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
        CustomerDatabaseService(docid: uid).deleteUserData();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
          content: Text(
              'Customer details deleted Successfully!!!'),
        ));
        Navigator.pop(context);
      } else {
        // user pressed No button
        // Navigator.pop(context);
        return;
      }
    });
  }
  var salesExecutive;

  var firstTime = true;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as EditParameters;
    final currentUser = Provider.of<UserModel?>(context);
    final customerTable = Provider.of<List<CustomerModel>>(context);
        final salesTable = Provider.of<List<SalesPersonModel?>>(context);

    var obj;

    if (customerTable != null) {
      customerTable.forEach((element) {
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

    String st = '';
    String int1 = 'Suraksha';
    String int2 = 'Suraksha';
    String int3 = 'Suraksha';
    String int4 = 'Suraksha';
    String uses1 = 'House';
    String uses2 = 'House';
    String uses3 = 'House';
    String uses4 = 'House';

    if (obj != null && firstTime) {
      setState(() {
        firstTime = false;
      });
      controllerName.text = obj.customerName;
      controllerNumber.text = obj.mobileNumber;
      controllerEmail.text = obj.email;
      controllerPassword.text = obj.password;
      controllerAddress1.text = obj.address1;
      controllerAddress2.text = obj.address2;
      controllerCity.text = obj.city;
      controllerPincode.text = obj.pincode;
      controllerState.text = obj.state;
      int1 = obj.product1;
      int2 = obj.product2;
      int3 = obj.product3;
      int4 = obj.product4;
      uses1 = obj.place1;
      uses2 = obj.place2;
      uses3 = obj.place3;
      uses4 = obj.place4;
    }

    return Scaffold(
            appBar: AppBar(
              title:  Text('Energy Efficient Lights', style: TextStyle(fontSize: screenHeight / 50)),
              backgroundColor: const Color(0xff4d47c3),
              actions: currentUser?.uid != null
                  ? [
                      TextButton.icon(
                          onPressed: () async {
                            await _auth.signout();
                            Navigator.of(context).pushNamedAndRemoveUntil('authWrapper',(Route<dynamic> route) => false);
                          },
                          icon:  Icon(
                            Icons.person,
                            color: Colors.white,
                            size: screenHeight / 50,
                          ),
                          label:  Text(
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
                        controller: controllerName,
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
                        controller: controllerNumber,
                        keyboardType: TextInputType.phone,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Customer Mobile Number',
                        ),
                        validator: (value) {
                          if (value != null && value.length != 10) {
                            return 'Enter a valid 10-digit mobile number';
                          }
                          return null;
                        },
                        // onChanged: (val) {
                        //   mobileNumber = val;
                        // },
                      ),
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
                        controller: controllerEmail,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Customer Email',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter Customer Email' : null,
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
                        controller: controllerPassword,
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
                        controller: controllerAddress1,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'house#, area'),
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
                        controller: controllerAddress2,
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
                        controller: controllerCity,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'city'),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter Customer Full Address' : null,
                        // onChanged: (val) {
                        //   setState(() {
                        //     city = val;
                        //   });
                        // },
                      ),
                      const SizedBox(height: 10.0),
                      // DropdownButtonFormField(
                      //   decoration: const InputDecoration(
                      //     enabledBorder: OutlineInputBorder(
                      //       //<-- SEE HERE
                      //       borderSide: BorderSide(color: Colors.black, width: 0),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       //<-- SEE HERE
                      //       borderSide: BorderSide(color: Colors.black, width: 0),
                      //     ),
                      //     filled: true,
                      //     fillColor: Color(0xffefefff),
                      //   ),
                      //   dropdownColor: const Color(0xffefefff),
                      //   value: state == 'Select State' ? st : state,
                      //   onChanged: (String? newValue) {
                      //     setState(() {
                      //       state = newValue!;
                      //     });
                      //   },
                      //   items: <String>[
                      //     'Select State',
                      //     'Karnataka',
                      //     'Kerala',
                      //     'Tamil Nadu',
                      //   ].map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(
                      //         value,
                      //         style: const TextStyle(fontSize: 15),
                      //       ),
                      //     );
                      //   }).toList(),
                      // ),
                      TextFormField(
                        style: TextStyle(fontSize: screenHeight / 50),
                        controller: controllerState,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'state'),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter Customer Full Address' : null,
                        // onChanged: (val) {
                        //   setState(() {
                        //     city = val;
                        //   });
                        // },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        style: TextStyle(fontSize: screenHeight / 50),
                        controller: controllerPincode,
                        keyboardType: TextInputType.phone,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'pincode'),
                        validator: (value) =>
                            RegExp(r'^\d+$').hasMatch(pincode) && pincode.length == 6 ? null : 'Enter Valid pincode',
                        // onChanged: (val) {
                        //   setState(() {
                        //     pincode = val;
                        //   });
                        // },
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
                                    children: <Widget>[
                                      SizedBox(
                                        width: screenWidth / 4,
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
                                          value: dropdownInt1 == 'Suraksha'
                                              ? int1
                                              : dropdownInt1,
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
                                                style:
                                                     TextStyle(fontSize: screenHeight / 55),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 25.0,
                                      ),
                                      SizedBox(
                                        width: screenWidth / 4,
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
                                          value: dropdownInt2 == 'Suraksha'
                                              ? int2
                                              : dropdownInt2,
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
                                                style:
                                                   TextStyle(fontSize: screenHeight / 55),
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
                                        width: screenWidth / 4,
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
                                          value: dropdownInt3 == 'Suraksha'
                                              ? int3
                                              : dropdownInt3,
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
                                                style:
                                                     TextStyle(fontSize: screenHeight / 55),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 25.0,
                                      ),
                                      SizedBox(
                                        width: screenWidth / 4,
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
                                          value: dropdownInt4 == 'Suraksha'
                                              ? int4
                                              : dropdownInt4,
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
                                                style:
                                                     TextStyle(fontSize: screenHeight / 55),
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
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
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
                                        width: screenWidth / 3,
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
                                          value: dropdownUses1 == 'House'
                                              ? uses1
                                              : dropdownUses1,
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
                                                style:
                                                   TextStyle(fontSize: screenHeight / 55),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth / 20,
                                      ),
                                      SizedBox(
                                        width: screenWidth / 3,
                                        child: DropdownButtonFormField(
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              //<-- SEE HERE
                                              borderSide: BorderSide(
                                                  color: Colors.black, width: 0),
                                            ),
              
                                            //<-- SEE HERE
              
                                            filled: true,
                                            fillColor: Color(0xffefefff),
                                          ),
                                          dropdownColor: const Color(0xffefefff),
                                          value: dropdownUses2 == 'House'
                                              ? uses2
                                              : dropdownUses2,
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
                                                style:
                                                     TextStyle(fontSize: screenHeight / 55),
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
                                        width: screenWidth / 3,
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
                                          value: dropdownUses3 == 'House'
                                              ? uses3
                                              : dropdownUses3,
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
                                                style:
                                                   TextStyle(fontSize: screenHeight / 55),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                       SizedBox(
                                        width: screenWidth / 20,
                                      ),
                                      SizedBox(
                                        width: screenWidth / 3 ,
                                        child: DropdownButtonFormField(
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              //<-- SEE HERE
                                              borderSide: BorderSide(
                                                  color: Colors.black, width: 0),
                                            ),
              
                                            //<-- SEE HERE
              
                                            filled: true,
                                            fillColor: Color(0xffefefff),
                                          ),
                                          dropdownColor: const Color(0xffefefff),
                                          value: dropdownUses4 == 'House'
                                              ? uses4
                                              : dropdownUses4,
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
                                                style:
                                                     TextStyle(fontSize: screenHeight / 55),
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
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              viewportFraction: 0.8,
                            ),
                          ),
                        ]),
                      ),
              
                      const SizedBox(
                        height: 10.0,
                      ),
                      loading ? const CircularProgressIndicator()
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
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  await CustomerDatabaseService(docid: args.uid)
                                      .updateUserData(
                                        args.exec == '' ? currentUser!.uid : args.exec,
                                        customerName,
                                        mobileNumber,
                                        email,
                                        password,
                                        address1,
                                        address2,
                                        city,
                                        state == st ? st : state,
                                        pincode,
                                        dropdownInt1 == 'Suraksha'
                                            ? int1
                                            : dropdownInt1,
                                        dropdownInt2 == 'Suraksha'
                                            ? int2
                                            : dropdownInt2,
                                        dropdownInt3 == 'Suraksha'
                                            ? int3
                                            : dropdownInt3,
                                        dropdownInt4 == 'Suraksha'
                                            ? int4
                                            : dropdownInt4,
                                        dropdownUses1 == 'House'
                                            ? uses1
                                            : dropdownUses1,
                                        dropdownUses2 == 'House'
                                            ? uses2
                                            : dropdownUses2,
                                        dropdownUses3 == 'House'
                                            ? uses3
                                            : dropdownUses3,
                                        dropdownUses4 == 'House'
                                            ? uses4
                                            : dropdownUses4,
                                      )
                                      .then((value) => setState(() {
                                            loading = false;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Customer Details updated Successfully!!!'),
                                            ));
                                            Navigator.pop(context);
                                          }));
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
                            ElevatedButton(
                                // autogroupqdj5BoM (UPthV8mGmAE7wuU648qDj5)
                                onPressed: () {
                                  showConfirmation(obj!.uid);
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
                      const SizedBox(height: 12.0),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 14.0),
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
