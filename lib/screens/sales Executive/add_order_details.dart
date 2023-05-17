import 'package:flutter/material.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/order_details_model.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/order_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';


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
  String deliveryDate='';
  String dropdown1 ='';
  String dropdown2 ='';
  bool _passwordVisible = false;
  String error = '';

  void initState() {
    _passwordVisible = false;
  }


  @override
  Widget build(BuildContext context) {
    final productDetails = Provider.of<List<ProductDetailsModel>>(context);
    final customerList = Provider.of<List<CustomerModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);

    customerList.forEach(
        (e) => e.customerName == customerName ? customerId = e.uid : []);

    Widget _verticalDivider = const VerticalDivider(
        color: Colors.black,
        thickness: 0.5,
    );


    List<DataColumn> _createColumns() {
      return [
        DataColumn(label: Text('Product Name')),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('unit price')),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Offer')),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Amount')),
     
      ];
    }
    List<DataRow> _createRows() {
        return productDetails.map((element) => DataRow(cells: [
          DataCell(Text(element.name)),
          DataCell(_verticalDivider),          
          DataCell(Text('1')),
          DataCell(_verticalDivider),
          DataCell(Text(element.price)),
          DataCell(_verticalDivider),
          DataCell(Text(element.offers)),
          DataCell(_verticalDivider),
          DataCell(Text('total')),
        ]))
        .toList();
    }
    DataTable _createDataTable() {
      return DataTable(
        columnSpacing: 0.0,
        dataRowHeight: 40.0,
        columns: _createColumns(),
        rows: productDetails.isNotEmpty ? _createRows() : []
      );
    };
                 
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
                      'authWrapper',
                      (Route<dynamic> route) => false);
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
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Customer Full Address' : null,
                      onChanged: (val) {
                        setState(() {
                          address1 = val;
                        });
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'town, taluk'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Customer Full Address' : null,
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
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Customer Full Address' : null,
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
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Customer Full Address' : null,
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
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Customer Full Address' : null,
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
                              if (_formkey.currentState!.validate()) {
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
                                      dropDown
                                    );
                                    loading = false;
                                    Navigator.pushNamed(
                                        context, 'customerHomePage');
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
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    const SizedBox(height: 20.0),
                    ]
                ),
              ),
            ),
          );
  }
}


