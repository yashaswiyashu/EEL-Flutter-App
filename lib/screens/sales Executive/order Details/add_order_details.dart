import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/order_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';

class AddNewOrder extends StatefulWidget {
  const AddNewOrder({super.key, this.restorationId});
  final String? restorationId;
  @override
  State<AddNewOrder> createState() => _AddNewOrderState();
}

class _AddNewOrderState extends State<AddNewOrder> with RestorationMixin {
  String callDate = 'Select Date';
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
          firstDate: DateTime(2023),
          lastDate: DateTime(2025),
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

  String dropDown = 'Active';

  final controllerNumber = TextEditingController();
  final controllerAddress1 = TextEditingController();
  final controllerAddress2 = TextEditingController();
  final controllerCity = TextEditingController();
  final controllerPincode = TextEditingController();

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

  List<String> select = ['Select Product'];

  List<String> selectedOptions = [];
  List<int> quantity = [
    1,
  ];
  List<double> amountList = [
    0.00,
  ];

  void populateTable(List<ProductDetailsModel> product) {
    setState(() {
      for (int rowIndex = 0; rowIndex < tableData.length; rowIndex++) {
        for (int cellIndex = 0; cellIndex < 5; cellIndex++) {
          product.forEach((element) {
            select[rowIndex] = selectedOptions[rowIndex];
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
      select.add(products[0]);
      amountList.add(0.00);
      tableData.add(List.filled(6, ''));
      selectedOptions.add(products[0]);
      quantity.add(1);
      print(selectedOptions);
    });
  }

  void removeRow(int rowIndex) {
    setState(() {
      select.removeAt(rowIndex);
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
    controllerNumber.addListener(_saveNumber);
    controllerAddress1.addListener(_saveAddress1);
    controllerAddress2.addListener(_saveAddress2);
    controllerCity.addListener(_saveCity);
    controllerPincode.addListener(_savePincode);
    _passwordVisible = false;
    selectedOptions = List.generate(tableData.length, (index) => products[0]);
  }

  void _saveNumber() {
    mobileNumber = controllerNumber.text;
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

  void _savePincode() {
    pincode = controllerPincode.text;
  }

    var salesExecutive;

  @override
  Widget build(BuildContext context) {
    final productDetails = Provider.of<List<ProductDetailsModel>>(context);
    final customerList = Provider.of<List<CustomerModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);
        final salesTable = Provider.of<List<SalesPersonModel?>>(context);

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
            controllerNumber.text = element.mobileNumber;
            controllerAddress1.text = element.address1;
            controllerAddress2.text = element.address2;
            controllerCity.text = element.city;
            state = element.state;
            controllerPincode.text = element.pincode;
          }
        });
      }
    }

    customerList.forEach(
        (e) => e.customerName == customerName ? customerId = e.uid : []);

    Widget _verticalDivider = const VerticalDivider(
      color: Colors.black,
      thickness: 0.5,
    );

    List<DataColumn> createColumns() {
      return [
        DataColumn(label: Text('Product')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('unit price(In Rs.)')),
        DataColumn(label: Text('Offer(In %)')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Remove Row')),
      ];
    }

    if (salesTable != null) {
      salesTable.forEach((element) {
        if (element?.uid == currentUser?.uid) {
          salesExecutive = element;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Efficient Lights'),
        backgroundColor: const Color(0xff4d47c3),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await _auth.signout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    'authWrapper', (Route<dynamic> route) => false);
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
        padding: EdgeInsets.only(right: 10, left: 10),
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
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
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.black, width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    filled: true,
                    fillColor: Color(0xffefefff),
                  ),
                  dropdownColor: const Color(0xffefefff),
                  value: customerName,
                  onChanged: (String? newValue) {
                    setState(() {
                      customerName = newValue!;
                    });
                    setCustomerData();
                  },
                  items: customerNamesList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20.0),
                const SizedBox(
                    height: 20.0,
                    child: Text(
                      'Shippment ID:',
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
                    hintText: 'Enter Shipment ID',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter Shipment Id' : null,
                  onChanged: (val) {
                    shipmentID = val;
                  },
                ),
                const SizedBox(height: 20.0),
                const SizedBox(
                    height: 20.0,
                    child: Text(
                      'customer mobile num:',
                      style: TextStyle(
                        color: Color(0xff090a0a),
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: controllerNumber,
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
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.black, width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.black, width: 0),
                    ),
                    filled: true,
                    fillColor: Color(0xffefefff),
                  ),
                  dropdownColor: const Color(0xffefefff),
                  value: state,
                  onChanged: (String? newValue) {
                    setState(() {
                      state = newValue!;
                    });
                  },
                  items: <String>[
                    'Select State',
                    'Karnataka',
                    'Kerala',
                    'Tamil Nadu',
                    'Andra Pradesh'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: controllerPincode,
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
                const SizedBox(
                  height: 20.0,
                  child: Text(
                    "Delivery Date:",
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
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
                    callDate,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    dateError,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ]),
                const SizedBox(height: 20.0),
                const SizedBox(
                  height: 20.0,
                  child: Text(
                    "Order status",
                    style: TextStyle(
                      color: Color(0xff090a0a),
                      fontSize: 16,
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
                  value: dropDown,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropDown = newValue!;
                    });
                  },
                  items: <String>[
                    'Active',
                    'Inactive',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 16),
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
                        dataRowHeight: 60,
                        columns: createColumns(),
                        rows: List.generate(
                          tableData.length,
                          (int rowIndex) {
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
                                            value: select[rowIndex] == ''
                                                ? selectedOptions[rowIndex]
                                                : select[rowIndex],
                                            items: products
                                                .map<DropdownMenuItem<String>>(
                                                  (String value) =>
                                                      DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (String? value) {
                                              select[rowIndex] = value!;
                                              var count = 0;
                                              for(var k = 0; k < rowIndex; k++) {
                                                if(select[rowIndex] == select[k]) {
                                                  count++;
                                                }
                                              }
                                              
                                              if(count != 0) {
                                                setState(() {
                                                  productError = 'Please select unique product';
                                                });
                                              } else {
                                                setState(() {
                                                  productError = '';
                                                });
                                                selectedOptions[rowIndex] = value;
                                                onDropdownChanged(value, rowIndex, productDetails);
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
                                            width: 40,
                                            height: 40,
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
                                              child: const Text('-',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ),
                                          ),
                                          Text(
                                            quantity[rowIndex].toString(),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(
                                            width: 40,
                                            height: 40,
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
                                              child: const Text('+',
                                                  style:
                                                      TextStyle(fontSize: 20)),
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
                                            if (rowIndex != 0) {
                                              removeRow(rowIndex);
                                            }
                                          },
                                          icon: Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.black,
                                          ),
                                          label: Text(
                                            'Remove',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return DataCell(
                                    Text(tableData[rowIndex][cellIndex]),
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
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff4d47c3),
                        ),
                        onPressed: addRow,
                        child: const Text('Add +'),
                      ),
                    ]),
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataCell(Text(subTotal)),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text(
                              'CGST:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataCell(Text('9%')),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text(
                              'SGST:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataCell(Text('9%')),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text(
                              'Total:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataCell(Text((total))),
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
                        height: 59,
                        width: 420,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (_formkey.currentState!.validate() &&
                                    customerId != '' &&
                                    callDate != 'Select Date' &&
                                    selectedOptions[
                                            selectedOptions.length - 1] !=
                                        'Select Product' && productError == '') {
                                  setState(() {
                                    loading = true;
                                    dateError = '';
                                    productError = '';
                                    error = '';
                                  });
                                  dynamic result =
                                      await OrderDetailsDatabaseService(
                                              docid: '')
                                          .setOrderData(
                                              currentUser!.uid,
                                              customerId,
                                              customerName,
                                              shipmentID,
                                              mobileNumber,
                                              address1,
                                              address2,
                                              city,
                                              state,
                                              pincode,
                                              callDate,
                                              dropDown,
                                              subTotal,
                                              total)
                                          .then((value) async {
                                         setState(() {
                                            loading = false;
                                          });
                                    for (var j = 0;
                                        j < selectedOptions.length;
                                        j++) {
                                      if (selectedOptions[j] !=
                                          'Select Product') {
                                        await OrderDetailsDatabaseService(
                                                docid: value)
                                            .setOrderedProductDetails(
                                          value,
                                          selectedOptions[j],
                                          quantity[j].toString(),
                                          amountList[j].toString(),
                                        )
                                            .then((value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Order details added Successfully!!!'),
                                          ));
                                          Navigator.pop(context);
                                        });
                                      }
                                    }
                                  });
                                } else {
                                  if (customerId == '') {
                                    setState(() {
                                      error =
                                          'The entered customer does not exist please register';
                                      loading = false;
                                    });
                                  }

                                  if (callDate == 'Select Date') {
                                    setState(() {
                                      dateError = 'Please enter delivery date';
                                      loading = false;
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
                                  }

                                  if(productError != '') {
                                    setState(() {
                                      loading = false;
                                      error = 'Enter valid product details'; 
                                    });
                                  }
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
                                        "submit",
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
                              width: 55,
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
                const SizedBox(height: 20.0),
              ]),
        ),
      ),
    );
  }
}
