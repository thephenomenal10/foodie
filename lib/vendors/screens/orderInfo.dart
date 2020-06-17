import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MyAppBar.dart';
import 'PaymentSummary.dart';

class OrderInfo extends StatefulWidget {
  final index;
  final order;
  final phoneNumber;

  OrderInfo(this.index, this.order, this.phoneNumber);

  @override
  _OrderInfoState createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: MyAppBar(),
        preferredSize: Size.fromHeight(60.0),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.green,
        children: [
          SpeedDialChild(
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
                                      fontSize: 15.0),
                                ),
                                new Text(
                                  widget.order['customerName'],
                                  style: new TextStyle(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.0),
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
                                      fontSize: 15.0),
                                ),
                                new Text(
                                  widget.phoneNumber,
                                  style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
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
                                      fontSize: 15.0),
                                ),
                                new Text(
                                  widget.order['customerAddress'],
                                  style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
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
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    new Text(
                                      widget.order['foodType'],
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
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
                                      "Meal Time.",
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    new Text(
                                      "8:00 PM",
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
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
                                      "Subscription Plan",
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    new Text(
                                      "Active(20 % off)",
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
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
                                      "Payment Type",
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    new Text(
                                      widget.order['paymentMode'],
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
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
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    new Text(
                                      widget.order['orderNotes'] == ""
                                          ? "no suggestions"
                                          : widget.order['orderNotes'],
                                      style: new TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
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
                                    order: widget.order,
                                  ),
                                ),
                              );
                            },
                            child: new Text("Payment summary"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: new Text(
                    "Order Summary",
                    style: new TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 150.0,
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
                            final customerUid = widget.order['customerId'];
                            Map<String, dynamic> updatedOrder = widget.order;
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
                      Container(
                        width: 150,
                        child: FloatingActionButton(
                          backgroundColor: primaryColor,
                          hoverColor: Colors.white,
                          splashColor: Colors.white,
                          isExtended: true,
                          heroTag: "tag2",
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            final email = widget.order['vendorEmail'];
                            final customerUid = widget.order['customerId'];
                            Map<String, dynamic> updatedOrder = widget.order;
                            updatedOrder['orderStatus'] = 'Rejected';
                            await Firestore.instance
                                .collection(
                                    'tiffen_service_details/$email/rejectedOrders')
                                .document(widget.order['orderId'])
                                .setData(updatedOrder);
                            await Firestore.instance
                                .collection(
                                    'tiffen_service_details/$email/pendingOrders')
                                .document(widget.order['orderId'])
                                .delete();
                            await Firestore.instance
                                .collection(
                                    'customer_collection/$customerUid/rejectedOrders')
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
