import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/call_details_model.dart';

class FollowUpDetailsContainerEdit extends StatefulWidget {
  final Function(FollowUpDetail) onChanged;
  final List<FollowUpDetail> followUpDetails;

  const FollowUpDetailsContainerEdit({Key? key, required this.onChanged, required this.followUpDetails}) : super(key: key);

  @override
  _FollowUpDetailsContainerState createState() => _FollowUpDetailsContainerState();
}

class _FollowUpDetailsContainerState extends State<FollowUpDetailsContainerEdit> {
  String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
  TextEditingController detailsController = TextEditingController();
  String fDetail = '';
  //List<FollowUpDetail> followUpDetails = [];
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
          widget.followUpDetails[widget.followUpDetails.length - 1] = FollowUpDetail(
            followUpDate: formattedDate,
            details: trimmedDetails,
          );
        }

        pressCount = 1; // Reset the press count to 1
      });

      widget.onChanged(widget.followUpDetails[widget.followUpDetails.length - 1]);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }


  @override
  Widget build(BuildContext context) {
    //if (widget.isEdit) {
      return buildFollowUpDetailsContainerEdit();
  }

  var snackBar = SnackBar(
    content: Text('FollowUp Details Added!!!'),
    );

Container buildFollowUpDetailsContainerEdit() {
  String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
  TextEditingController detailsController = TextEditingController();

  return Container(
    width: 440,
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Color(0xffe3e4e5)),
      color: Color(0xfff0efff),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (FollowUpDetail detail in widget.followUpDetails)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detail.followUpDate,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
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
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: Color(0xff000000),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        //SizedBox(height: 10),
        Row(
        children: [
          Expanded(
            flex: 1,
            child: TextFormField(
              initialValue: formattedDate,
              enabled: false,
              // 
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  color: Color(0xff000000),
                ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              //controller: detailsController,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Details',
              ),
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: Color(0xff000000),
                ),
              onChanged: (details) {
                setState(() {
                  fDetail = details;
                });
              },
            ),
          ),
          //IconButton(
            //TextButton(
            ElevatedButton(  
            //icon: Icon(Icons.check),
            onPressed: _handleButtonPress,/* () {
              String trimmedDetails = fDetail.trim();
              if (trimmedDetails.isNotEmpty) {
                FollowUpDetail followUpDetail = FollowUpDetail(
                  followUpDate: formattedDate,
                  details: trimmedDetails,
                );
                //setState(() {
                  widget.followUpDetails.add(followUpDetail);
                  //detailsController.clear();
                //});

                widget.onChanged(followUpDetail);
                //detailsController.clear();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }, */
            style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xff4d47c3)),
                  ),
            child: const Text('Add',
                              style: TextStyle(fontSize: 18,)),
          ),
        ],
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
