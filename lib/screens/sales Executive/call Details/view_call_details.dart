import 'package:flutter/material.dart';
import 'package:flutter_app/models/call_details_forward_model.dart';
import 'package:flutter_app/models/call_details_model.dart';
import 'package:flutter_app/models/sales_person_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/sales_database.dart';
import 'package:flutter_app/shared/constants.dart';
import 'package:flutter_app/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/services/call_details_database.dart';
import 'package:provider/provider.dart';

import 'followup_container.dart';

class ViewCallDetails extends StatefulWidget {
  ViewCallDetails({super.key});
  static const routeName = '/viewCallDetails';

  @override
  State<ViewCallDetails> createState() => _ViewCallDetailsState();
}

class _ViewCallDetailsState extends State<ViewCallDetails> {
  bool followUp = false;
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String salesExecutiveName = '';
  String customerName = '';
  String customerType = '';
  String customerNumber = '';
  String callDate = '';
  String callResult = '';
  String followUpDetails = '';
  var salesExecutive;

  String status = '';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Parameter;
    final currentUser = Provider.of<UserModel>(context);
    final callDetails = Provider.of<List<CallDetailsModel>>(context);
    final salesTable = Provider.of<List<SalesPersonModel?>?>(context);

    var obj;

    if (callDetails != null) {
      callDetails.forEach((element) {
        if (element.uid == args.uid) {
          obj = element;
        }
      });
    }

    if (salesTable != null) {
      salesTable.forEach((element) {
        if (element?.uid == currentUser.uid) {
          salesExecutiveName = element!.name;
          salesExecutive = element;
        }
      });
    }

    followUp = obj.followUp;

    return loading
        ? const Loading()
        : Scaffold(
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
                      style: TextStyle(color: Colors.white, fontSize: screenHeight / 50),
                    )),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: Container(
                // calldetailsedit2is (32:1733)
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 0.4,
                ),
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                ),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 15, top: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                        children: [Container(
                          width: screenWidth / 3,
                          height: screenHeight / 10,
                          child: Image.asset('assets/logotm.jpg'),
                        ),]
                      ),
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
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: screenHeight / 50),
                        readOnly: true,
                        initialValue: obj.customerName,
                        keyboardType: TextInputType.phone,
                        validator: (value) => value?.length == 12
                            ? null
                            : 'Enter valid Aadhar number',
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Your Adhaar Number',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                          height: screenHeight / 40,
                          child: Text(
                            'Customer Type:',
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
                        readOnly: true,
                        initialValue: obj.customerType,
                        keyboardType: TextInputType.phone,
                        validator: (value) => value?.length == 12
                            ? null
                            : 'Enter valid Aadhar number',
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Your Adhaar Number',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                          height: screenHeight / 40,
                          child: Text(
                            'Customer Mobile Number:',
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
                        readOnly: true,
                        initialValue: obj.mobileNumber,
                        keyboardType: TextInputType.phone,
                        validator: (value) => value?.length == 12
                            ? null
                            : 'Enter valid Aadhar number',
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Your Adhaar Number',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: screenHeight / 40,
                        child: Text(
                          "Call Date:",
                          style: TextStyle(
                            color: Color(0xff090a0a),
                            fontSize: screenHeight / 50,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: screenHeight / 50),
                        readOnly: true,
                        initialValue: obj.callDate,
                        keyboardType: TextInputType.phone,
                        validator: (value) => value?.length == 12
                            ? null
                            : 'Enter valid Aadhar number',
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Your Adhaar Number',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                          height: screenHeight / 40,
                          child: Text(
                            'Call Result:',
                            style: TextStyle(
                              color: Color(0xff090a0a),
                              fontSize: screenHeight / 50,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      TextFormField(
                        style: TextStyle(fontSize: screenHeight / 50),
                        readOnly: true,
                        initialValue: obj.callResult,
                        keyboardType: TextInputType.phone,
                        validator: (value) => value?.length == 12
                            ? null
                            : 'Enter valid Aadhar number',
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Your Adhaar Number',
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Container(
                        child: Row(children: <Widget>[
                          SizedBox(
                              height: screenHeight / 40,
                              child: Text(
                                'Follow Up Required:',
                                style: TextStyle(
                                  color: Color(0xff090a0a),
                                  fontSize: screenHeight / 50,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            width: screenWidth / 20,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 254, 254),
                            ),
                            child: StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              // return CheckboxListTile(
                              // controlAffinity: ListTileControlAffinity.leading,
                              // value: followUp,
                              // onChanged: (bool? value) {
                              //   setState(() {
                              //     followUp = value!;
                              //   });
                              // });
                              return Switch(
                                value: followUp,
                                onChanged: (bool value) {
                                  // setState(() {
                                  //   followUp = value;
                                  // });
                                },
                              );
                            }),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        // followupdetailsjeX (32:1762)
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
                        child: Text(
                          'Follow Up Details:',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: screenHeight / 50,
                            fontWeight: FontWeight.w500,
                            height: 1,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      buildFollowUpDetailsContainerView(obj.followUpDetls),
/*                       Container(
                        width: 440,
                        height: 83,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xffe3e4e5)),
                          color: Color(0xfff0efff),
                        ),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: obj.followUpdetails,
                          validator: (value) =>
                              value!.isEmpty ? 'Missing Field' : null,
                          onChanged: (val) {
                            setState(() {
                              followUpDetails = val;
                            });
                          },
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
 */                      Container(
                        margin: EdgeInsets.only(left: 120),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            // margin: EdgeInsets.fromLTRB(260, 60, 6, 0),
                            height: screenHeight / 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  // autogroupqdj5BoM (UPthV8mGmAE7wuU648qDj5)
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Container(
                                    width: screenWidth / 5,
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
                                        'Back',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: screenHeight / 50,
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
                          )
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        status,
                        style:
                            const TextStyle(color: Colors.pink, fontSize: 14.0),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
