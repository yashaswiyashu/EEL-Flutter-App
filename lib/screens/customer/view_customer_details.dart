import 'package:flutter/material.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/customer_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class ViewCustomerDetails extends StatefulWidget {
  const ViewCustomerDetails({super.key});
  static const routeName = '/viewCustomerDetails';

  @override
  State<ViewCustomerDetails> createState() => _ViewCustomerDetailsState();
}

class _ViewCustomerDetailsState extends State<ViewCustomerDetails> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  String dropdownInt1 = 'Suraksha';
  String dropdownInt2 = 'Suraksha';
  String dropdownInt3 = 'Suraksha';
  String dropdownInt4 = 'Suraksha';
  String dropdownUses1 = 'House';
  String dropdownUses2 = 'House';
  String dropdownUses3 = 'House';
  String dropdownUses4 = 'House';

  // text field state
  String customerName = '';
  String mobileNumber = '';
  String email = '';
  String password = '';
  String address1 = '';
  String address2 = '';
  String city = '';
  String state = 'Select State';
  String pincode = '';

  String error = '';
  bool _passwordVisible = false;

  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Parameter;
    final currentUser = Provider.of<UserModel?>(context);
    final customerTable = Provider.of<List<CustomerModel?>?>(context);
    var obj;

    if (customerTable != null) {
      customerTable.forEach((element) {
        if (element?.uid == args.uid) {
          obj = element;
        }
      });
    }

    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Energy Efficient Lights'),
              backgroundColor: const Color(0xff4d47c3),
              actions: currentUser?.uid != null
                  ? [
                      TextButton.icon(
                          onPressed: () async {
                            await _auth.signout();
                            Navigator.pushNamed(context, 'home');
                          },
                          icon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'logout',
                            style: TextStyle(color: Colors.white),
                          )),
                    ]
                  : null,
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
                      margin: const EdgeInsets.only(left: 100),
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
                      initialValue: obj.customerName,
                      readOnly: true,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Customer Name',
                          fillColor: const Color(0xfff0efff)),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Customer Name' : null,
                      // onChanged: (val) {
                      //   customerName = val;
                      // },
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
                      initialValue: obj.mobileNumber,
                      readOnly: true,
                      keyboardType: TextInputType.phone,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Enter Customer Mobile Number',
                      ),
                      validator: (value) => value!.length < 10
                          ? 'Enter Customer Mobile Number'
                          : null,
                      // onChanged: (val) {
                      //   mobileNumber = val;
                      // },
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
                      initialValue: obj.email,
                      readOnly: true,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Enter Customer Email',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Customer Email' : null,
                      // onChanged: (val) {
                      //   setState(() {
                      //     email = val;
                      //   });
                      // },
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
                      initialValue: obj.password,
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      obscureText: !_passwordVisible,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Enter Password',
                        suffixIcon: IconButton(
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
                      validator: (value) => value!.length < 6
                          ? 'Enter a password of more than 6 characters'
                          : null,
                      // onChanged: (val) {
                      //   setState(() {
                      //     password = val;
                      //   });
                      // },
                    ),
                    const SizedBox(height: 20.0),
                    const SizedBox(
                        height: 20.0,
                        child: Text(
                          'Customer Full Address:',
                          style: TextStyle(
                            color: Color(0xff090a0a),
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: obj.address1,
                      readOnly: true,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'house#, area'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Customer Full Address' : null,
                      // onChanged: (val) {
                      //   setState(() {
                      //     address1 = val;
                      //   });
                      // },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: obj.address2,
                      readOnly: true,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'town, taluk'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Customer Full Address' : null,
                      // onChanged: (val) {
                      //   setState(() {
                      //     address2 = val;
                      //   });
                      // },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: obj.city,
                      readOnly: true,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'city'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Customer Full Address' : null,
                      // onChanged: (val) {
                      //   setState(() {
                      //     city = val;
                      //   });
                      // },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: obj.state,
                      readOnly: true,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'city'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Customer Full Address' : null,
                      // onChanged: (val) {
                      //   setState(() {
                      //     city = val;
                      //   });
                      // },
                    ),
                    // DropdownButtonFormField(
                    //   decoration: const InputDecoration(
                    //     enabledBorder: OutlineInputBorder(
                    //       //<-- SEE HERE
                    //       borderSide: BorderSide(color: Colors.black, width: 0),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       //<-- SEE HERE
                    //       borderSide: BorderSide(color: Colors.black, width: 0),
                    //     ),
                    //     filled: true,
                    //     fillColor: Color(0xffefefff),
                    //   ),
                    //   dropdownColor: const Color(0xffefefff),
                    //   value: obj.state,
                    //   onChanged: (String? newValue) {
                    //     // setState(() {
                    //     //   state = newValue!;
                    //     // });
                    //   },
                    //   items: <String>[
                    //     obj.state,
                    //   ].map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(
                    //         value,
                    //         style: const TextStyle(fontSize: 15),
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: obj.pincode,
                      readOnly: true, keyboardType: TextInputType.phone,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'pincode'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Customer Full Address' : null,
                      // onChanged: (val) {
                      //   setState(() {
                      //     pincode = val;
                      //   });
                      // },
                    ),

                    const SizedBox(height: 10.0),
                    const SizedBox(
                      height: 20.0,
                      child: Text(
                        'Interested in:',
                        style: TextStyle(
                          color: Color(0xff090a0a),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),

                    //curousel
                    SizedBox(
                      height: 100,
                      width: 440,
                      child: ListView(children: [
                        CarouselSlider(
                          items: [
                            Container(
                              // margin: const EdgeInsets.only(right: 0.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: SizedBox(
                                width: 440,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 140,
                                      child: TextFormField(
                                        initialValue: obj.product1,
                                        readOnly: true,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) => value!.isEmpty
                                            ? 'Enter Customer Full Address'
                                            : null,
                                        // onChanged: (val) {
                                        //   setState(() {
                                        //     pincode = val;
                                        //   });
                                        // },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25.0,
                                    ),
                                    SizedBox(
                                      width: 140,
                                      child: TextFormField(
                                        initialValue: obj.product2,
                                        readOnly: true,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) => value!.isEmpty
                                            ? 'Enter Customer Full Address'
                                            : null,
                                        // onChanged: (val) {
                                        //   setState(() {
                                        //     pincode = val;
                                        //   });
                                        // },
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
                                width: 440,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 140,
                                      child: TextFormField(
                                        initialValue: obj.product3,
                                        readOnly: true,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) => value!.isEmpty
                                            ? 'Enter Customer Full Address'
                                            : null,
                                        // onChanged: (val) {
                                        //   setState(() {
                                        //     pincode = val;
                                        //   });
                                        // },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25.0,
                                    ),
                                    SizedBox(
                                      width: 140,
                                      child: TextFormField(
                                        initialValue: obj.product4,
                                        readOnly: true,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) => value!.isEmpty
                                            ? 'Enter Customer Full Address'
                                            : null,
                                        // onChanged: (val) {
                                        //   setState(() {
                                        //     pincode = val;
                                        //   });
                                        // },
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
                            enableInfiniteScroll: false,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 10.0),
                    const SizedBox(
                      height: 20.0,
                      child: Text(
                        'Uses at:',
                        style: TextStyle(
                          color: Color(0xff090a0a),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),

                    //curousel
                    SizedBox(
                      height: 100,
                      width: 440,
                      child: ListView(children: [
                        CarouselSlider(
                          items: [
                            Container(
                              // margin: const EdgeInsets.only(right: 0.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: SizedBox(
                                width: 440,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 155,
                                      child: TextFormField(
                                        initialValue: obj.place1,
                                        readOnly: true,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) => value!.isEmpty
                                            ? 'Enter Customer Full Address'
                                            : null,
                                        // onChanged: (val) {
                                        //   setState(() {
                                        //     pincode = val;
                                        //   });
                                        // },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 19.0,
                                    ),
                                    SizedBox(
                                      width: 155,
                                      child: TextFormField(
                                        initialValue: obj.place2,
                                        readOnly: true,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) => value!.isEmpty
                                            ? 'Enter Customer Full Address'
                                            : null,
                                        // onChanged: (val) {
                                        //   setState(() {
                                        //     pincode = val;
                                        //   });
                                        // },
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
                                      width: 155,
                                      child: TextFormField(
                                        initialValue: obj.place3,
                                        readOnly: true,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) => value!.isEmpty
                                            ? 'Enter Customer Full Address'
                                            : null,
                                        // onChanged: (val) {
                                        //   setState(() {
                                        //     pincode = val;
                                        //   });
                                        // },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 19.0,
                                    ),
                                    SizedBox(
                                      width: 155,
                                      child: TextFormField(
                                        initialValue: obj.place4,
                                        readOnly: true,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) => value!.isEmpty
                                            ? 'Enter Customer Full Address'
                                            : null,
                                        // onChanged: (val) {
                                        //   setState(() {
                                        //     pincode = val;
                                        //   });
                                        // },
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
                            enableInfiniteScroll: false,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                          ),
                        ),
                      ]),
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 59,
                      width: 420,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff4d47c3),
                            ),
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
                              padding: const EdgeInsets.only(
                                top: 18,
                                bottom: 17,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
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
                  ],
                ),
              ),
            ),
          );
  }
}
