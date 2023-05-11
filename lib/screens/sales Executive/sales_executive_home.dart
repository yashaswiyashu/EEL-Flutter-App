import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
// import 'package:flutter_app/screens/salesPerson/executive/call_details.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:provider/provider.dart';

class SalesExecutiveHome extends StatefulWidget {
  const SalesExecutiveHome({super.key});

  @override
  State<SalesExecutiveHome> createState() => _SalesExecutiveHomeState();
}

class _SalesExecutiveHomeState extends State<SalesExecutiveHome> {
  final AuthService _auth = AuthService();
  var salesExecutive;
  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<UserModel?>(context);
    final salesTable = Provider.of<List<SalesPersonModel?>?>(context);

    if (salesTable != null) {
      salesTable.forEach((element) {
        if (element?.uid == currentUser?.uid) {
          salesExecutive = element;
        }
      });
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Efficient Lights'),
        backgroundColor: const Color(0xff4d47c3),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await _auth.signout();
              Navigator.pushNamed(context, 'home');
            }, 
            icon: const Icon(Icons.person, color: Colors.white,), 
            label: const Text('logout', style: TextStyle(color: Colors.white),)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 440,
          height: 800,
          color: Colors.white,
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 0.4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(right: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  Text(
                    'Name: ${salesExecutive.name}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                ]),
              ),
              Container(
                width: 180,
                height: 60,
                child:  Image.asset('assets/logotm.jpg'),
              ),
              SizedBox(height: 20.80),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'callDetailsList');
                },
                child: Container(
                  width: 297,
                  height: 115,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 297,
                        height: 115,
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
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 9,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 25,
                              child: Text(
                                "Call Details",
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
              ),
              SizedBox(height: 20.80),
              TextButton(
                onPressed: () {
                  
                },
                child: Container(
                  width: 323,
                  height: 115,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 297,
                        height: 115,
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
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 9,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 25,
                              child: Text(
                                "Sales Details",
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
              ),
              SizedBox(height: 20.80),
              TextButton(
                onPressed: (){},
                child: Container(
                  width: 323,
                  height: 115,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 297,
                        height: 115,
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
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 9,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 110,
                              height: 25,
                              child: Text(
                                "Pending order",
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
              ),
              SizedBox(height: 20.80),
              TextButton(
                onPressed: (){},
                child: Container(
                  width: 323,
                  height: 105,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 297,
                        height: 115,
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
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 9,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 170,
                              height: 30,
                              child: Text(
                                "Pending complaints",
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
              ),
              SizedBox(height: 20.80),
              SizedBox(
                height: 59,
                width: 350,
                child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                            ElevatedButton(
                              onPressed: () async {
                                
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Color(0xff4d47c3),),
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
                                  padding: const EdgeInsets.only(top: 18, bottom: 17, ),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children:const [
                                          SizedBox(
                                              width: 80,
                                              child: Text(
                                                  "Customer",
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
                            const SizedBox(width: 55,),
                            ElevatedButton(
                              onPressed: () {
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Color(0xff4d47c3),),
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
                                  padding: const EdgeInsets.only(top: 18, bottom: 17, ),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children:const [
                                          SizedBox(
                                              width: 70,
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
                            ),
                        ],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}