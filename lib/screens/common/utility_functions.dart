//import 'package:provider/provider.dart';
//import 'package:flutter_app/models/order_details_model.dart';
import 'package:intl/intl.dart';

//final orderDetailsList = Provider.of<List<OrderDetailsModel>>(context);
class SaleOrderDashBoard {
  int salesCount = 0;
  double salesAmount = 0.0;
  String bonus = '';
  SaleOrderDashBoard(this.salesCount,this.salesAmount);
}

class CallDetailDashBoard {
  int callsCount = 0;
  int callsConverted = 0;
  CallDetailDashBoard(this.callsCount,this.callsConverted);
}

int _pendingOrderCount = 0;
int _pendingComplaintsCount = 0;
int _followUpCount = 0;

SaleOrderDashBoard getSalesOrderCountAmtThisMonth(List orderDetailsList) {
  SaleOrderDashBoard sdb = SaleOrderDashBoard(0, 0.0);
  DateTime now = DateTime.now();
  orderDetailsList.forEach((element) {
      DateTime deliveredDate = DateFormat('dd/MM/yy').parse(element.deliveryDate);
        if ((element.dropdown == 'Delivered') && (now.month == deliveredDate.month && now.year == deliveredDate.year)) {
          sdb.salesCount++;
          sdb.salesAmount += double.parse(element.totalAmount);
        }
      });
      sdb.bonus = (sdb.salesAmount / 10).toStringAsFixed(2);
  return sdb;
}

int getPendingOrderCount(List orderDetailsList) {
  _pendingOrderCount = 0;
  orderDetailsList.forEach((element) {
        if (element.dropdown != 'Delivered') { //&& (DateTime.now().month == DateFormat('MM').parse(element.deliveryDate).month)) {
          _pendingOrderCount++;
          
        }
      });
  return _pendingOrderCount;
}

/* CallDetailDashBoard getCallsCountConvertedThisMonth(List callDetailsList) {
  CallDetailDashBoard cdb = CallDetailDashBoard(0, 0);
  callDetailsList.forEach((element) {
        if (DateTime.now().month == DateFormat('MM').parse(element.callDate).month) {
          cdb.callsCount++;
          if (element.callResult == 'Converted')
            cdb.callsConverted++;
        }
      });
  return cdb;
}
 */
CallDetailDashBoard getCallsCountConvertedThisMonth(List callDetailsList) {
  CallDetailDashBoard cdb = CallDetailDashBoard(0, 0);
  DateTime now = DateTime.now();
  callDetailsList.forEach((element) {
    DateTime callDate = DateFormat('dd/MM/yy').parse(element.callDate);
    if (now.month == callDate.month && now.year == callDate.year) {
      cdb.callsCount++;
      if (element.callResult == 'Converted') {
        cdb.callsConverted++;
      }
    }
  });
  return cdb;
}

int getPendingComplaintCount(List complaintsList) {
  _pendingComplaintsCount = 0;
  complaintsList.forEach((element) {
        if (element.complaintResult != 'Closed') { 
          _pendingComplaintsCount++;
          
        }
      });
  return _pendingComplaintsCount;
}

int getFollowUpCount(List callDetailsList) {
  _followUpCount = 0;
  callDetailsList.forEach((element) {
        if (element.followUp) { 
          _followUpCount++;
          
        }
      });
  return _followUpCount;
}
