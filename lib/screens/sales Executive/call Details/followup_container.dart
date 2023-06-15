import 'package:flutter/material.dart';
import 'package:flutter_app/screens/common/globals.dart';
import 'package:intl/intl.dart';

import '../../../models/call_details_model.dart';


class FollowUpDetailsContainer extends StatefulWidget {
  final Function(FollowUpDetail) onChanged;
  final List<FollowUpDetail> followUpDetails;

  const FollowUpDetailsContainer({Key? key, required this.onChanged, required this.followUpDetails}) : super(key: key);

  @override
  _FollowUpDetailsContainerState createState() => _FollowUpDetailsContainerState();
}

class _FollowUpDetailsContainerState extends State<FollowUpDetailsContainer> {
  String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
  TextEditingController detailsController = TextEditingController();
  String fDetail = '';
  int pressCount = 0;

  void _handleButtonPress() {
    String trimmedDetails = fDetail.trim();
    if (trimmedDetails.isNotEmpty) {
      setState(() {
        if (pressCount == 0) {
          // Add new detail if the button was not pressed before
          widget.followUpDetails.add(
            FollowUpDetail(
              followUpDate: formattedDate,
              details: trimmedDetails,
            ),
          );
        } else {
          // Replace old detail with new detail if the button was pressed before
          widget.followUpDetails[0] = FollowUpDetail(
            followUpDate: formattedDate,
            details: trimmedDetails,
          );
        }

        pressCount = 1; // Reset the press count to 1
      });

      widget.onChanged(widget.followUpDetails[0]);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  var snackBar = SnackBar(
    content: Text('FollowUp Details Added!!!'),
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
                FollowUpDetail followUpDetail = FollowUpDetail(
                  followUpDate: formattedDate,
                  details: trimmedDetails,
                );
                widget.onChanged(followUpDetail);
                //detailsController.clear();
              }
            },
          ), */
          ElevatedButton(  
            onPressed: _handleButtonPress,
            style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xff4d47c3)),
                  ),
            child: const Text('Add',
                              style: TextStyle(fontSize: 18,)),
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

Container buildFollowUpDetailsContainerView(List<FollowUpDetail> followUpDetails) {
  List<Widget> detailWidgets = [];

  for (FollowUpDetail detail in followUpDetails) {
    detailWidgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail.followUpDate,
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
              fontSize: screenHeight / 55,
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
