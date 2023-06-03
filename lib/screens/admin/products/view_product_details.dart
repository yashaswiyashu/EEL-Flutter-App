import 'dart:io';


import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/firebase_storage.dart';
import 'package:flutter_app/services/products_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';



class ViewProductAdmin extends StatefulWidget {
  const ViewProductAdmin({super.key});
  static const routeName = '/viewProductDetails';

  @override
  State<ViewProductAdmin> createState() => _ViewProductAdminState();
}


class _ViewProductAdminState extends State<ViewProductAdmin> {
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  File? _image;
  String path = '';
  late String fileName = '';
  bool imgupload = false;

  String name = '';
  String imageUrl = '';
  String price = '';
  String offers = '';
  String description = '';
  String status = '';



  @override
  Widget build(BuildContext context) {
      final AuthService _auth = AuthService();
    ImageProvider imageProvider;
    final args = ModalRoute.of(context)!.settings.arguments as Parameter;

    final StorageService storage = StorageService(); 

    final productDetails = Provider.of<List<ProductDetailsModel>>(context);
    var obj;
    if (productDetails != null) {
      productDetails.forEach((element) {
        if (element.uid == args.uid) {
          obj = element;
        }
      });
    }

    if (obj != null) {
      name = obj.name;
      imageUrl = obj.imageUrl;
      price = obj.price;
      offers = obj.offers;
      description = obj.description;
    }

    return Scaffold(
            appBar: AppBar(
              title: const Text('Energy Efficient Lights'),
              backgroundColor: const Color(0xff4d47c3),
              actions: [
                TextButton.icon(
                    onPressed: () async {
                      await _auth.signout();
                      Navigator.of(context).pushNamedAndRemoveUntil('authWrapper',(Route<dynamic> route) => false);
                    },
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'logout',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                top: 18,
              ),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 95),
                      width: 180,
                      height: 60,
                      child: Image.asset('assets/logotm.jpg'),
                    ),
                    const SizedBox(height: 20.0),
                    const SizedBox(
                      height: 20.0,
                      child: Text(
                        "Product Name:",
                        style: TextStyle(
                          color: Color(0xff090a0a),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: name,
                      readOnly: true,
                      validator: (value) =>
                          value!.isEmpty ? 'Missing Field' : null,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Your Name',
                          fillColor: const Color(0xfff0efff)),
                      // onChanged: (val) {
                      //   setState(() {
                      //     name = val;
                      //   });
                      // },
                    ),
                    SizedBox(height: 20),
                    const SizedBox(
                      height: 30.0,
                      child: Text(
                        "Upload Image:",
                        style: TextStyle(
                          color: Color(0xff090a0a),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 20.0,
                    //   child: Text(
                    //     "Image:",
                    //     style: TextStyle(
                    //       color: Color(0xff090a0a),
                    //       fontSize: 16,
                    //       fontFamily: "Inter",
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   width: 327,
                    //   height: 132,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Image.asset('assets/logotm.jpg'),
                    // ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                          width: 280,
                          height: 150,
                          child: Stack(
                            children: [
                              Container(
                                child: FutureBuilder(
                                  future: storage.downloadURL(imageUrl),
                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                    if(snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData){
                                      return CircularProgressIndicator();
                                    }

                                    if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                      return Image.network(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                      );
                                    } 

                                    return Container();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ]),
                    const SizedBox(height: 20.0),
                    const SizedBox(
                      height: 20.0,
                      child: Text(
                        "Product Price(In Rs.):",
                        style: TextStyle(
                          color: Color(0xff090a0a),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: price,
                      readOnly: true,
                      validator: (value) => value!.isEmpty
                        ? 'Enter Product Price'
                            : null,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Product Price',
                          fillColor: const Color(0xfff0efff)),
                      // onChanged: (val) {
                      //   setState(() {
                      //     price = val;
                      //   });
                      // },
                    ),
                    const SizedBox(height: 20.0),
                    const SizedBox(
                      height: 20.0,
                      child: Text(
                        "Offers(In Percentage):",
                        style: TextStyle(
                          color: Color(0xff090a0a),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: offers,
                      readOnly: true,
                      validator: (value) => value!.isEmpty
                        ? 'Enter Discount Percentage'
                            : null,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Discount Percentage',
                          fillColor: const Color(0xfff0efff)),
                      // onChanged: (val) {
                      //   setState(() {
                      //     offers = '$val%';
                      //   });
                      // },
                    ),
                    const SizedBox(height: 20.0),
                    const SizedBox(
                      height: 20.0,
                      child: Text(
                        "Product Description:",
                        style: TextStyle(
                          color: Color(0xff090a0a),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: 440,
                      height: 100.0,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xffe3e4e5)),
                        color: Color(0xfff0efff),
                      ),
                      child: TextFormField(
                      initialValue: description,
                      readOnly: true,
                        validator: (value) =>
                          value!.isEmpty ? 'Missing Field' : null,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Enter Product Description',
                          fillColor: const Color(0xfff0efff),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        // onChanged: (val) {
                        //   setState(() {
                        //     description = val;
                        //   });
                        // },
                      ),
                    ),
                    const SizedBox(height: 5.0),
                      Container(
                        margin: const EdgeInsets.only(left: 110),
                        child: Text(
                          status,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                    const SizedBox(
                      height: 20.0,
                    ),
                    loading ? const CircularProgressIndicator() : SizedBox(
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
                              width: 80,
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
                                      "Back",
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
                    SizedBox(
                      height: 40.0,
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
