import 'package:flutter/material.dart';
import 'package:flutter_app/screens/common/globals.dart';

var textInputDecoration = InputDecoration(
  errorStyle: TextStyle(fontSize: screenHeight / 60),
  fillColor: Color(0xffefefff),
  filled: true,
  border: InputBorder.none,
  // enabledBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Colors.white, width: 2.0),
  // ),
  // focusedBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Color(0xff4d47c3), width: 2.0),
  // )
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
);
