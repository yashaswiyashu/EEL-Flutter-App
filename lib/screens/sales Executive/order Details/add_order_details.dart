import 'package:flutter/material.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/order_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/products_repository.dart';

class NewOrder extends StatefulWidget {
  const NewOrder({super.key, this.restorationId});
  final String? restorationId;
  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> with RestorationMixin {
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
  String deliveryDate = '';
  String dropdown1 = '';
  String dropdown2 = '';
  bool _passwordVisible = false;
  String error = '';

  List<List<String>> tableData = [
    ['', '', '', '', ''],
  ];
  
  List<String> products = ['Select Product'];

  List<String> printProductDocuments(List<String> productList) {
    ProductRepository productRepository = ProductRepository();
    List<ProductDetailsModel> productDocuments = productRepository.productDocuments;

    for (var document in productDocuments) {
      productList.add(document.name);
    }
    return productList;
  }

  List<String> options = ['Option 1', 'Option 2', 'Option 3'];
  List<String> select = ['Select Product'];

  List<String> selectedOptions = [];
  List<String> quantity = ['',];
  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Row(children: [Text('Product')])),
      DataColumn(label: Row(children: [Text('Quantity')])),
      DataColumn(label: Row(children: [Text('unit price')])),
      DataColumn(label: Row(children: [Text('Offer')])),
      DataColumn(label: Row(children: [Text('Amount')])),
    ];
  }

  void populateTable(List<ProductDetailsModel> product) {
    setState(() {
      for (int rowIndex = 0; rowIndex < tableData.length; rowIndex++) {
        for (int cellIndex = 0; cellIndex < 5; cellIndex++) {
          product.forEach((element) {
            select[rowIndex] = selectedOptions[rowIndex];
            if(selectedOptions[rowIndex] == element.name) {
              if(cellIndex == 1){
                
              } else if(cellIndex == 2) {
                tableData[rowIndex][cellIndex] = element.price;
              } else if (cellIndex == 3) {
                tableData[rowIndex][cellIndex] = element.offers;
              } 
            }
          });
          // tableData[rowIndex][cellIndex] =
          //     '${selectedOptions[rowIndex]} ${rowIndex + 1}-$cellIndex';
        }
      }
    });
  }

  void addRow() {
    setState(() {
      tableData.add(List.filled(5, ''));
      selectedOptions.add(products[0]);
      quantity.add('0');
      print(selectedOptions);
    });
  }


  void onDropdownChanged(String? value, int rowIndex, List<ProductDetailsModel> product) {
    setState(() {
      selectedOptions[rowIndex] = value!;
      populateTable(product);
    });
  }

  @override
  void initState() {
    super.initState();
    printProductDocuments(products);
    _passwordVisible = false;
    selectedOptions = List.generate(tableData.length, (index) => products[0]);
  }
  var i = 1;

  @override
  Widget build(BuildContext context) {
    final productDetails = Provider.of<List<ProductDetailsModel>>(context);
    final customerList = Provider.of<List<CustomerModel?>>(context);
    final currentUser = Provider.of<UserModel?>(context);

    if(products.length != productDetails.length + 1){
      productDetails.forEach((element) {
        products.add(element.name);
      });
    }

    print(products.length);

    
    selectedOptions = List.generate(tableData.length, (index) => products[0]);
    
    customerList.forEach(
        (e) => e?.customerName == customerName ? customerId = e!.uid : []);

    Widget _verticalDivider = const VerticalDivider(
      color: Colors.black,
      thickness: 0.5,
    );


    List<DataColumn> _createColumns() {
      return [
        DataColumn(label: Text('Product')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('unit price')),
        DataColumn(label: Text('Offer')),
        DataColumn(label: Text('Amount')),
      ];
    }





    // List<DataRow> _createRows() {
    //     return productDetails.map((element) => DataRow(cells: [
    //       DataCell(Text(element.name)),
    //       DataCell(_verticalDivider),
    //       DataCell(Text('1')),
    //       DataCell(_verticalDivider),
    //       DataCell(Text(element.price)),
    //       DataCell(_verticalDivider),
    //       DataCell(Text(element.offers)),
    //       DataCell(_verticalDivider),
    //       DataCell(Text('total')),
    //     ]))
    //     .toList();
    // }
    // List<DataRow> dataRows = [];

    // DataRow _createRows() {
    //     return DataRow(cells: [
    //       DataCell(),
    //       DataCell(_verticalDivider),
    //       DataCell(),
    //       DataCell(_verticalDivider),
    //       DataCell(),
    //       DataCell(_verticalDivider),
    //       DataCell(),
    //       DataCell(_verticalDivider),
    //       DataCell(),
    //     ]);
    // };
    // DataTable _createDataTable() {
    //   return DataTable(
    //     columnSpacing: 0.0,
    //     dataRowHeight: 40.0,
    //     columns: _createColumns(),
    //     rows: productDetails.isNotEmpty ? _createRows() : []
    //   );
    // };

    return loading
        ? const Loading()
        : Scaffold(
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
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Enter Customer Name',
                            fillColor: const Color(0xfff0efff)),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter Customer Name' : null,
                        onChanged: (val) {
                          customerName = val;
                        },
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
                            value!.length < 10 ? 'Enter Shipment Id' : null,
                        onChanged: (val) {
                          mobileNumber = val;
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
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Enter customer mob.num',
                        ),
                        validator: (value) => value!.length < 10
                            ? 'Enter valid mobile number'
                            : null,
                        onChanged: (val) {
                          mobileNumber = val;
                        },
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
                        decoration: textInputDecoration.copyWith(
                            hintText: 'house#, area'),
                        validator: (value) => value!.isEmpty
                            ? 'Enter Customer Full Address'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            address1 = val;
                          });
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'town, taluk'),
                        validator: (value) => value!.isEmpty
                            ? 'Enter Customer Full Address'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            address2 = val;
                          });
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'city'),
                        validator: (value) => value!.isEmpty
                            ? 'Enter Customer Full Address'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            city = val;
                          });
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'state'),
                        validator: (value) => value!.isEmpty
                            ? 'Enter Customer Full Address'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            state = val;
                          });
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'pincode'),
                        validator: (value) => value!.isEmpty
                            ? 'Enter Customer Full Address'
                            : null,
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
                            borderSide:
                                BorderSide(color: Colors.black, width: 0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              error,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                            ),
                          ]),
                      Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: _createColumns(),
                              rows: List.generate(
                                tableData.length,
                                (int rowIndex) {
                                  return DataRow(
                                    cells: List.generate(
                                      5,
                                      (int cellIndex) {
                                        if (cellIndex == 0) {
                                          print(select[rowIndex]);
                                          return DataCell(
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: select[rowIndex] =='' ? selectedOptions[rowIndex] : select[rowIndex],
                                                  items: products
                                                      .map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                        (String value) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                          value: value,
                                                          child: Text(value),
                                                        ),
                                                      )
                                                      .toList(),
                                                  onChanged: (String? value) {
                                                    select[rowIndex] = value!;
                                                    onDropdownChanged(
                                                        value, rowIndex, productDetails);
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        } else if (cellIndex == 1) {
                                          var count = 0;
                                          quantity[rowIndex] = count.toString();
                                          return DataCell(
                                            Row(children: [
                                              SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: TextButton(
                                                  onPressed: (){
                                                    if(count > 0) {
                                                      setState(() {
                                                        count--;
                                                      });
                                                    }
                                                  }, 
                                                  child: const Text('-', style: TextStyle(fontSize: 20) ),
                                                ),
                                              ),
                                              Text(quantity[rowIndex].toString(), style: TextStyle(fontSize: 20),),
                                              SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: TextButton(
                                                  onPressed: (){
                                                    if(count >= 0) {
                                                      setState(() {  
                                                        count++;
                                                      });
                                                    }
                                                  }, 
                                                  child: const Text('+', style: TextStyle(fontSize: 20)),
                                                ),
                                              ),
                                            ],),
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
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
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
                              onPressed: () async {
                                if (_formkey.currentState!.validate() &&
                                    customerId != '') {
                                  setState(() {
                                    loading = true;
                                  });
                                  await OrderDetailsDatabaseService(docid: '')
                                      .setUserData(
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
                                          deliveryDate,
                                          dropDown);
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.pushNamed(
                                      context, 'customerHomePage');
                                } else {
                                  if (customerId == '')
                                    setState(() {
                                      error =
                                          'The entered customer does not exist please register';
                                      loading = false;
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
                                Navigator.pushNamed(context, 'home');
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
                      const SizedBox(height: 12.0),
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      const SizedBox(height: 20.0),
                    ]),
              ),
            ),
          );
  }
}
