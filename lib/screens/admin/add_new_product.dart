import 'dart:io';


import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/firebase_storage.dart';
import 'package:flutter_app/services/products_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';



class AddProductAdmin extends StatefulWidget {
  const AddProductAdmin({super.key});


  @override
  State<AddProductAdmin> createState() => _AddProductAdminState();
}


class _AddProductAdminState extends State<AddProductAdmin> {
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
    ImageProvider imageProvider;

    final StorageService storage = StorageService(); 


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
                      validator: (value) =>
                          value!.isEmpty ? 'Missing Field' : null,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Product Name',
                          fillColor: const Color(0xfff0efff)),
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
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
                            type: FileType.custom,
                            allowedExtensions: ['png', 'jpg'],
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
                        child:SizedBox(
                          width: 350,
                          height: 150,
                          child: fileName == '' ? Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/upload.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ) :Stack(
                            children: [
                              // Default image
                              imgupload ? CircularProgressIndicator() : Container(
                                child: FutureBuilder(
                                  future: storage.downloadURL(fileName),
                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                      validator: (value) => value!.isEmpty
                        ? 'Enter Product Price'
                            : null,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Product Price',
                          fillColor: const Color(0xfff0efff)),
                      onChanged: (val) {
                        setState(() {
                          price = val;
                        });
                      },
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
                      validator: (value) => value!.isEmpty
                        ? 'Enter Discount Percentage'
                            : null,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Discount Percentage',
                          fillColor: const Color(0xfff0efff)),
                      onChanged: (val) {
                        setState(() {
                          offers = '$val%';
                        });
                      },
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xffe3e4e5)),
                        color: Color(0xfff0efff),
                      ),
                      child: TextFormField(
                        validator: (value) =>
                          value!.isEmpty ? 'Missing Field' : null,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: '   Enter Product Description',
                          fillColor: const Color(0xfff0efff),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        onChanged: (val) {
                          setState(() {
                            description = val;
                          });
                        },
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
                                    await ProductDatabaseService(docid: '')
                                      .setUserData(
                                        name,
                                        imageUrl,
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    width: 90,
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
                          const SizedBox(
                            width: 85,
                          ),
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