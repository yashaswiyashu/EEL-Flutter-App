import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/complaint_details_model.dart';


class ComplaintDetailsContainer extends StatefulWidget {
  final Function(ComplaintDetail) onChanged;

  const ComplaintDetailsContainer({Key? key, required this.onChanged}) : super(key: key);

  @override
  _ComplaintDetailsContainerState createState() => _ComplaintDetailsContainerState();
}

class _ComplaintDetailsContainerState extends State<ComplaintDetailsContainer> {
  String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
  TextEditingController detailsController = TextEditingController();
  String fDetail = '';
  List<ComplaintDetail> complaintDetails = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 440,
      height: 83,
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
            child: TextFormField(
              initialValue: formattedDate,
              enabled: false,
              decoration: InputDecoration(
                border: InputBorder.none,
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
          IconButton(
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
    );
  }

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
      children: detailWidgets,
    ),
  );
}
