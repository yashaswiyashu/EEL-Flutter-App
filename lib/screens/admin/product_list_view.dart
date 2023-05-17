import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/screens/admin/edit_product_details.dart';
import 'package:flutter_app/screens/admin/view_product_details.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/models/user_model.dart';


class ProductListViewAdmin extends StatefulWidget {
  const ProductListViewAdmin({super.key});


  @override
  State<ProductListViewAdmin> createState() => _ProductListViewAdminState();
}


enum SingingCharacter { lafayette, jefferson, yash }


class _ProductListViewAdminState extends State<ProductListViewAdmin> {
  bool loading = false;
  String status = '';
  String? select = '';
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    final productDetails = Provider.of<List<ProductDetailsModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);
    var obj;

    


    Widget _verticalDivider = const VerticalDivider(
      color: Colors.black,
      thickness: 0.5,
    );


    List<DataColumn> _createColumns() {
      return [
        DataColumn(label: Text('Product Name')),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Unit price')),
        DataColumn(label: _verticalDivider),
        DataColumn(label: Text('Select')),
      ];
    }


    List<DataRow> _createRows() {
      return productDetails
          .map((element) => DataRow(cells: [
                DataCell(Text(element.name)),
                DataCell(_verticalDivider),
                DataCell(Text(element.price)),
                DataCell(_verticalDivider),
                DataCell(
                  RadioListTile(
                    contentPadding: EdgeInsets.only(
                      bottom: 30,
                    ),
                    value: element.uid,
                    groupValue: select,
                    onChanged: (value) {
                      setState(() {
                        select = value;
                        productDetails.forEach((element) {
                          if (element.uid == select) {
                            obj = element;
                          }
                        });
                      });
                    },
                  ),
                ),
              ]))
          .toList();
    }


    DataTable _createDataTable() {
      return DataTable(
          columnSpacing: 0.0,
          dataRowHeight: 40.0,
          columns: _createColumns(),
          rows: productDetails.isNotEmpty ? _createRows() : []);
    }


    return loading
        ? const Loading()
        : WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
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
                  child: Container(
                width: 440,
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 0.4,
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 270,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset('assets/logotm.jpg'),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 250),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff4d47c3)),
                          onPressed: () {
                            Navigator.pushNamed(context, 'addNewProduct');
                          },
                          child: Text('Add New +'),
                        ),
                      ),
                      SizedBox(height: 10),
                      _createDataTable(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        status,
                        style:
                            const TextStyle(color: Colors.pink, fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // autogroupmj6kJr3 (UPthN48je9w6Wp7ratMJ6K)
                            margin: EdgeInsets.fromLTRB(0, 0, 7.38, 0),
                            child: TextButton(
                              onPressed: () async {
                                // showSettingsPanel(character);
                                if (select == '') {
                                  setState(() {
                                    status = 'Please select an option';
                                  });
                                } else {
                                  setState(() {
                                    status = '';
                                  });
                                  Navigator.pushNamed(
                                      context, ViewProductAdmin.routeName,
                                      arguments: Parameter(
                                        select!,
                                      ));
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Container(
                                width: 95.63,
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
                                    'View',
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
                          ),
                          Container(
                            // autogroupmj6kJr3 (UPthN48je9w6Wp7ratMJ6K)
                            margin: EdgeInsets.fromLTRB(0, 0, 7.38, 0),
                            child: TextButton(
                              onPressed: () {
                                // showSettingsPanel(character);
                                if (select == '') {
                                  setState(() {
                                    status = 'Please select an option';
                                  });
                                } else {
                                  setState(() {
                                    status = '';
                                  });
                                  Navigator.pushNamed(
                                      context, EditProductAdmin.routeName,
                                      arguments: Parameter(
                                        select!,
                                      ));
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Container(
                                width: 95.63,
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
                                    'Edit',
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
                          ),
                          TextButton(
                            // autogroupqdj5BoM (UPthV8mGmAE7wuU648qDj5)
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              width: 95.63,
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
                                  'Back',
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
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ]),
              ))),
        );
  }
}
