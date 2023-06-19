import 'package:flutter/material.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/shared/loading.dart';
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

    globalcontext = context;
    screenHeight = MediaQuery.of(globalcontext).size.height;
    screenWidth =  MediaQuery.of(globalcontext).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Energy Efficient Lights', style: TextStyle(fontSize: screenHeight / 50)),
        backgroundColor:const Color(0xff4d47c3),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight - 100,
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
                  width: screenWidth / 3,
                  height: screenHeight / 10,
                  child: Image.asset('assets/logotm.jpg'),
                ),
                SizedBox(
                  height: screenHeight / 80,
                ),
                SizedBox(
                    width: screenWidth - 100,
                    height: screenHeight / 15,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth - 100,
                          height: screenHeight / 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(33),
                            color: const Color(0xffa7a2ff),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: left,
                                top: 7,
                                child: Container(
                                  width: (screenWidth - 100) / 2,
                                  height: screenHeight / 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(33),
                                    color: const Color(0xff4d47c3),
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                TextButton(
                                  onPressed: () {
                                        setState(() {
                                          left = 18.0;
                                          login = true;
                                        });
                                      },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [SizedBox(
                                        width: screenWidth / 7,
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenHeight / 50,
                                          ),
                                        )),]
                                  ),
                                ),
                                  TextButton(
                                    onPressed: () {
                                        setState(() {
                                          left = (screenWidth - 130) / 2;
                                          login = false;
                                        });
                                      },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [SizedBox(
                                        width: screenWidth / 6,
                                        child: Text(
                                          'New user',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenHeight / 50,
                                          ),
                                        )),]
                                    ),
                                  ),
                                ]
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