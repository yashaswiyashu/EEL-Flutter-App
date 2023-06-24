import 'package:flutter/material.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:intl/intl.dart';

import '../../../models/complaint_details_model.dart';


class ComplaintDetailsContainer extends StatefulWidget {
  final Function(ComplaintDetail) onChanged;
  final List<ComplaintDetail> complaintDetails;

  const ComplaintDetailsContainer({Key? key, required this.onChanged, required this.complaintDetails}) : super(key: key);

  @override
  _ComplaintDetailsContainerState createState() => _ComplaintDetailsContainerState();
}

class _ComplaintDetailsContainerState extends State<ComplaintDetailsContainer> {
  String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
  TextEditingController detailsController = TextEditingController();
  String fDetail = '';
  //List<ComplaintDetail> complaintDetails = [];
  int pressCount = 0;

  void _handleButtonPress() {
    String trimmedDetails = fDetail.trim();
    if (trimmedDetails.isNotEmpty) {
      setState(() {
        if (pressCount == 0) {
          // Add new detail if the button was not pressed before
          widget.complaintDetails.add(
            ComplaintDetail(
              updateDate: formattedDate,
              details: trimmedDetails,
            ),
          );
        } else {
          // Replace old detail with new detail if the button was pressed before
          widget.complaintDetails[0] = ComplaintDetail(
            updateDate: formattedDate,
            details: trimmedDetails,
          );
        }

        pressCount = 1; // Reset the press count to 1
      });

      widget.onChanged(widget.complaintDetails[0]);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  var snackBar = SnackBar(
    content: Text('Complaint Details Added!!!'),
    );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xffe3e4e5)),
        color: Color(0xfff0efff),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextFormField(
                style: TextStyle(fontSize: screenHeight / 55),
                initialValue: formattedDate,
                enabled: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              validator: (value) => value!.isEmpty ? 'Missing Field' : null,
              style: TextStyle(fontSize: screenHeight / 50),
              controller: detailsController,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Details',
              ),
              onChanged: (details) {
                setState(() {
                  fDetail = details;
                });
              },
            ),
          ),
          /* IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              String trimmedDetails = fDetail.trim();
              if (trimmedDetails.isNotEmpty) {
                ComplaintDetail complaintDetail = ComplaintDetail(
                  updateDate: formattedDate,
                  details: trimmedDetails,
                );
                widget.onChanged(complaintDetail);
                //detailsController.clear();
              }
            },
          ), */
          ElevatedButton(  
            onPressed: _handleButtonPress,
            style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xff4d47c3)),
                  ),
            child: Text('Add',
                              style: TextStyle(fontSize: screenHeight / 45,)),
          ),
        ],
      ),
    );
    
  }

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }
}

Container buildComplaintDetailsContainerView(List<ComplaintDetail> complaintDetails) {
  List<Widget> detailWidgets = [];

  for (ComplaintDetail detail in complaintDetails) {
    detailWidgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail.updateDate,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: screenHeight / 50,
              fontWeight: FontWeight.w500,
              height: 1,
              color: Color(0xff000000),
            ),
          ),
          SizedBox(height: 5),
          Text(
            detail.details,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: screenHeight / 50,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Color(0xff000000),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  return Container(
    width: screenWidth,
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Color(0xffe3e4e5)),
      color: Color(0xfff0efff),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: detailWidgets,
    ),
  );
}
