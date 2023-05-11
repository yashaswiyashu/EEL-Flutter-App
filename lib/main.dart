import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/customer_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/home.dart';
import 'package:flutter_app/screens/sales%20CoOrdinator/sales_co_ordinator_home.dart';
import 'package:flutter_app/screens/sales%20Common/sales_person_registration.dart';
import 'package:flutter_app/screens/sales%20Executive/add_call_details.dart';
import 'package:flutter_app/screens/sales%20Executive/call_details_list_view.dart';
import 'package:flutter_app/screens/sales%20Executive/edit_call.dart';
import 'package:flutter_app/screens/sales%20Executive/sales_executive_home.dart';
import 'package:flutter_app/screens/sales%20Executive/view_call_details.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/call_details_database.dart';
import 'package:flutter_app/services/customer_database.dart';
import 'package:flutter_app/services/sales_database.dart';
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
      StreamProvider<List<SalesPersonModel?>?>.value(value: SalesPersonDatabase(uid: '').salesPersonTable, initialData: null),
      StreamProvider<List<CustomerModel?>?>.value(value: CustomerDatabaseService(uid: '').customerTable, initialData: null),
      StreamProvider<List<CallDetailsModel>>.value(value: CallDetailsDatabaseService(docid: '').callDetailsTable, initialData: const []),
      StreamProvider<UserModel?>.value(value: AuthService().user, initialData: null),
      ],
      child: MaterialApp(
        initialRoute: 'home',
        debugShowCheckedModeBanner: false,
        routes: {
          'home': (context) => const Home(),
          'salesPersonRegistration':(context) => const SalesPersonRegistration(),
          'salesExecutiveHome': (context) => const SalesExecutiveHome(),
          'addCallDetails':(context) => const AddCallDetails(restorationId: 'main',),
          'callDetailsList':(context) => const CallDetailsList(),
          EditCallDetails.routeName:(context) => const EditCallDetails(restorationId: 'edit',),
          ViewCallDetails.routeName:(context) => ViewCallDetails(),
        },
      ),
    );
  }
}
