import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/services/auth.dart';

class UserSelection extends StatefulWidget {
  const UserSelection({super.key});

  @override
  State<UserSelection> createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              title: Text('Energy Efficient Lights', style: TextStyle(fontSize: screenHeight / 50)),
              backgroundColor: const Color(0xff4d47c3),
              actions: [
                TextButton.icon(
                    onPressed: () async {
                      await _auth.signout();
                      Navigator.of(context).pushNamedAndRemoveUntil('authWrapper',(Route<dynamic> route) => false);
                    },
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: screenHeight / 50,
                    ),
                    label: Text(
                      'logout',
                      style: TextStyle(color: Colors.white,  fontSize: screenHeight / 50),
                    )),
              ],
            ),
      body: Container(
      width: screenWidth,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 14,),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
              Container(
                width: screenWidth / 3,
                height: screenHeight / 10,
                child: Image.asset('assets/logotm.jpg'),
              ),
              const SizedBox(height: 20.0),
              const SizedBox(height: 5,),
              SizedBox(height: 3, width: screenWidth / 2, child: Container(color: Colors.black,),),
              const SizedBox(height: 20.20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'salesCoOrdList');
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
                    padding: const EdgeInsets.only(left: 84, right: 100, top: 17, bottom: 18, ),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Text(
                                "Sales Co-Ordinator",
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
                  Navigator.pushNamed(context, 'salesExecList');
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
                    padding: const EdgeInsets.only(left: 89, right: 90, top: 17, bottom: 18, ),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Text(
                                "Sales Executive",
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
                  Navigator.pushNamed(context, 'customerListAdmin');
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
    ),
    );
  }
}