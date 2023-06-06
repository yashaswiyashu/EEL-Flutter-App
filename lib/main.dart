import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/complaint_details_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/order_details_model.dart';
import 'package:flutter_app/models/orders_product_model.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/admin/admin_home.dart';
import 'package:flutter_app/screens/admin/products/add_new_product.dart';
import 'package:flutter_app/screens/admin/products/edit_product_details.dart';
import 'package:flutter_app/screens/admin/products/product_list_view.dart';
import 'package:flutter_app/screens/admin/products/view_product_details.dart';
import 'package:flutter_app/screens/admin/users/co-ordinator/co_ord_list.dart';
import 'package:flutter_app/screens/admin/users/co-ordinator/edit_co_ord.dart';
import 'package:flutter_app/screens/admin/users/co-ordinator/view_co_ord.dart';
import 'package:flutter_app/screens/admin/users/customer/customer_list.dart';
import 'package:flutter_app/screens/admin/users/executive/edit_sales_exec_list.dart';
import 'package:flutter_app/screens/admin/users/executive/sales_exec_list.dart';
import 'package:flutter_app/screens/admin/users/executive/view_sales_exec.dart';
import 'package:flutter_app/screens/admin/users/select_user.dart';
import 'package:flutter_app/screens/common/home.dart';
import 'package:flutter_app/screens/customer/customer_home.dart';
import 'package:flutter_app/screens/sales%20CoOrdinator/complaints/pending_complaints_list.dart';
import 'package:flutter_app/screens/sales%20CoOrdinator/follow%20up/follow_up_details_list.dart';
import 'package:flutter_app/screens/sales%20Executive/call%20Details/edit_call.dart';
import 'package:flutter_app/screens/sales%20Executive/call%20Details/view_call_details.dart';
import 'package:flutter_app/screens/sales%20Executive/complaints/add_new_complaints.dart';
import 'package:flutter_app/screens/sales%20Executive/complaints/complaint_details_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/complaints/edit_complaint.dart';
import 'package:flutter_app/screens/sales%20Executive/complaints/view_complaint_details.dart';
import 'package:flutter_app/screens/sales%20Executive/customer%20Details/add_new_customer.dart';
import 'package:flutter_app/screens/sales%20Executive/customer%20Details/customer_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/customer%20Details/edit_customer_detail.dart';
import 'package:flutter_app/screens/sales%20Executive/customer%20Details/view_customer_details.dart';
import 'package:flutter_app/screens/customer/customer_registration.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/add_order_details.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/edit_order_details.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/order_details_list_view.dart';
import 'package:flutter_app/screens/sales%20CoOrdinator/sales_co_ordinator_home.dart';
import 'package:flutter_app/screens/sales%20Common/sales_person_registration.dart';
import 'package:flutter_app/screens/sales%20Executive/call%20Details/add_call_details.dart';
import 'package:flutter_app/screens/sales%20Executive/call%20Details/call_details_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/order%20Details/view_order_details.dart';
import 'package:flutter_app/screens/sales%20Executive/pending%20Orders/edit_pending_order.dart';
import 'package:flutter_app/screens/sales%20Executive/pending%20Orders/pending_order_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/pending%20Orders/view_sales_details.dart';
import 'package:flutter_app/screens/sales%20Executive/sales%20Details/sales_details_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/sales%20Details/view_sales_details.dart';
import 'package:flutter_app/screens/sales%20Executive/sales_executive_home.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/call_details_database.dart';
import 'package:flutter_app/services/complaint_details_database.dart';
import 'package:flutter_app/services/customer_database.dart';
import 'package:flutter_app/services/order_database.dart';
import 'package:flutter_app/services/products_database.dart';
import 'package:flutter_app/services/sales_database.dart';
import 'package:flutter_app/wrappers/auth_wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      StreamProvider<List<CustomerModel>>.value(value: CustomerDatabaseService(docid: '').customerTable, initialData: const []),
      StreamProvider<List<SalesPersonModel?>>.value(value: SalesPersonDatabase(docid: '').salesPersonTable, initialData: const []),
      StreamProvider<List<CallDetailsModel>>.value(value: CallDetailsDatabaseService(docid: '').callDetailsTable, initialData: const []),
      StreamProvider<List<ProductDetailsModel>>.value(value: ProductDatabaseService(docid: '').productDetailsTable, initialData: const []),
      StreamProvider<List<OrderDetailsModel>>.value(value: OrderDetailsDatabaseService(docid: '').orderDetailsTable, initialData: const []),
      // StreamProvider<List<OrdersProductModel>>.value(value: OrderDetailsDatabaseService(docid: '').orderedProductDetailsTable, initialData: const []),
      StreamProvider<List<ComplaintDetailsModel>>.value(value: ComplaintDetailsDatabaseService(docid: '').complaintDetailsTable, initialData: const []),
      StreamProvider<UserModel?>.value(value: AuthService().user, initialData: null),
      ],
      child: MaterialApp(
        initialRoute: 'home',
        debugShowCheckedModeBanner: false,
        routes: {
          'home': (context) => const Home(),
          'authWrapper':(context) => const AuthWrapper(),
          
          //Sales Executive =>
          SalesPersonRegistration.routeName:(context) => const SalesPersonRegistration(),
            //Call details  
            AddCallDetails.routeName:(context) => const AddCallDetails(restorationId: 'main',),
            CallDetailsList.routeName:(context) => const CallDetailsList(),
            EditCallDetails.routeName:(context) => const EditCallDetails(restorationId: 'edit',),
            ViewCallDetails.routeName:(context) => ViewCallDetails(),
            
            //Sales Details
            SalesDetailsList.routeName:(context) => const SalesDetailsList(),
            ViewSalesOrder.routeName:(context) => const ViewSalesOrder(),

            //Pending orders
            PendingOrdersList.routeName:(context) => const PendingOrdersList(),
            EditPendingOrder.routeName:(context) => const EditPendingOrder(),
            ViewPendingOrder.routeName:(context) => const ViewPendingOrder(),

            //Customer details
            AddNewCustomer.routeName:(context) => const AddNewCustomer(),
            CustomerListView.routeName:(context) => const CustomerListView(),
            EditCustomerDetails.routeName:(context) => const EditCustomerDetails(),
            ViewCustomerDetails.routeName:(context) => const ViewCustomerDetails(),
            
            //Order details
            AddNewOrder.routeName:(context) => const AddNewOrder(restorationId: 'main'),
            OrderDetailsList.routeName:(context) => const OrderDetailsList(),
            EditOrder.routeName:(context) => const EditOrder(restorationId: 'main',),
            ViewOrder.routeName:(context) => const ViewOrder(),

            //Complaints
            AddNewComplaint.routeName:(context) => const AddNewComplaint(restorationId: 'main',),
            ComplaintDetailsList.routeName:(context) => const ComplaintDetailsList(),
            EditComplaintDetails.routeName:(context) => const EditComplaintDetails(restorationId: 'main'),
            ViewComplaintDetails.routeName:(context) => ViewComplaintDetails(),

          //sales Co-ordinator =>          
            //Follow Up
            FollowUpDetails.routeName:(context) => const FollowUpDetails(),

            //Pending Complaints
            PendingComplaintDetailsList.routeName:(context) => const PendingComplaintDetailsList(),

          //Customer =>
          CustomerRegistration.routeName:(context) => const CustomerRegistration(),
            

          //Admin =>
            //Products
            'addNewProduct':(context) => const AddProductAdmin(),
            'productListView':(context) =>  const ProductListViewAdmin(),
            EditProductAdmin.routeName:(context) => const EditProductAdmin(),
            ViewProductAdmin.routeName:(context) => const ViewProductAdmin(),

            //Users
              'selectUser':(context) => const UserSelection(),

              //Sales Co-Ordinator
              'salesCoOrdList':(context) => const SalesCoOrdinatorList(),
              EditCoOrdinatorDetails.routeName:(context) => const EditCoOrdinatorDetails(),
              ViewCoOrdinatorDetails.routeName:(context) => const ViewCoOrdinatorDetails(),

              //Sales Executive
              'salesExecList':(context) => const SalesExecList(),
              EditSalesExecutiveDetails.routeName:(context) => const EditSalesExecutiveDetails(),
              ViewExecutiveDetails.routeName:(context) => const ViewExecutiveDetails(),

              //customer
              'customerListAdmin':(context) => const CustomerListAdmin()
        },
      ),
    );
  }
}
