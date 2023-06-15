import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/edit_details_model.dart';
import 'package:flutter_app/models/order_details_model.dart';
import 'package:flutter_app/models/orders_product_model.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/order_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';

class EditOrder extends StatefulWidget {
  const EditOrder({super.key, this.restorationId});
  final String? restorationId;
  static const routeName = '/editOrderDetails';

  @override
  State<EditOrder> createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> with RestorationMixin {
  String callDate = 'Select Date';
  String date = 'Select Date';
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
          lastDate: DateTime(DateTime.now().year + 1),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //       'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        // ));
        callDate =
            '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
      });
    }
  }

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String dropDown = 'Order Placed';
  String prevDropDown = 'Order Placed';

  final controllerShipmentId = TextEditingController();
  final controllerAddress1 = TextEditingController();
  final controllerAddress2 = TextEditingController();
  final controllerCity = TextEditingController();
  final controllerState = TextEditingController();
  final controllerPincode = TextEditingController();

  // text field state
  String customerName = '';
  String customerId = '';
  String shipmentID = '';
  String mobileNumber = '';
  String address1 = '';
  String address2 = '';
  String city = '';
  String state = '';
  String pincode = '';
  bool _passwordVisible = false;
  String error = '';
  String dateError = '';
  String productError = '';
  String orderedDate = '';

  String subTotal = '0';
  String cgst = '0.09';
  String sgst = '0.09';
  String total = '0';

  List<List<String>> tableData = [
    ['', '', '', '', '', ''],
  ];

  List<String> products = ['Select Product'];
  List<String> customerNamesList = ['Select Name'];

  List<String> select = ['Select Product'];

  List<String> selectedOptions = [];
  List<int> quantity = [
    1,
  ];
  List<double> amountList = [
    0.00,
  ];

  List<OrdersProductModel> editedProductList = [];

  void populateTable(List<ProductDetailsModel> product) {
    setState(() {
      for (int rowIndex = 0; rowIndex < tableData.length; rowIndex++) {
        for (int cellIndex = 0; cellIndex < 5; cellIndex++) {
          product.forEach((element) {
            if (selectedOptions[rowIndex] == element.name) {
              if (cellIndex == 2) {
                tableData[rowIndex][cellIndex] = element.price;
              } else if (cellIndex == 3) {
                tableData[rowIndex][cellIndex] = element.offers;
              } else if (cellIndex == 4) {
                int productQuantity = quantity[rowIndex];
                double productPrice = double.parse(tableData[rowIndex][2]);
                double productDiscount = double.parse(tableData[rowIndex][3]);
                double amount = productPrice * productQuantity;
                tableData[rowIndex][cellIndex] =
                    (amount - (amount * (productDiscount / 100))).toString();
                amountList[rowIndex] = double.parse(
                    (amount - (amount * (productDiscount / 100)))
                        .toStringAsFixed(2));
              }
            }
          });
        }
      }
      updateSubTotal();
      total = (double.parse(subTotal) +
              (double.parse(subTotal) * double.parse(cgst)) +
              (double.parse(subTotal) * double.parse(sgst)))
          .toStringAsFixed(2);
    });
  }

