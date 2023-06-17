import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/services/auth.dart';
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

    final controllerOffer = TextEditingController();

  @override
  initState() {
    super.initState();

    // Start listening to changes.
    controllerOffer.addListener(_saveOffer);
  }

    @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
  controllerOffer.dispose();
    super.dispose();
  }

  void _saveOffer() {
    offers = controllerOffer.text;
  }

  
  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    final AuthService _auth = AuthService();
    //controllerOffer.text = '0.00';

    final StorageService storage = StorageService(); 


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
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                top: 18,
              ),
              child: Container(
                width: screenWidth,
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: screenWidth / 3,
                              height: screenHeight / 10,
                            child: Image.asset('assets/logotm.jpg'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: screenHeight / 40,
                        child: Text(
                          "Product Name:",
                          style: TextStyle(
                            color: Color(0xff090a0a),
                            fontSize: screenHeight / 50,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: screenHeight / 50),
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
                      SizedBox(
                        height: screenHeight / 40,
                        child: Text(
                          "Upload Image:",
                          style: TextStyle(
                            color: Color(0xff090a0a),
                            fontSize: screenHeight / 50,
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
                          child:SizedBox(
                            width: screenWidth / 2,
                            height: screenHeight / 6,
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
                      SizedBox(
                        height: screenHeight / 40,
                        child: Text(
                          "Product Price(In Rs.):",
                          style: TextStyle(
                            color: Color(0xff090a0a),
                            fontSize: screenHeight / 50,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: screenHeight / 50),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => RegExp(r'^\d+(\.\d+)?$').hasMatch(price) && price != '0'
                          ? null
                              : 'Enter Product Price',
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
                      SizedBox(
                        height: screenHeight / 40,
                        child: Text(
                          "Offers(In Percentage):",
                          style: TextStyle(
                            color: Color(0xff090a0a),
                            fontSize: screenHeight/50,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: screenHeight / 50),
                        controller: controllerOffer,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => RegExp(r'^\d+(\.\d+)?$').hasMatch(offers) && double.tryParse(offers)! < 100
                          ? null
                              : 'Enter Discount Percentage',
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Enter Discount Percentage',
                            fillColor: const Color(0xfff0efff)),
                         /* onChanged: (val) {
                           setState(() {
                             offers = val;//'$val%';
                           });
                         }, */
                      ),
                      const SizedBox(height: 20.0),
                       SizedBox(
                        height: screenHeight / 40,
                        child: Text(
                          "Product Description:",
                          style: TextStyle(
                            color: Color(0xff090a0a),
                            fontSize: screenHeight / 50,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: screenHeight / 10,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xffe3e4e5)),
                          color: Color(0xfff0efff),
                        ),
                        child: TextFormField(
                          style: TextStyle(fontSize: screenHeight / 50),
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
                          onChanged: (val) {
                            setState(() {
                              description = val;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                status,
                                style:
                                   TextStyle(color: Colors.red, fontSize: screenHeight / 60),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                      const SizedBox(
                        height: 20.0,
                      ),
                      loading ? const CircularProgressIndicator() : SizedBox(
                        height: screenHeight / 15,
                        width: screenWidth,
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
                                width: screenWidth / 6,
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
                                padding: const EdgeInsets.only(
                                  top: 18,
                                  bottom: 17,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: screenWidth / 6,
                                      child: Text(
                                        "Save",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenHeight / 50,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff4d47c3),
                              ),
                              child: Container(
                                width: screenWidth / 6,
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
                                padding: const EdgeInsets.only(
                                  top: 18,
                                  bottom: 17,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: screenWidth / 6,
                                      child: Text(
                                        "Cancel",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenHeight / 50,
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
            ),
          );
  }
}

// class DecimalTextInputFormatter extends TextInputFormatter {
//   DecimalTextInputFormatter({required this.decimalRange})
//       : assert(decimalRange == null || decimalRange > 0);

//   final int decimalRange;

//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue, // unused.
//     TextEditingValue newValue,
//   ) {
//     TextSelection newSelection = newValue.selection;
//     String truncated = newValue.text;

//     if (decimalRange != null) {
//       String value = newValue.text;

//       if (value.contains(".") &&
//           value.substring(value.indexOf(".") + 1).length > decimalRange) {
//         truncated = oldValue.text;
//         newSelection = oldValue.selection;
//       } else if (value == ".") {
//         truncated = "0.";

//         newSelection = newValue.selection.copyWith(
//           baseOffset: math.min(truncated.length, truncated.length + 1),
//           extentOffset: math.min(truncated.length, truncated.length + 1),
//         );
//       }

//       return TextEditingValue(
//         text: truncated,
//         selection: newSelection,
//         composing: TextRange.empty,
//       );
//     }
//     return newValue;
//   }
// }