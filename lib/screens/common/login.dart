import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
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

  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {

    final salesTable = Provider.of<List<SalesPersonModel?>?>(context);
    final customerTable = Provider.of<List<CustomerModel?>?>(context);

    return loading ? SizedBox(height: 600,width: 440,child: const Loading()) :Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40.80),
                    Container(
                      width: 322,
                      height: 62,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xffefefff),
                      ),
                      child: TextFormField(
                        autofocus: true,
                        validator: (value) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) ? null : 'Enter valid email',
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
                      width: 322,
                      height: 62,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xffefefff),
                      ),
                      child: TextFormField(
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
                    const SizedBox(height: 40.0),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xff4d47c3)),
                        child: Container(
                          width: 320,
                          height: 59,
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
                            children: const [
                              Text(
                                "Login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
                              if(salesTable != null){
                                salesTable.forEach((e) {
                                  if(e?.uid == result.uid){
                                    if(e?.role == 'Sales Executive'){
                                      setState(() {
                                        error = '';
                                        loading = false;
                                      });
                                      Navigator.pushNamed(context, 'salesExecutiveHome');
                                    } else if(e?.role == 'Sales Co-Ordinator'){
                                      setState(() {
                                        error = '';
                                        loading = false;
                                      });
                                      Navigator.pushNamed(context, 'salesCoOrdinatorHome');
                                    } else if(e?.role == 'Admin'){
                                      setState(() {
                                        error = '';
                                        loading = false;
                                      });
                                      Navigator.pushNamed(context, 'salesCoOrdinatorHome');
                                    } 
                                  }
                                });
                              } else if(customerTable != null){
                                customerTable.forEach((e) {
                                  if(e?.uid == result.uid){
                                    setState(() {
                                      error = '';
                                      loading = false;
                                    });
                                    Navigator.pushNamed(context, 'customerHomePage');
                                  } else {
                                    setState(() {
                                      error = '';
                                      loading = false;
                                    });
                                    Navigator.pushNamed(context, 'home');
                                  }
                                });
                              } else {
                                setState(() {
                                  error = '';
                                  loading = false;
                                });
                                Navigator.pushNamed(context, 'home');
                              }
                            }
                          }
                        }),
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                  ],
                ),
              );
  }
}