// void populateProductTable(List<ProductDetailsModel> product) {
//   setState(() {
//     for (int rowIndex = 0; rowIndex < tableData.length; rowIndex++) {
//       for (int cellIndex = 0; cellIndex < 5; cellIndex++) {
//         product.forEach((element) {
//           if (selectedOptions[rowIndex] == element.name) {
//             if (cellIndex == 2) {
//               tableData[rowIndex][cellIndex] = element.price;
//             } else if (cellIndex == 3) {
//               tableData[rowIndex][cellIndex] = element.offers;
//             } else if (cellIndex == 4) {
//               double price = double.parse(element.price);
//               double offerPercentage = double.parse(element.offers);
//               int quantity = this.quantity[rowIndex];
//               double offerAmount = (price * offerPercentage) / 100;
//               double totalAmount = (price - offerAmount) * quantity;
//               tableData[rowIndex][cellIndex] = totalAmount.toStringAsFixed(2);
//             }
//           }
//         });
//       }
//     }
//     updateSubTotal();
//     total = (double.parse(subTotal) +
//             (double.parse(subTotal) * double.parse(cgst)) +
//             (double.parse(subTotal) * double.parse(sgst)))
//         .toStringAsFixed(2);
//   });
// }

  void updateSubTotal() {
    setState(() {
      subTotal = '0';
      amountList.forEach((element) {
        subTotal = (double.parse(subTotal) + element).toStringAsFixed(2);
      });
    });
  }

  void onDropdownChanged(String? value, int rowIndex, List<ProductDetailsModel> product) {
    setState(() {
      selectedOptions[rowIndex] = value!;
    });
    populateTable(product);
  }

  @override
  void initState() {
    super.initState();
    controllerShipmentId.addListener(_saveShipmentId);
    controllerAddress1.addListener(_saveAddress1);
    controllerAddress2.addListener(_saveAddress2);
    controllerCity.addListener(_saveCity);
    controllerState.addListener(_saveState);
    controllerPincode.addListener(_savePincode);
    _passwordVisible = false;
    selectedOptions = List.generate(tableData.length, (index) => products[0]);
  }



  void _saveShipmentId() {
    shipmentID = controllerShipmentId.text;
  }

  void _saveAddress1() {
    address1 = controllerAddress1.text;
  }

  void _saveAddress2() {
    address2 = controllerAddress2.text;
  }

  void _saveCity() {
    city = controllerCity.text;
  }

  void _saveState() {
    state = controllerState.text;
  }

  void _savePincode() {
    pincode = controllerPincode.text;
  }

  List<String> productUidList = [];

  void showConfirmation(String uid, List<String> uidList) {
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
        OrderDetailsDatabaseService(docid: uid).deleteUserData();
        uidList.forEach((element) {
          OrderDetailsDatabaseService(docid: uid)
              .deleteOrderedProductDetails(element);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Order details deleted Successfully!!!'),
        ));
        Navigator.pop(context);
      } else {
        // user pressed No button
        // Navigator.pop(context);
        return;
      }
    });
  }

  var salesExecutive;
  var firstTime = true;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EditParameters;
    final productDetails = Provider.of<List<ProductDetailsModel>>(context);
    final customerList = Provider.of<List<CustomerModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);
    final orderDetailsList = Provider.of<List<OrderDetailsModel>>(context);
    final orderedProductList = [];
    final salesTable = Provider.of<List<SalesPersonModel?>>(context);
    var orderedProductsName = [];



  
    if (tableData.length != orderedProductList.length || orderRefreshFlag) {
      orderDetailsList.forEach((element) {
        if(element.uid == args.uid){
          for(var i=0; i < element.products.length; i++){
            orderedProductList.add(element.products[i]);
          }
        }
      });
    }

    var obj;
    void removeRow(int rowIndex) {
      if ((rowIndex != 0) || (tableData.length > 1)) {
        setState(() {
          amountList.removeAt(rowIndex);
          tableData.removeAt(rowIndex);
          selectedOptions.removeAt(rowIndex);
          quantity.removeAt(rowIndex);
        });
        populateTable(productDetails);
      } else {
        setState(() {
          amountList[rowIndex] = 0.00;
          tableData[rowIndex] = List.filled(6, '');
          selectedOptions[rowIndex] = products[0];
          quantity[rowIndex] = 1;
        });
        populateTable(productDetails);
      }
    }


    // if(orderedProductList.length == tableData.length) {
    //   for(var i = 0; i < orderedProductList.length; i++){
    //     if(orderedProductList[i].orderId == args.uid){
    //       if (orderedProductList[i].productName == tableData[i][0] && orderedProductList[i].quantity == tableData[i][1]){
    //         setState(() {
    //           newValue = true;
    //         });
    //       }
    //     }
    //   }
    // }

    // if(tableData.length == orderDetailsList.length) {
    //   setState(() {
    //     orderedProductsName = [];
    //     productUidList = [];
    //     selectedOptions = [products[0],];
    //     quantity = [1];
    //     amountList = [0.00,];
    //     tableData = [List.filled(6, ''), ];
    //   });
    //   populateTable(productDetails);
    // }
    // print('New Value: ${newQuant}');
    // print('New NAme: ${newName}');
    // if(count != newValue) {
    //   setState(() {
    //     orderedProductsName = [];
    //     productUidList = [];
    //     selectedOptions = [products[0],];
    //     quantity = [1];
    //     amountList = [0.00,];
    //     tableData = [List.filled(6, ''), ];
    //   });
    // }

    if (firstTime || orderRefreshFlag) {
      setState(() {
        firstTime = false;
        orderedProductsName = [];
        productUidList = [];
        selectedOptions = [products[0],];
        quantity = [1];
        amountList = [0.00,];
        tableData = [List.filled(6, ''), ];
      });
      orderedProductList.forEach((element) {
          if(selectedOptions[0] == 'Select Product'){
            setState(() {
              orderedProductsName.add(element.productName);
              productUidList.add(element.uid);
              selectedOptions[0] = element.productName;
              quantity[0] = int.parse(element.quantity);
              amountList[0] = double.parse(element.amount);
            });  
          } else {
            setState(() {
              orderedProductsName.add(element.productName);
              productUidList.add(element.uid);
              selectedOptions.add(element.productName);
              quantity.add(int.parse(element.quantity));
              amountList.add(double.parse(element.amount));
              tableData.add(List.filled(6, ''));
            });
          }
      });
      populateTable(productDetails);
    }



    void addRow() {
      setState(() {
        select.add(products[0]);
        tableData.add(List.filled(6, ''));
        amountList.add(0.00);
        selectedOptions.add(products[0]);
        quantity.add(1);
      });
    }

    if (products.length != productDetails.length + 1) {
      productDetails.forEach((element) {
        products.add(element.name);
      });
    }

    if (customerNamesList.length != customerList.length + 1) {
      customerList.forEach((element) {
        customerNamesList.add(element.customerName);
      });
    }

    void setCustomerData() {
      if (customerName != 'Select Name') {
        customerList.forEach((element) {
          if (element.customerName == customerName) {
            setState(() {
              mobileNumber = element.mobileNumber;
              controllerAddress1.text = element.address1;
              controllerAddress2.text = element.address2;
              controllerCity.text = element.city;
              controllerState.text = element.state;
              controllerPincode.text = element.pincode;
            });
          }
        });
      }
    }

    orderDetailsList.forEach((element) {
      if (element.uid == args.uid) {
        setState(() {
          controllerShipmentId.text = element.shipmentID;
          customerName = element.customerName;
          date = element.deliveryDate;
          prevDropDown = element.dropdown;
          orderedDate = element.orderedDate;
        });
        setCustomerData();
      }
    });

    customerList.forEach(
        (e) => e.customerName == customerName ? customerId = e.uid : []);

    Widget _verticalDivider = const VerticalDivider(
      color: Colors.black,
      thickness: 0.5,
    );

    List<DataColumn> createColumns() {
      return [
        DataColumn(label: Text('Product', style: TextStyle(fontSize: screenHeight / 50))),
        DataColumn(label: Text('Quantity', style: TextStyle(fontSize: screenHeight / 50))),
        DataColumn(label: Text('unit price(In Rs.)', style: TextStyle(fontSize: screenHeight / 50))),
        DataColumn(label: Text('Offer(In %)', style: TextStyle(fontSize: screenHeight / 50))),
        DataColumn(label: Text('Amount', style: TextStyle(fontSize: screenHeight / 50))),
        DataColumn(label: Text('Remove Row', style: TextStyle(fontSize: screenHeight / 50))),
      ];
    }

    if (salesTable != null && args.exec == '') {
      salesTable.forEach((element) {
        if (element?.uid == currentUser?.uid) {
          salesExecutive = element;
        }
      });
    } else {
      salesTable.forEach((element) {
        if (element?.uid == args.exec) {
          salesExecutive = element;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Energy Efficient Lights', style: TextStyle(fontSize: screenHeight / 50)),
        backgroundColor: const Color(0xff4d47c3),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await _auth.signout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    'authWrapper', (Route<dynamic> route) => false);
              },
              icon:  Icon(
                Icons.person,
                color: Colors.white,
                size: screenHeight / 50,
              ),
              label:  Text(
                'logout',
                style: TextStyle(color: Colors.white, fontSize: screenHeight / 50),
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Container(
          width: screenWidth,
          child: Form(
            key: _formkey,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 15, top: 10),
                    child:
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text(
                        'Name: ${salesExecutive.name}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenHeight / 55,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: screenWidth / 10),
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
                      "Customer Name:",
                      style: TextStyle(
                        color: Color(0xff090a0a),
                        fontSize: screenHeight / 40,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // DropdownButtonFormField(
                  //   decoration: const InputDecoration(
                  //     enabledBorder: OutlineInputBorder(
                  //       //<-- SEE HERE
                  //       borderSide: BorderSide(color: Colors.black, width: 0),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       //<-- SEE HERE
                  //       borderSide: BorderSide(color: Colors.black, width: 2),
                  //     ),
                  //     filled: true,
                  //     fillColor: Color(0xffefefff),
                  //   ),
                  //   dropdownColor: const Color(0xffefefff),
                  //   value: customerName == 'Select Name' ? name : customerName,
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       customerName = newValue!;
                  //     });
                  //     setCustomerData();
                  //   },
                  //   items: customerNamesList
                  //       .map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(
                  //         value,
                  //         style: const TextStyle(fontSize: 18),
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                  TextFormField(
                    style: TextStyle(fontSize: screenHeight / 50),
                    initialValue: customerName,
                    readOnly: true,
                    keyboardType: TextInputType.phone,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Enter Shipment ID',
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter Shipment Id' : null,
                  ),
                  const SizedBox(height: 20.0),
                   SizedBox(
                      height: screenHeight / 40,
                      child: Text(
                        'Shippment ID:',
                        style: TextStyle(
                          color: Color(0xff090a0a),
                          fontSize: screenHeight / 50,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  TextFormField(
                    style: TextStyle(fontSize: screenHeight / 50),
                    controller: controllerShipmentId,
                    keyboardType: TextInputType.phone,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Enter Shipment ID',
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter Shipment Id' : null,
                    // onChanged: (val) {
                    //   shipmentID = val;
                    // },
                  ),
                  const SizedBox(height: 20.0),
                   SizedBox(
                      height: screenHeight / 40,
                      child: Text(
                        'customer mobile num:',
                        style: TextStyle(
                          color: Color(0xff090a0a),
                          fontSize:  screenHeight / 40,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  TextFormField(
                    style: TextStyle(fontSize: screenHeight / 50),
                    keyboardType: TextInputType.phone,
                    initialValue: mobileNumber,
                    readOnly: true,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Enter customer mob.num',
                    ),
                    validator: (value) =>
                        value!.length < 10 ? 'Enter valid mobile number' : null,
                    // onChanged: (val) {
                    //   mobileNumber = val;
                    // },
                  ),
                  const SizedBox(height: 20.0),
                   SizedBox(
                      height: screenHeight / 40,
                      child: Text(
                        'Customer Full Address:',
                        style: TextStyle(
                          color: Color(0xff090a0a),
                          fontSize: screenHeight / 50,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    style: TextStyle(fontSize: screenHeight / 50),
                    controller: controllerAddress1,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'house#, area'),
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
                    style: TextStyle(fontSize: screenHeight / 50),
                    controller: controllerAddress2,
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
                    style: TextStyle(fontSize: screenHeight / 50),
                    controller: controllerCity,
                    decoration: textInputDecoration.copyWith(hintText: 'city'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter City name' : null,
                    // onChanged: (val) {
                    //   setState(() {
                    //     city = val;
                    //   });
                    // },
                  ),
                  const SizedBox(height: 10.0),
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
                  //   value: state == 'Select State' ? prevState : state,
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       state = newValue!;
                  //     });
                  //   },
                  //   items: <String>[
                  //     'Select State',
                  //     'Karnataka',
                  //     'Kerala',
                  //     'Tamil Nadu',
                  //     'Andra Pradesh'
                  //   ].map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(
                  //         value,
                  //         style: const TextStyle(fontSize: 18),
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                                      TextFormField(
                                        style: TextStyle(fontSize: screenHeight / 50),
                        controller: controllerState,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'state'),
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
                    style: TextStyle(fontSize: screenHeight / 50),
                    controller: controllerPincode,
                    decoration: textInputDecoration.copyWith(hintText: 'pincode'),
                    validator: (value) =>
                        value!.length != 6 ? 'Enter valid Pincode' : null,
                    // onChanged: (val) {
                    //   setState(() {
                    //     pincode = val;
                    //   });
                    // },
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    height: screenHeight / 40,
                    child: Text(
                      "Delivery Date:",
                      style: TextStyle(
                        color: Color(0xff090a0a),
                        fontSize: screenHeight / 50,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffe3e4e5)),
                    onPressed: () {
                      _restorableDatePickerRouteFuture.present();
                    },
                    child: Text(
                      callDate == 'Select Date' ? date : callDate,
                      style: TextStyle(color: Colors.black, fontSize: screenHeight / 50),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text(
                      dateError,
                      style: TextStyle(color: Colors.red, fontSize: screenHeight / 56),
                    ),
                  ]),
                  const SizedBox(height: 20.0),
                   SizedBox(
                    height: screenHeight / 40,
                    child: Text(
                      "Order status",
                      style: TextStyle(
                        color: Color(0xff090a0a),
                        fontSize: screenHeight / 50,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        //<-- SEE HERE
                        borderSide: BorderSide(color: Colors.black, width: 0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        //<-- SEE HERE
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      filled: true,
                      fillColor: Color(0xffefefff),
                    ),
                    dropdownColor: const Color(0xffefefff),
                    value: dropDown == 'Order Placed' ? prevDropDown : dropDown,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDown = newValue!;
                      });
                    },
                    items: <String>[
                      'Order Placed',
                      'Payment Pending',
                      'Shipped',
                      'Out for Delivery',
                      'Delivered',
                      'Cancelled',
                      'Returned'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: screenHeight / 55),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dataRowHeight: screenHeight / 15,
                          columns: createColumns(),
                          rows: List.generate(
                            tableData.length,
                            (int rowIndex) {
                              // print(tableData.length);
                              return DataRow(
                                cells: List.generate(
                                  6,
                                  (int cellIndex) {
                                    if (cellIndex == 0) {
                                      return DataCell(
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedOptions[rowIndex],
                                              items: products
                                                  .map<DropdownMenuItem<String>>(
                                                    (String value) =>
                                                        DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value, style: TextStyle(fontSize: screenHeight / 55),),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (String? value) {
                                                onDropdownChanged(value,
                                                      rowIndex, productDetails);
                                                var count = 0;
                                                for (var k = 0;
                                                    k < rowIndex;
                                                    k++) {
                                                  if (selectedOptions[rowIndex] ==
                                                      selectedOptions[k]) {
                                                    count++;
                                                  }
                                                }
        
                                                if (count != 0) {
                                                  setState(() {
                                                    productError =
                                                        'Please select unique product';
                                                  });
                                                } else {
                                                  setState(() {
                                                    productError = '';
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (cellIndex == 1) {
                                      return DataCell(
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: screenWidth / 15,
                                              height: screenHeight / 10,
                                              child: TextButton(
                                                onPressed: () {
                                                  if (quantity[rowIndex] > 1) {
                                                    setState(() {
                                                      quantity[rowIndex]--;
                                                      populateTable(
                                                          productDetails);
                                                    });
                                                  }
                                                },
                                                child: Text('-',
                                                    style:
                                                        TextStyle(fontSize: screenHeight / 55)),
                                              ),
                                            ),
                                            Text(
                                              quantity[rowIndex].toString(),
                                              style: TextStyle(fontSize: screenHeight / 50),
                                            ),
                                            SizedBox(
                                              width: screenWidth / 15,
                                              height: screenHeight / 10,
                                              child: TextButton(
                                                onPressed: () {
                                                  if (quantity[rowIndex] > 0) {
                                                    setState(() {
                                                      quantity[rowIndex]++;
                                                      populateTable(
                                                          productDetails);
                                                    });
                                                  }
                                                },
                                                child: Text('+',
                                                    style:
                                                        TextStyle(fontSize: screenHeight / 55)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (cellIndex == 5) {
                                      return DataCell(
                                        SizedBox(
                                          child: TextButton.icon(
                                            onPressed: () {
                                              removeRow(rowIndex);
                                            },
                                            icon: Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.black,
                                              size: screenHeight / 50,
                                            ),
                                            label: Text(
                                              'Remove',
                                              style:
                                                  TextStyle(color: Colors.black, fontSize: screenHeight / 55),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return DataCell(
                                      Text(tableData[rowIndex][cellIndex], style: TextStyle(fontSize: screenHeight / 50),),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        Text(
                          productError,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ]),
                      selectedOptions[tableData.length - 1] != 'Select Product'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff4d47c3),
                                    ),
                                    onPressed: addRow,
                                    child: Text('Add +', style: TextStyle(fontSize: screenHeight / 50),),
                                  ),
                                ])
                          : Container(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('')),
                          DataColumn(label: Text('')),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(Text(
                                'Sub Total:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenHeight / 50),
                              )),
                              DataCell(Text(subTotal, style: TextStyle(fontSize: screenHeight / 50),)),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(
                                'CGST:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenHeight / 50),
                              )),
                              DataCell(Text('9%', style: TextStyle(fontSize: screenHeight / 50),)),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(
                                'SGST:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenHeight / 50),
                              )),
                              DataCell(Text('9%', style: TextStyle(fontSize: screenHeight / 50),)),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(
                                'Total:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenHeight / 50),
                              )),
                              DataCell(Text(total, style: TextStyle(fontSize: screenHeight / 50),)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ]),
                  const SizedBox(
                    height: 10.0,
                  ),
                  loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          height: screenHeight / 6,
                          width: screenWidth,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formkey.currentState!.validate() &&
                                      customerId != '' &&
                                      selectedOptions[
                                              selectedOptions.length - 1] !=
                                          'Select Product' &&
                                      productError == '' ) {
                                    setState(() {
                                      loading = true;
                                      dateError = '';
                                      productError = '';
                                      error = '';
                                    });
        
                                    for(var i =0; i < selectedOptions.length; i++) {
                                        editedProductList.add(OrdersProductModel(
                                          uid: FirebaseFirestore.instance.collection('OrderDetailsTable').doc().collection('ProductDetailsTable').doc().id, 
                                          productName: selectedOptions[i], 
                                          quantity: quantity[i].toString(), 
                                          amount: amountList[i].toString(),
                                        ));
                                      }
        
        
                                    dynamic result =
                                        await OrderDetailsDatabaseService(
                                                docid: args.uid)
                                            .updateOrderData(
                                                args.exec == '' ? currentUser!.uid : args.exec,
                                                customerId,
                                                customerName,
                                                shipmentID,
                                                mobileNumber,
                                                address1,
                                                address2,
                                                city,
                                                state,
                                                pincode,
                                                callDate == 'Select Date' ? date : callDate,
                                                dropDown == prevDropDown ? prevDropDown : dropDown,
                                                subTotal,
                                                total, 
                                                orderedDate,
                                                editedProductList)
                                            .then((value) async {
                                              ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Order details updated Successfully!!!'),
                                                ));
                                                orderRefreshFlag = true;
                                                Navigator.pop(context);
                                    });
                                  } else {
                                    if (customerId == '') {
                                      setState(() {
                                        error =
                                            'The entered customer does not exist please register';
                                        loading = false;
                                      });
                                    } else {
                                      setState(() {
                                        error = '';
                                        loading = false;
                                      });
                                    }
        
                                    if (callDate == 'Select Date' && date == '') {
                                      setState(() {
                                        dateError = 'Please enter delivery date';
                                        loading = false;
                                      });
                                    } else {
                                      setState(() {
                                      dateError = '';
                                      });
                                    }
        
                                    if (selectedOptions[
                                            selectedOptions.length - 1] ==
                                        'Select Product') {
                                      setState(() {
                                        productError =
                                            'Please select a product to place order';
                                        loading = false;
                                      });
                                    } else {
                                      setState(() {
                                        productError = '';
                                        loading = false;
                                      });
                                    }
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
                                          "submit",
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
                              ElevatedButton(
                                // autogroupqdj5BoM (UPthV8mGmAE7wuU648qDj5)
                                onPressed: () {
                                  showConfirmation(args.uid, productUidList);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Container(
                                  width: screenWidth / 6,
                                  height: screenHeight / 15,
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
                                        fontSize: screenHeight / 55,
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
                                            fontSize: screenHeight / 55,
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
                  const SizedBox(height: 20.0),
                ]),
          ),
        ),
      ),
    );
  }
}
