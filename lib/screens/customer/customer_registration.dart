import 'package:flutter/material.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/customer_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomerRegistration extends StatefulWidget {
  const CustomerRegistration({super.key});

  @override
  State<CustomerRegistration> createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  String dropdownInt1 = 'Product 1';
  String dropdownInt2 = 'Product 1';
  String dropdownInt3 = 'Product 1';
  String dropdownInt4 = 'Product 1';
  String dropdownUses1 = 'Place 1';
  String dropdownUses2 = 'Place 1';
  String dropdownUses3 = 'Place 1';
  String dropdownUses4 = 'Place 1';

  // text field state
  String customerName = '';
  String mobileNumber = '';
  String email = '';
  String password = '';
  String address1 = '';
  String address2 = '';
  String city = '';
  String state = '';
  String pincode = '';

  String error = '';
  bool _passwordVisible = false;

 void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      appBar: AppBar(
        title: const Text('Energy Efficient Lights'),
        backgroundColor: const Color(0xff4d47c3),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 75),
                width: 180,
                height: 60,
                child: Image.asset('assets/logotm.jpg'),
              ),
              const SizedBox(height: 20.0),
              const SizedBox(
                height: 20.0,
                child: Text(
                  "Customer Name:",
                  style: TextStyle(
                    color: Color(0xff090a0a),
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Customer Name',
                    fillColor: const Color(0xfff0efff)),
                validator: (value) => value!.isEmpty ? 'Enter Customer Name' : null,
                onChanged: (val) {
                  customerName = val;
                },
              ),
              const SizedBox(height: 20.0),
              const SizedBox(
                  height: 20.0,
                  child: Text(
                    'Customer Mobile Number:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Customer Mobile Number',),
                validator: (value) => value!.length < 10 ? 'Enter Customer Mobile Number' : null,
                onChanged: (val) {
                  mobileNumber = val;
                },
              ),
              const SizedBox(height: 20.0),
              const SizedBox(
                  height: 20.0,
                  child: Text(
                    'Email:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                    hintText: 'Enter Customer Email',),
                validator: (value) => value!.isEmpty ? 'Enter Customer Email' : null,
                onChanged: (val) {
                  setState(() {
                    
                  email = val;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              const SizedBox(
                  height: 20.0,
                  child: Text(
                    'Password:',
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: !_passwordVisible,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Password',suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                        _passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                        ),
                    onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                            _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                validator: (value) => value!.length < 6 ? 'Enter a password of more than 6 characters' : null,
                onChanged: (val) {
                  setState(() {
                    
                  password = val;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              const SizedBox(height: 20.0, child: Text('Customer Full Address:', style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                  ),)),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(hintText: 'house#, area'),
                validator: (value) => value!.isEmpty ? 'Enter Customer Full Address' : null,
                onChanged: (val) {
                  setState(() {
                    
                  address1 = val;
                  });
                },
              ),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(hintText: 'town, taluk'),
                validator: (value) => value!.isEmpty ? 'Enter Customer Full Address' : null,
                onChanged: (val) {
                  setState(() {
                    
                  address2 = val;
                  });
                },
              ),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(hintText: 'city'),
                validator: (value) => value!.isEmpty ? 'Enter Customer Full Address' : null,
                onChanged: (val) {
                  setState(() {
                  city = val;
                  });
                },
              ),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(hintText: 'state'),
                validator: (value) => value!.isEmpty ? 'Enter Customer Full Address' : null,
                onChanged: (val) {
                  setState(() {
                    state = val;
                  });
                },
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'pincode'),
                validator: (value) => value!.isEmpty ? 'Enter Customer Full Address' : null,
                onChanged: (val) {
                  setState(() {
                    pincode = val;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              const SizedBox(
                height: 20.0,
                child: Text('Interested in:', style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                  ),),
              ),
              const SizedBox(height: 20.0,),

              //curousel
              SizedBox(
                height: 100,
                width: 440,
                child: ListView(
                  children: [
                    CarouselSlider(
                      items: [
                        Container(
                          // margin: const EdgeInsets.only(right: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            width: 385,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 135,
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
                                    value: dropdownInt1,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownInt1 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Product 1',
                                      'Product 2',
                                      'Product 3',
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
                                const SizedBox(width: 2.0,),
                                SizedBox(
                                  width: 135,
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
                                    value: dropdownInt2,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownInt2 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Product 1',
                                      'Product 2',
                                      'Product 3',
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
                              ],
                            ),
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(right: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            width: 385,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 135,
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
                                    value: dropdownInt3,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownInt3 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Product 1',
                                      'Product 2',
                                      'Product 3',
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
                                const SizedBox(width: 2.0,),
                                SizedBox(
                                  width: 135,
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
                                    value: dropdownInt4,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownInt4 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Product 1',
                                      'Product 2',
                                      'Product 3',
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
                              ],
                            ),
                          ),
                        ),
                      ], 
                      options: CarouselOptions(
                          height: 100.0,
                          enlargeCenterPage: true,
                          autoPlay: false,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                      ),
                  ]),
              ),
              const SizedBox(height: 20.0),
              const SizedBox(
                height: 20.0,
                child: Text('Uses at:', style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                  ),),
              ),
              const SizedBox(height: 20.0,),

              //curousel
              SizedBox(
                height: 100,
                width: 440,
                child: ListView(
                  children: [
                    CarouselSlider(
                      items: [
                        Container(
                          // margin: const EdgeInsets.only(right: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            width: 415,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 135,
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
                                    value: dropdownUses1,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownUses1 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Place 1',
                                      'Place 2',
                                      'Place 3',
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
                                const SizedBox(width: 2.0,),
                                SizedBox(
                                  width: 135,
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
                                    value: dropdownUses2,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownUses2 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                    'Place 1',
                                    'Place 2',
                                    'Place 3',
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
                              ],
                            ),
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(right: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            width: 415,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 135,
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
                                    value: dropdownUses3,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownUses3 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Place 1',
                                      'Place 2',
                                      'Place 3',
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
                                const SizedBox(width: 2.0,),
                                SizedBox(
                                  width: 135,
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
                                    value: dropdownUses4,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownUses4 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Place 1',
                                      'Place 2',
                                      'Place 3',
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
                              ],
                            ),
                          ),
                        ),
                      ], 
                      options: CarouselOptions(
                          height: 100.0,
                          enlargeCenterPage: true,
                          autoPlay: false,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                      ),
                  ]),
              ),
            
              const SizedBox(height: 20.0,),
              SizedBox(
                height: 59,
                width: 420,
                child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                            ElevatedButton(
                              onPressed: () async {
                                if(_formkey.currentState!.validate()){
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                                  if(result == null){
                                    setState(() {
                                      error = 'please supply a valid email';
                                      loading = false;
                                    });
                                  } else {
                                    if(result?.uid != null){
                                      await CustomerDatabaseService(uid: result!.uid)
                                      .updateUserData(
                                        result?.uid,
                                        customerName,
                                        mobileNumber,
                                        email,
                                        password,
                                        address1,
                                        address2,
                                        city,
                                        state,
                                        pincode,
                                        dropdownInt1,
                                        dropdownInt2,
                                        dropdownInt3,
                                        dropdownInt4,
                                        dropdownUses1,
                                        dropdownUses2,
                                        dropdownUses3,
                                        dropdownUses4,
                                      );
                                      loading = false;
                                      Navigator.pushNamed(context, 'customerHomePage');
                                    }
                                  }
                                }
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
                                              width: 90,
                                              child: Text(
                                                  "Register",
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
                                Navigator.pushNamed(context, 'home');
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
                                                  "Cancel",
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
              const SizedBox(height: 12.0),
              Text(
                error, 
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              const SizedBox(height: 20.0),
              // ElevatedButton(
              //   style:
              //       ElevatedButton.styleFrom(backgroundColor: Colors.pink[400]),
              //   onPressed: () async {
              //     // if(_formkey.currentState!.validate()){
              //     //   setState(() {
              //     //     loading = true;
              //     //   });
              //     //   dynamic result = await _auth.signInWithEmailAndPassword(email, password);
              //     //   if(result == null){
              //     //     setState(() {
              //     //       error = 'unknown user please register';
              //     //       loading = false;
              //     //     });
              //     //   }
              //     // }
              //   },
              //   child: const Text(
              //     'Sign In',
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
              // const SizedBox(height: 12.0),
              // Text(
              //   error,
              //   style: const TextStyle(color: Colors.red, fontSize: 14.0),
              // )
            ],
          ),
        ),
      ),
    );
  }
}