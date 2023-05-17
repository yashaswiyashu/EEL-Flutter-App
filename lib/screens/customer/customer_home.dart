import 'package:flutter/material.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:provider/provider.dart';


class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
    final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    //return home or auth widget
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Energy Efficient Lights'),
          backgroundColor: const Color(0xff4d47c3),
          actions: [
            TextButton.icon(
              onPressed: () async {
                await _auth.signout();
                Navigator.of(context).pushNamedAndRemoveUntil('authWrapper',(Route<dynamic> route) => false);
              }, 
              icon: const Icon(Icons.person, color: Colors.white,), 
              label: const Text('logout', style: TextStyle(color: Colors.white),)
            ),
          ],
        ),
        body: Container(
      width: 440,
      height: 800,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 21,),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
              Container(
                  width: 180,
                  height: 60,
                  child: Image.asset('assets/logotm.jpg'),
              ),
              SizedBox(height: 47.75),
              Container(
                  width: 282,
                  height: 72,
                  child: Stack(
                      children:[Positioned.fill(
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                  width: 281.13,
                                  height: 72,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9),
                                      boxShadow: [
                                          BoxShadow(
                                              color: Color(0x664d47c3),
                                              blurRadius: 61,
                                              offset: Offset(0, 4),
                                          ),
                                      ],
                                      color: Color(0xff4d47c3),
                                  ),
                              ),
                          ),
                      ),
                      Positioned(
                          left: -0,
                          top: 8.14,
                          child: SizedBox(
                              width: 179.85,
                              height: 15.65,
                              child: Text(
                                  "Present order status",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                  ),
                              ),
                          ),
                      ),],
                  ),
              ),
              SizedBox(height: 47.75),
              Container(
                  width: 282,
                  height: 125,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                          Container(
                              width: 282,
                              height: 125,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: [
                                      BoxShadow(
                                          color: Color(0x664d47c3),
                                          blurRadius: 61,
                                          offset: Offset(0, 4),
                                      ),
                                  ],
                                  color: Color(0xff4d47c3),
                              ),
                              child: Stack(
                                  children:[
                                      Positioned(
                                          left: 196.12,
                                          top: 21,
                                          child: Container(
                                              width: 58,
                                              height: 68,
                                              color: Color(0xffd9d9d9),
                                          ),
                                      ),
                                      Positioned(
                                          left: 182.12,
                                          top: 97,
                                          child: SizedBox(
                                              width: 86,
                                              height: 16,
                                              child: Text(
                                                  "Product N",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.w500,
                                                  ),
                                              ),
                                          ),
                                      ),
                                      Positioned(
                                          left: 111.12,
                                          top: 21,
                                          child: Container(
                                              width: 58,
                                              height: 68,
                                              color: Color(0xffd9d9d9),
                                          ),
                                      ),
                                      Positioned(
                                          left: 97.12,
                                          top: 97,
                                          child: SizedBox(
                                              width: 86,
                                              height: 16,
                                              child: Text(
                                                  "Product N",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.w500,
                                                  ),
                                              ),
                                          ),
                                      ),
                                      Positioned(
                                          left: 26.12,
                                          top: 21,
                                          child: Container(
                                              width: 58,
                                              height: 68,
                                              color: Color(0xffd9d9d9),
                                          ),
                                      ),
                                      Positioned(
                                          left: 12.12,
                                          top: 97,
                                          child: SizedBox(
                                              width: 86,
                                              height: 16,
                                              child: Text(
                                                  "Product N",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.w500,
                                                  ),
                                              ),
                                          ),
                                      ),
                                      Positioned(
                                          left: 260.12,
                                          top: 55,
                                          child: Container(
                                            width: 15,
                                            height: 15,
                                            child: Icon( Icons.arrow_right_outlined,)
                                          ),
                                      ),
                                      Positioned.fill(
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                  width: 15,
                                                  height: 15,
                                                  child: Icon( Icons.arrow_left_outlined, ),
                                              ),
                                          ),
                                      ),
                                  ],
                              ),
                          ),
                      ],
                  ),
              ),
              SizedBox(height: 47.75),
              Container(
                  width: 282,
                  height: 72,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                          Container(
                              width: 282,
                              height: 72,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: [
                                      BoxShadow(
                                          color: Color(0x664d47c3),
                                          blurRadius: 61,
                                          offset: Offset(0, 4),
                                      ),
                                  ],
                                  color: Color(0xff4d47c3),
                              ),
                              padding: const EdgeInsets.only(left: 8, right: 176, top: 10, bottom: 46, ),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                      SizedBox(
                                          width: 97.68,
                                          height: 16,
                                          child: Text(
                                              "Past Order",
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
                      ],
                  ),
              ),
              SizedBox(height: 157.75),
              Container(
                  width: 420,
                  height: 60,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                          Container(
                              width: 106,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: [
                                      BoxShadow(
                                          color: Color(0x664d47c3),
                                          blurRadius: 61,
                                          offset: Offset(0, 4),
                                      ),
                                  ],
                                  color: Color(0xff4d47c3),
                              ),
                              padding: const EdgeInsets.only(left: 7, right: 8, top: 18, bottom: 17, ),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:[
                                      SizedBox(
                                          width: 91,
                                          height: 25,
                                          child: Text(
                                              "Complaint",
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
                          SizedBox(width: 7),
                          Container(
                              width: 106,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: [
                                      BoxShadow(
                                          color: Color(0x664d47c3),
                                          blurRadius: 61,
                                          offset: Offset(0, 4),
                                      ),
                                  ],
                                  color: Color(0xff4d47c3),
                              ),
                              padding: const EdgeInsets.only(left: 9, right: 16, top: 18, bottom: 17, ),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:[
                                      SizedBox(
                                          width: 81,
                                          height: 25,
                                          child: Text(
                                              "Feedback",
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
                          SizedBox(width: 7),
                          Container(
                              width: 106,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: [
                                      BoxShadow(
                                          color: Color(0x664d47c3),
                                          blurRadius: 61,
                                          offset: Offset(0, 4),
                                      ),
                                  ],
                                  color: Color(0xff4d47c3),
                              ),
                              padding: const EdgeInsets.only(top: 18, bottom: 17, ),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:[
                                      SizedBox(
                                          width: 49.84,
                                          height: 24.41,
                                          child: Text(
                                              "Order",
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
                      ],
                  ),
              ),
          ],
      ),
    )
    
        ),
    );
  }
}