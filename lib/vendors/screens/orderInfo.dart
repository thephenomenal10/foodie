import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/screens/customerAddressNavigationScreen.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MyAppBar.dart';
import 'PaymentSummary.dart';

class OrderInfo extends StatefulWidget {
  final index;
  final order;
  final phoneNumber;
  final bool accepted;

  OrderInfo(this.index, this.order, this.phoneNumber, this.accepted);

  @override
  _OrderInfoState createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  bool _isLoading = false;
  int sel = -1;
  void selectedRadio(value) {
    setState(() {
      sel = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        child: MyAppBar(),
        preferredSize: Size.fromHeight(60.0),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: myGreen,
        children: [
          SpeedDialChild(
            backgroundColor: myGreen,
            child: Icon(
              MaterialIcons.call,
              size: 30.0,
            ),
            label: "call customer",
            onTap: () {
              launch('tel:${widget.phoneNumber}');
            },
          ),
          SpeedDialChild(
            backgroundColor: myGreen,
            child: Icon(
              AntDesign.customerservice,
              size: 30.0,
            ),
            label: "call care",
            onTap: () {
              launch('tel:0123654789');
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            )
          : ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: new Text(
                    "Customer Info",
                    style: new TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  height: 150,
                  child: new Card(
                    elevation: 6.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  "Name",
                                  style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w400,
                                    // fontSize: 15.0,
                                  ),
                                ),
                                new Text(
                                  widget.order['customerName'],
                                  style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                    // fontSize: 15.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  "Contact no",
                                  style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w400,
                                    // fontSize: 15.0,
                                  ),
                                ),
                                new Text(
                                  widget.phoneNumber,
                                  style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                    // fontSize: 15.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  "Address",
                                  style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w400,
                                    // fontSize: 15.0,
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: new Text(
                                    widget.order['customerAddress'],
                                    style: new TextStyle(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w500,
                                      // fontSize: 15.0,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: new Text(
                    "Order Info",
                    style: new TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                      height: 300,
                      child: new Card(
                        elevation: 6.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                      "Meal Type",
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w400,
                                        // fontSize: 15.0,
                                      ),
                                    ),
                                    new Text(
                                      widget.order['foodType'],
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500,
                                        // fontSize: 15.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                      "Meal Description",
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w400,
                                        // fontSize: 15.0,
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: new Text(
                                        widget.order['mealDescription'],
                                        style: new TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w500,
                                          // fontSize: 15.0,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                      "Start Date",
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w400,
                                        // fontSize: 15.0,
                                      ),
                                    ),
                                    new Text(
                                      DateFormat.yMMMd()
                                          .format(widget.order['startDate']
                                              .toDate())
                                          .toString(),
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500,
                                        // fontSize: 15.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                      "Subscription Days",
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w400,
                                        // fontSize: 15.0,
                                      ),
                                    ),
                                    new Text(
                                      widget.order['subscriptionDays']
                                          .toString(),
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500,
                                        // fontSize: 15.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                      "Payment Mode",
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w400,
                                        // fontSize: 15.0,
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: new Text(
                                        widget.order['paymentMode'],
                                        style: new TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w500,
                                          // fontSize: 15.0,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                      "Order Suggestion",
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w400,
                                        // fontSize: 15.0,
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: new Text(
                                        widget.order['orderNotes'] == ""
                                            ? "no suggestions"
                                            : widget.order['orderNotes'],
                                        style: new TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w500,
                                          // fontSize: 15.0,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                      "Total Amount",
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w400,
                                        // fontSize: 15.0,
                                      ),
                                    ),
                                    new Text(
                                      "Rs. ${widget.order['totalCost'].toString()}",
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500,
                                        // fontSize: 15.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    widget.accepted == true
                        ? SizedBox()
                        : widget.order['paymentMode'] == 'Cash On Delivery'
                            ? SizedBox()
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    RaisedButton(
                                      color: primaryColor,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PaymentSumm(
                                              paymentProof: widget
                                                  .order['proofOfPayment'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: new Text("Payment Proof"),
                                    ),
                                  ],
                                ),
                              ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      widget.accepted == true
                          ? FloatingActionButton.extended(
                              backgroundColor: primaryColor,
                              hoverColor: Colors.white,
                              splashColor: secondaryColor,
                              heroTag: "tag3",
                              isExtended: true,
                              label: new Text(
                                "Find Customer",
                                style: new TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerAddressNavigate(
                                      customerAddress: widget
                                          .order['customerCoordinates']
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: width * 0.40,
                              child: FloatingActionButton(
                                backgroundColor: primaryColor,
                                hoverColor: Colors.white,
                                splashColor: secondaryColor,
                                heroTag: "tag1",
                                isExtended: true,
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  final email = widget.order['vendorEmail'];
                                  final customerUid =
                                      widget.order['customerId'];
                                  Map<String, dynamic> updatedOrder =
                                      widget.order.data;
                                  updatedOrder['orderStatus'] = 'Accepted';
                                  await Firestore.instance
                                      .collection(
                                          'tiffen_service_details/$email/acceptedOrders')
                                      .document(widget.order['orderId'])
                                      .setData(updatedOrder);
                                  await Firestore.instance
                                      .collection(
                                          'tiffen_service_details/$email/pendingOrders')
                                      .document(widget.order['orderId'])
                                      .delete();
                                  await Firestore.instance
                                      .collection(
                                          'customer_collection/$customerUid/acceptedOrders')
                                      .document(widget.order['orderId'])
                                      .setData(updatedOrder);
                                  await Firestore.instance
                                      .collection(
                                          'customer_collection/$customerUid/pendingOrders')
                                      .document(widget.order['orderId'])
                                      .delete();
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: new Text(
                                  "Accept",
                                  style: new TextStyle(fontSize: 25.0),
                                ),
                              ),
                            ),
                      widget.accepted == true
                          ? SizedBox()
                          : Container(
                              width: width * 0.40,
                              child: FloatingActionButton(
                                backgroundColor: primaryColor,
                                hoverColor: Colors.white,
                                splashColor: Colors.white,
                                isExtended: true,
                                heroTag: "tag2",
                                onPressed: () async {
                                  await Navigator.of(context).push(
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (context, _, __) =>
                                          ModalBottomSheet(widget.order),
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: new Text(
                                  "Reject",
                                  style: new TextStyle(fontSize: 25.0),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.0,
                )
              ],
            ),
    );
  }
}

class ModalBottomSheet extends StatefulWidget {
  final order;
  ModalBottomSheet(this.order);
  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  int sel = -1;
  String report;
  bool _isLoading = false;
  void selectedRadio(value) {
    setState(() {
      sel = value;
    });
    if (sel == 0) {
      report = "Payment not received";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            )
          : Column(
              children: <Widget>[
                Expanded(child: SizedBox()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Tell us the reason :',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Radio(
                            value: 0,
                            groupValue: sel,
                            onChanged: (value) => selectedRadio(value),
                            activeColor: Theme.of(context).primaryColor,
                          ),
                          Text(
                            'Payment not received',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Radio(
                            value: 1,
                            groupValue: sel,
                            onChanged: (value) => selectedRadio(value),
                            activeColor: Theme.of(context).primaryColor,
                          ),
                          Text(
                            'Others',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      sel == 1
                          ? Form(
                              key: _formKey,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'enter a message';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  fillColor: Theme.of(context).primaryColor,
                                ),
                                onChanged: (value) {
                                  report = value;
                                },
                                onSaved: (newValue) {
                                  report = newValue;
                                },
                              ),
                            )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            child: Text('Submit'),
                            onPressed: () async {
                              if (sel == 0 ||
                                  _formKey.currentState.validate()) {
                                print('saved');
                                if (sel != 0) {
                                  _formKey.currentState.save();
                                  sel = 1;
                                }
                              } else {
                                sel = -1;
                              }
                              if (sel != -1) {
                                setState(() {
                                  _isLoading = true;
                                });
                                final email = widget.order['vendorEmail'];
                                final customerUid = widget.order['customerId'];
                                Map<String, dynamic> updatedOrder =
                                    widget.order.data;
                                updatedOrder['orderStatus'] = 'Rejected';
                                updatedOrder
                                    .addAll({'rejectionReason': report});
                                await Firestore.instance
                                    .collection(
                                        'tiffen_service_details/$email/rejectedOrders')
                                    .document(widget.order['orderId'])
                                    .setData(updatedOrder);
                                print('check one');
                                await Firestore.instance
                                    .collection(
                                        'tiffen_service_details/$email/pendingOrders')
                                    .document(widget.order['orderId'])
                                    .delete();
                                print("check+two");
                                await Firestore.instance
                                    .collection(
                                        'customer_collection/$customerUid/rejectedOrders')
                                    .document(widget.order['orderId'])
                                    .setData(updatedOrder);
                                print("check+three");
                                await Firestore.instance
                                    .collection(
                                        'customer_collection/$customerUid/pendingOrders')
                                    .document(widget.order['orderId'])
                                    .delete();
                                setState(() {
                                  print("check+four");
                                  _isLoading = false;
                                });
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
