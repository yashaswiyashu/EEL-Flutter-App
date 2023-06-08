import 'package:flutter/material.dart';
import 'package:flutter_app/wrappers/home_wrapper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var left = 18.0;
  Color color = const Color(0xff4d47c3);
  bool login = true;
  String dropdownValue = 'Customer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Efficient Lights'),
        backgroundColor:const Color(0xff4d47c3),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 440,
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
                SizedBox(
                  width: 180,
                  height: 60,
                  child: Image.asset('assets/logotm.jpg'),
                ),
                const SizedBox(
                  height: 20.80,
                ),
                SizedBox(
                    width: 344,
                    height: 59,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 344,
                          height: 59,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(33),
                            color: const Color(0xffa7a2ff),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: left,
                                top: 9,
                                child: Container(
                                  width: 143.78,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(33),
                                    color: const Color(0xff4d47c3),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 195,
                                top: 5,
                                child: SizedBox(
                                    width: 104.45,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          left = 170.0;
                                          login = false;
                                        });
                                      },
                                      child: const Text(
                                        'New user',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )),
                              ),
                              Positioned(
                                left: 50,
                                top: 5,
                                child: SizedBox(
                                    width: 76.29,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          left = 18.0;
                                          login = true;
                                        });
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                //here
                HomeWrapper(login: login),
              ]),
        ),
      ),
    );
  }
}