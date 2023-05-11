import 'package:flutter/material.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/sales_database.dart';

import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';

class SalesPersonRegistration extends StatefulWidget {
  const SalesPersonRegistration({super.key});

  @override
  State<SalesPersonRegistration> createState() =>
      _SalesPersonRegistrationState();
}

class _SalesPersonRegistrationState extends State<SalesPersonRegistration> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

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
  String state = 'Select State ...';
  String pincode = '';

  String error = '';
  bool _passwordVisible = false;

  void initState() {
    _passwordVisible = false;
  }

  var snackBar = SnackBar(
  content: Text('Registered Successfully!!!'),
  );

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
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
                      margin: EdgeInsets.only(left: 120),
                      child: Text(
                        error,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14.0,
                        ),
                      ),
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
                      validator: (value) =>
                          value!.isEmpty ? 'Missing Field' : null,
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
                          'Education:',
                          style: TextStyle(
                            color: Color(0xff090a0a),
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? 'Missing Field' : null,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Enter Education Details',
                      ),
                      onChanged: (val) {
                        education = val;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    const SizedBox(
                        height: 20.0,
                        child: Text(
                          'Role:',
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
                      value: role,
                      onChanged: (String? newValue) {
                        setState(() {
                          role = newValue!;
                        });
                      },
                      items: <String>[
                        'Sales Executive',
                        'Sales Co-Ordinator',
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
                      keyboardType: TextInputType.phone,
                      validator: (value) => value?.length == 12
                          ? null
                          : 'Enter valid Aadhar number',
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Enter Your Adhaar Number',
                      ),
                      onChanged: (val) {
                        adhaarNumber = val;
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
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value?.length == 10 ? null : 'Enter valid number',
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Enter Phone Number',
                      ),
                      onChanged: (val) {
                        phoneNumber = val;
                      },
                    ),
                    const SizedBox(height: 20.0),
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
                      validator: (value) =>
                          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(email)
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
                      validator: (value) =>
                          value!.isEmpty ? 'Missing address field' : null,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'house#, area'),
                      onChanged: (val) {
                        address1 = val;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? 'Missing address field' : null,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'talluk'),
                      onChanged: (val) {
                        address2 = val;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? 'Enter valid city' : null,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'District'),
                      onChanged: (val) {
                        city = val;
                      },
                    ),
                    const SizedBox(height: 10.0),
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
                        value: state,
                        onChanged: (String? newValue) {
                          setState(() {
                            state = newValue!;
                          });
                        },
                        items: <String>[
                          'Select State ...',
                          'Karnataka',
                          'Kerala',
                          'Tamil Nadu',
                          'Andra Pradesh'
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
                    TextFormField(
                      validator: (value) =>
                          value?.length == 6 ? null : 'Enter valid Pincode',
                      decoration:
                          textInputDecoration.copyWith(hintText: 'pincode'),
                      onChanged: (val) {
                        pincode = val;
                      },
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
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    error = 'please supply a valid email';
                                    loading = false;
                                  });
                                } else {
                                  if (result?.uid != null) {
                                    await SalesPersonDatabase(uid: result!.uid)
                                        .updateUserData(
                                            result?.uid,
                                            name,
                                            education,
                                            role,
                                            adhaarNumber,
                                            phoneNumber,
                                            email,
                                            password,
                                            address1,
                                            address2,
                                            city,
                                            state,
                                            pincode);
                                    loading = false;
                                    if (role == 'Sales Executive') {
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      Navigator.pushNamed(
                                          context, 'salesExecutiveHome');
                                      
                                    } else if (role == 'Sales Co-Ordinator') {
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      Navigator.pushNamed(
                                          context, 'salesCoOrdinateHome');
                                    }
                                  }
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
