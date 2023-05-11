
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/common/login.dart';
import 'package:flutter_app/screens/common/register_as.dart';


class HomeWrapper extends StatelessWidget {
  final bool login;
  const HomeWrapper({super.key,required this.login});

  @override
  Widget build(BuildContext context) {
    if(login){
      return const Login();
    } else {
      return const RegisterAs();
    }
  }
}
