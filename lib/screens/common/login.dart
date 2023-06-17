import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String role = 'Sales Executive';

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  //text fields state holders
  String email = "";
  String password = "";
  String error = '';
  bool _passwordVisible = false;
  var approved = false;
  var isCust = false;
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {

    final salesTable = Provider.of<List<SalesPersonModel?>>(context);
    final customerTable = Provider.of<List<CustomerModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);

    return loading ? SizedBox(height: screenHeight - 335,width: screenWidth,child: const Loading()) :Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40.80),
                    Container(
                      width: screenWidth - 100,
                      height: screenHeight / 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xffefefff),
                      ),
                      child: TextFormField(
                        style: TextStyle(fontSize: screenHeight / 50),
                        autofocus: true,
                        validator: (value) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!) ? null : 'Enter valid email',
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 40.80),
                    Container(
                      width: screenWidth - 100,
                      height: screenHeight / 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xffefefff),
                      ),
                      child: TextFormField(
                        style: TextStyle(fontSize: screenHeight / 50),
                        validator: (value) => value!.length < 6 ? 'Enter a password of more than 6 characters' : null,
                        keyboardType: TextInputType.text,
                        obscureText: !_passwordVisible,
                        decoration:
                          textInputDecoration.copyWith(
                            hintText: 'Password', 
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                                size: screenHeight / 40,
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
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight / 20),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xff4d47c3)),
                        child: Container(
                          width: screenWidth - 100,
                          height: screenHeight / 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x664d47c3),
                                blurRadius: 70,
                                offset: Offset(0, 4),
                              ),
                            ],
                            color: const Color(0xff4d47c3),
                          ),
                          padding: const EdgeInsets.only(
                            left: 139,
                            right: 140,
                            top: 17,
                            bottom: 18,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight / 50,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if(_formkey.currentState!.validate()){
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                            if(result == null){
                              setState(() {
                                error = 'unknown user please register';
                                loading = false;
                              });
                            } else {
                              customerTable.forEach((element) {
                                if(element.uid == result.uid) {
                                  setState(() {
                                    isCust = true;
                                    loading = false;
                                  });
                                }
                              }); 
                              if(!isCust) {
                                salesTable.forEach((element) {
                                  if(element!.uid == result.uid){ 
                                    if(element.approved) {
                                      setState(() {
                                        approved = true; 
                                        loading = false;
                                      });
                                    } else {
                                      setState(() {
                                        error = 'Your account has been registered. Please wait for approval';
                                        loading = false;
                                      });
                                    }
                                  }
                                });
                              }
                              if(approved || isCust) {
                                Navigator.of(context).pushNamedAndRemoveUntil('authWrapper', (Route<dynamic> route) => false);
                              }
                            }
                          }
                        }),
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: screenHeight / 60),
                      )
                  ],
                ),
              );
  }
}