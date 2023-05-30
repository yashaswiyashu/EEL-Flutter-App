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



class EditProductAdmin extends StatefulWidget {
  const EditProductAdmin({super.key});
  static const routeName = '/editProductDetails';

  @override
  State<EditProductAdmin> createState() => _EditProductAdminState();
}


class _EditProductAdminState extends State<EditProductAdmin> {
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  File? _image;
  String path = '';
  late String fileName = '';
  bool imgupload = false;

  final controllerName = TextEditingController();
  final controllerPrice = TextEditingController();
  final controllerOffers = TextEditingController();
  final controllerDescription = TextEditingController();

  String name = '';
  String imageUrl = '';
  String price = '';
  String offers = '';
  String description = '';
  String status = '';

  @override
  initState() {
    super.initState();

    // Start listening to changes.
    controllerName.addListener(_saveName);
    controllerPrice.addListener(_savePrice);
    controllerOffers.addListener(_saveOffers);
    controllerDescription.addListener(_saveDescription);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    controllerName.dispose();
    controllerPrice.dispose();
    controllerOffers.dispose();
    controllerDescription.dispose();
    super.dispose();
  }

  void _saveName() {
    name = controllerName.text;
  }

  void _savePrice() {
    price = controllerPrice.text;
  }

  void _saveOffers() {
    offers = controllerOffers.text;
  }

  void _saveDescription() {
    description = controllerDescription.text;
  }

  void showConfirmation(String uid) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Do you want to delete entire document?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // passing false
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // passing true
                child: Text('Yes'),
              ),
            ],
          );
        }).then((exit) {
      if (exit == null) return;
      if (exit) {
        // user pressed Yes button
        ProductDatabaseService(docid: uid).deleteUserData();
        Navigator.pop(context);
      } else {
        // user pressed No button
        // Navigator.pop(context);
        return;
      }
    });
  }


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
      controllerName.text = obj.name;
      imageUrl = obj.imageUrl;
      controllerPrice.text = obj.price;
      controllerOffers.text = obj.offers;
      controllerDescription.text = obj.description;
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
                      controller: controllerName,
                      validator: (value) =>
                          value!.isEmpty ? 'Missing Field' : null,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Product Name',
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
                      TextButton(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.image,
                          );

                          if(result == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No image selected!!'))
                            );
                            return null;
                          }

                          path = result.files.single.path!;
                          fileName = result.files.single.name;
                          setState(() {
                            imgupload = true;
                            imageUrl = fileName;
                          });
                          storage.uploadFile(path, fileName).then((value) {
                            setState(() {
                              imgupload = false;
                            });
                          });

                        },
                        child: fileName == '' ? SizedBox(
                          width: 280,
                          height: 150,
                          child: Stack(
                            children: [
                              // Default image
                              imgupload ? CircularProgressIndicator() : Container(
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
                        ) : SizedBox(
                          width: 350,
                          height: 150,
                          child: Stack(
                            children: [
                              // Default image
                              imgupload ? CircularProgressIndicator() : Container(
                                child: FutureBuilder(
                                  future: storage.downloadURL(fileName),
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


                              // // Edit button
                              // Positioned(
                              //   bottom: 0,
                              //   right: 0,
                              //   child: IconButton(
                              //     style: IconButton.styleFrom(
                              //         backgroundColor: Colors.white),
                              //     icon: Icon(
                              //       Icons.edit,
                              //     ),
                              //     onPressed: getImage,
                              //   ),
                              // ),
                            ],
                          ),
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
                      controller: controllerPrice,
                      /* validator: (value) => value!.isEmpty
                        ? 'Enter Product Price'
                            : null, */
                      validator: (value) => RegExp(r'^\d+(\.\d+)?$').hasMatch(price) && price != '0'
                        ? null
                            : 'Enter Product Price',                            
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
                      controller: controllerOffers,
                    /*   validator: (value) => value!.isEmpty
                        ? 'Enter Discount Percentage'
                            : null, */
                      validator: (value) => RegExp(r'^\d+(\.\d+)?$').hasMatch(offers) && (double.tryParse(offers)! < 100)
                        ? null
                            : 'Enter Discount Percentage',
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
                        controller: controllerDescription,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                    if(imageUrl == ''){
                                      setState(() {
                                        loading = false;
                                        status = 'Please select an image';
                                      });
                                      return;
                                    }
                                    setState(() {
                                      loading = true;
                                    });
                                    await ProductDatabaseService(docid: args.uid)
                                      .updateUserData(
                                        name,
                                        fileName == '' ? imageUrl : fileName,
                                        price,
                                        offers,
                                        description,
                                      )
                                      .then((value) => setState(() {
                                        loading = false;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Product details added successfully!!'))
                                        );
                                        Navigator.pop(context);
                                      }));
                                  } else {
                                    setState(() {
                                      loading = false;
                                      status = 'Please fill all the fields';
                                    });
                                  }
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      "Save",
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
                          ElevatedButton(
                              // autogroupqdj5BoM (UPthV8mGmAE7wuU648qDj5)
                              onPressed: () {
                                showConfirmation(obj!.uid);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Container(
                                width: 110,
                                height: 59,
                                decoration: BoxDecoration(
                                  color: Color(0xff4d47c3),
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x664d47c3),
                                      offset: Offset(0, 4),
                                      blurRadius: 30.5,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Delete',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
