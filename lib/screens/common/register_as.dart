import 'package:flutter/material.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/screens/customer/customer_registration.dart';
import 'package:flutter_app/screens/sales%20Common/sales_person_registration.dart';


class RegisterAs extends StatefulWidget {
  const RegisterAs({super.key});

  @override
  State<RegisterAs> createState() => _RegisterAsState();
}

class _RegisterAsState extends State<RegisterAs> {
  @override
  Widget build(BuildContext context) {
    return Container(
    width: screenWidth,
    color: Colors.white,
    padding: const EdgeInsets.only(top: 14,),
    child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
            SizedBox(height: screenHeight / 200,),
            SizedBox(
                width: screenWidth /1.4,
                height: screenHeight / 15,
                child: Text(
                    "Register as",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: screenHeight / 30,
                    ),
                ),
            ),
            const SizedBox(height: 20.0,),
            SizedBox(height: 3, width: screenWidth / 2, child: Container(color: Colors.black,),),
            const SizedBox(height: 20.20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                        context, SalesPersonRegistration.routeName,
                        arguments: 'Sales Executive');
              },
              child: Container(
                  width: screenWidth /1.4,
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
                  padding: const EdgeInsets.only(left: 99, right: 100, top: 17, bottom: 18, ),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                          Text(
                              "Sales Executive",
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
            ),
            const SizedBox(height: 38.20),
            TextButton(
              onPressed: (){
                Navigator.pushNamed(
                        context, SalesPersonRegistration.routeName,
                        arguments: 'Sales Co-Ordinator');
              },
              child: Container(
                  width: screenWidth /1.4,
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
                  padding: const EdgeInsets.only(left: 89, right: 90, top: 17, bottom: 18, ),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                          Text(
                              "Sales Co-Ordinator",
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
            ),
            const SizedBox(height: 38.20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                        context, CustomerRegistration.routeName,
                        arguments: Parameter(
                          ''
                        ));
              },
              child: Container(
                  width: screenWidth / 1.4,
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
                  padding: const EdgeInsets.only(left: 119, right: 122, top: 17, bottom: 18, ),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          Text(
                              "Customer",
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
            ),
        ],
    ),
)
;
  }
}