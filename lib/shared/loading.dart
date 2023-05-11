import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 174, 172, 218),
      child: const Center(
        child: SpinKitChasingDots(
          color: Color(0xff4d47c3),
          size: 30.0,
        ),
      ),
    );
  }
}