import 'package:flutter/material.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/admin/admin_home.dart';
import 'package:flutter_app/screens/admin/products/product_list_view.dart';
import 'package:flutter_app/screens/common/home.dart';
import 'package:flutter_app/screens/common/login.dart';
import 'package:flutter_app/screens/common/register_as.dart';
import 'package:flutter_app/screens/customer/customer_home.dart';
import 'package:flutter_app/screens/sales%20CoOrdinator/sales_co_ordinator_home.dart';
import 'package:flutter_app/screens/sales%20Executive/sales_executive_home.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final salesTable = Provider.of<List<SalesPersonModel?>>(context);
    final customerTable = Provider.of<List<CustomerModel>>(context);
    final currentUser = Provider.of<UserModel?>(context);
    var obj;
    bool cust = false;



    if (salesTable.isNotEmpty) {
      salesTable.forEach((e) {
        if (e?.uid == currentUser?.uid) {
          obj = e;
        }
      });
    } else if (customerTable.isNotEmpty) {
      customerTable.forEach((e) {
        if (e.uid == currentUser?.uid) {
          cust = true;
        } 
      });
    } 
    
    if(currentUser != null){
      if (obj?.role == 'Sales Executive') {
        return SalesExecutiveHome();
      } else if (obj?.role == 'Sales Co-Ordinator') {
        return SalesCoOrdinatorHome();
      } else if (obj?.role == 'Admin') {
        return AdminHome();
      } 

      if(cust) {
        return CustomerHome();
      }
    }
    return Home();
  }
}
