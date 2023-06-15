import 'dart:ffi';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/customer_model.dart';
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

class ViewSalesOrder extends StatefulWidget {
  const ViewSalesOrder({super.key});
  static const routeName = '/ViewSalesOrderDetails';

  @override
  State<ViewSalesOrder> createState() => _ViewSalesOrderState();
}

class _ViewSalesOrderState extends State<ViewSalesOrder>{
  String callDate = 'Select Date';
  @override

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String dropDown = 'Active';

  // text field state
  String customerName = 'Select Name';
  String customerId = '';
  String shipmentID = '';
  String mobileNumber = '';
  String address1 = '';
  String address2 = '';
  String city = '';
  String state = 'Select State';
  String pincode = '';
  bool _passwordVisible = false;
  String error = '';
  String dateError = '';
  String productError = '';

  String subTotal = '0';
  String cgst = '0.09';
  String sgst = '0.09';
  String total = '0';

  List<List<String>> tableData = [
    ['', '', '', '', '', ''],
  ];

  List<String> products = ['Select Product'];
  List<String> customerNamesList = ['Select Name'];


  List<String> selectedOptions = [];
  List<int> quantity = [
    1,
  ];
  List<double> amountList = [
    0.00,
  ];

  void populateTable( product) {
    print(tableData.length);
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
                print(productQuantity);
                print(productPrice);
                print(productDiscount);
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
  void populateProductTable( product) {
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
                tableData[rowIndex][cellIndex] = amountList[rowIndex].toString();
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

  void updateSubTotal() {
    setState(() {
      subTotal = '0';
      amountList.forEach((element) {
        subTotal = (double.parse(subTotal) + element).toStringAsFixed(2);
      });
    });
  }

  
  void addRow() {
    setState(() {
      tableData.add(List.filled(6, ''));
      amountList.add(0.00);
      selectedOptions.add(products[0]);
      quantity.add(1);
      removeRow(0);
    });
  }

  void removeRow(int rowIndex) {
    setState(() {
      amountList.removeAt(rowIndex);
      tableData.removeAt(rowIndex);
      selectedOptions.removeAt(rowIndex);
      quantity.removeAt(rowIndex);
    });
  }

  void onDropdownChanged(
      String? value, int rowIndex, List<ProductDetailsModel> product) {
    setState(() {
      selectedOptions[rowIndex] = value!;
      populateTable(product);
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    selectedOptions = List.generate(tableData.length, (index) => products[0]);
  }


  List<String> productUidList = [];

      var salesExecutive;
  var firstTime = true;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Parameter;
    final productDetails = Provider.of<List<ProductDetailsModel>>(context);
    final customerList = Provider.of<List<CustomerModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);
    final orderDetailsList = Provider.of<List<OrderDetailsModel>>(context);
    final orderedProductList = [];
    final salesTable = Provider.of<List<SalesPersonModel?>>(context);

    var orderedProductsName = [];

    var obj;
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
              address1 = element.address1;
              address2 = element.address2;
              city = element.city;
              state = element.state;
              pincode = element.pincode;
            });
          }
        });
      }
    }

    var orders = [];

    orderDetailsList.forEach((element) {
      if(element.uid == args.uid) {
        setState(() {
          orders.add(element);
          shipmentID = element.shipmentID;
          customerName = element.customerName;
          callDate = element.deliveryDate;
          dropDown = element.dropdown;
        });
        for(var i=0; i < element.products.length; i++){
          orderedProductList.add(element.products[i]);
        }
        setCustomerData();
      }
    });

    if (tableData.length != orderedProductList.length || firstTime) {
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

    if (salesTable != null) {
      salesTable.forEach((element) {
        if (element?.uid == currentUser?.uid) {
          salesExecutive = element;
        }
      });
    }

    

    customerList.forEach(
        (e) => e.customerName == customerName ? customerId = e.uid : []);

    Widget _verticalDivider = const VerticalDivider(
      color: Colors.black,
      thickness: 0.5,
    );

    List<DataColumn> createColumns() {
      return [
        DataColumn(label: Text('Product', style: TextStyle(fontSize: screenHeight / 50),)),
        DataColumn(label: Text('Quantity', style: TextStyle(fontSize: screenHeight / 50),)),
        DataColumn(label: Text('unit price(In Rs.)', style: TextStyle(fontSize: screenHeight / 50),)),
        DataColumn(label: Text('Offer(In %)', style: TextStyle(fontSize: screenHeight / 50),)),
        DataColumn(label: Text('Amount', style: TextStyle(fontSize: screenHeight / 50),)),
        DataColumn(label: Text('Remove Row', style: TextStyle(fontSize: screenHeight / 50),)),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Energy Efficient Lights', style: TextStyle(fontSize: screenHeight / 50),),
        backgroundColor: const Color(0xff4d47c3),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await _auth.signout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    'authWrapper', (Route<dynamic> route) => false);
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
                    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                  Container(
                    margin: EdgeInsets.only(right: screenWidth / 10),
                    width: screenWidth / 3,
                    height: screenHeight / 10,
                    child: Image.asset('assets/logotm.jpg'),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    height: screenHeight / 40,
                    child: Text(
                      "Customer Name:",
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
                    initialValue: customerName,
                    readOnly: true,
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
                    initialValue: shipmentID,
                    readOnly: true,
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
                          fontSize: screenHeight / 50,
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
                    initialValue: address1,
                    readOnly: true,
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
                    initialValue: address2,
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
                    style: TextStyle(fontSize: screenHeight / 50),
                    initialValue: city,
                    readOnly: true,
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
                  TextFormField(
                    style: TextStyle(fontSize: screenHeight / 50),
                    initialValue: state,
                    readOnly: true,
                    decoration: textInputDecoration.copyWith(hintText: 'state'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter City name' : null,
                    // onChanged: (val) {
                    //   setState(() {
                    //     city = val;
                    //   });
                    // },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    style: TextStyle(fontSize: screenHeight / 50),
                    initialValue: pincode,
                    readOnly: true,
                    decoration: textInputDecoration.copyWith(hintText: 'pincode'),
                    validator: (value) =>
                        value!.length != 6 ? 'Enter valid Pincode' : null,
                    onChanged: (val) {
                      setState(() {
                        pincode = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20.0),
                   SizedBox(
                    height: screenHeight / 400,
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
                  TextFormField(
                    style: TextStyle(fontSize: screenHeight / 50),
                    initialValue: callDate,
                    readOnly: true,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text(
                      dateError,
                      style: TextStyle(color: Colors.red, fontSize: screenHeight / 60),
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
                  TextFormField(
                    style: TextStyle(fontSize: screenHeight / 50),
                    initialValue: dropDown,
                    readOnly: true,
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
                                          child: Text(selectedOptions[rowIndex], style: TextStyle(fontSize: screenHeight / 55),)
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
                                                  // if (quantity[rowIndex] > 1) {
                                                  //   setState(() {
                                                  //     quantity[rowIndex]--;
                                                  //     populateTable(
                                                  //         productDetails);
                                                  //   });
                                                  // }
                                                },
                                                child: Text('-',
                                                    style:
                                                        TextStyle(fontSize: screenHeight / 55)),
                                              ),
                                            ),
                                            Text(
                                              quantity[rowIndex].toString(),
                                              style: TextStyle(fontSize: screenHeight / 55),
                                            ),
                                            SizedBox(
                                              width: screenWidth / 15,
                                              height: screenHeight / 10,
                                              child: TextButton(
                                                onPressed: () {
                                                  // if (quantity[rowIndex] > 0) {
                                                  //   setState(() {
                                                  //     quantity[rowIndex]++;
                                                  //     populateTable(
                                                  //         productDetails);
                                                  //   });
                                                  // }
                                                },
                                                child: Text('+',
                                                    style:
                                                        TextStyle(fontSize: screenHeight / 50)),
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
                                              // if (rowIndex != 0) {
                                              //   removeRow(rowIndex);
                                              // }
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
                               TextStyle(color: Colors.red, fontSize: screenHeight / 60),
                        ),
                      ]),
                      // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      //   ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: Color(0xff4d47c3),
                      //     ),
                      //     onPressed: addRow,
                      //     child: const Text('Add +'),
                      //   ),
                      // ]),
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
                              DataCell(Text(subTotal, style: TextStyle(fontSize: screenHeight / 50))),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(
                                'CGST:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenHeight / 50),
                              )),
                              DataCell(Text('9%', style: TextStyle(fontSize: screenHeight / 50))),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(
                                'SGST:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenHeight / 50),
                              )),
                              DataCell(Text('9%', style: TextStyle(fontSize: screenHeight / 50))),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(
                                'Total:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenHeight / 50),
                              )),
                              DataCell(Text(total, style: TextStyle(fontSize: screenHeight / 50))),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: screenHeight / 60),
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
                  const SizedBox(height: 20.0),
                ]),
          ),
        ),
      ),
    );
  }
}
