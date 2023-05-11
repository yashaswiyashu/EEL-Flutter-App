import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SalesCoOrdinatorHome extends StatefulWidget {
  const SalesCoOrdinatorHome({super.key});

  @override
  State<SalesCoOrdinatorHome> createState() => _SalesCoOrdinatorHomeState();
}

class _SalesCoOrdinatorHomeState extends State<SalesCoOrdinatorHome> {
  
  String executive = 'executive 1';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Efficient Lights'),
        backgroundColor: const Color(0xff4d47c3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
          top: 18,
        ),
        child: Container(
          width: 360,
          height: 800,
          color: Colors.white,
          padding: const EdgeInsets.only(
            left: 19,
            right: 16,
            top: 10,
            bottom: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 180,
                height: 60,
                child:  Image.asset('assets/logotm.jpg'),
              ),
              SizedBox(height: 20.80),
              SizedBox(
                height: 60,
                width: 160,
                child: DropdownButtonFormField(
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
                        value: executive,
                        onChanged: (String? newValue) {
                          setState(() {
                            executive = newValue!;
                          });
                        },
                        items: <String>[
                          'executive 1',
                          'executive 2',
                          'executive 3',
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
              ),
              SizedBox(height: 20.0,),
              Container(
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
                        right: 10,
                        top: 9,
                        bottom: 81,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 92,
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
              SizedBox(height: 20.80),
              Container(
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
                        right: 10,
                        top: 9,
                        bottom: 81,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 93,
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
              SizedBox(height: 20.80),
              Container(
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
                        right: 10,
                        top: 9,
                        bottom: 81,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 101,
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
              SizedBox(height: 20.80),
              Container(
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
                        right: 10,
                        top: 9,
                        bottom: 81,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 145,
                            height: 25,
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
              SizedBox(height: 30.80),
              Container(
                width: 317,
                height: 60,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
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
                      padding: const EdgeInsets.only(
                        left: 30,
                        right: 26,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 73,
                            height: 24.41,
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
                    SizedBox(width: 17),
                    Container(
                      width: 150,
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
                      padding: const EdgeInsets.only(
                        left: 26,
                        right: 30,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 93,
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
        ),
      ),
    );
  }
}