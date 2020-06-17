import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/screens/acceptedOrdersScreen.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:foodieapp/vendors/widgets/dialogBox.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MyAppBar.dart';
import 'PaymentSummary.dart';

class OrderInfo extends StatefulWidget {
  final String name;
  final String address;
  final String mealType;
  final int subscriptionDays;
  final int index;
  final String orderId;
  final double customerLatitude, customerLongitude, totalCost;
  final String paymentMode, orderSuggestion, proofOfPayment, mealDescription, vendorEmail;

  const OrderInfo(
      {Key key,
      this.name,
      this.address,
      this.mealType,
      this.subscriptionDays,
      this.index,
      this.orderId,
      this.customerLatitude,
      this.customerLongitude,
      this.paymentMode,
      this.orderSuggestion,
      this.proofOfPayment,
      this.totalCost,
      this.mealDescription, this.vendorEmail})
      : super(key: key);

  @override
  _OrderInfoState createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Icon(MaterialIcons.call, size: 30.0, color: Colors.white),
              label: "call customer",
              onTap: () {
                launch('tel:0123654789');
              }),
          SpeedDialChild(
              backgroundColor: myGreen,
              child: Icon(
                AntDesign.customerservice,
                color: Colors.white,
                size: 30.0,
              ),
              label: "call care",
              onTap: () {
                launch('tel:0123654789');
              }),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20.0, top: 20.0),
            child: new Text(
              "Customer Info",
              style: new TextStyle(
                  color: secondaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 25.0),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            height: 150,
            child: new Card(
              elevation: 6.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                            widget.name,
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
                            "Contact no.",
                            style: new TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 15.0),
                          ),
                          new Text(
                            "1234567890",
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
                            "Address",
                            style: new TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 15.0),
                          ),
                          new Text(
                            widget.address,
                            style: new TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0),
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
                  fontSize: 25.0),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                height: 300,
                child: new Card(
                  elevation: 6.0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Text(
                                "Meal Type",
                                style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0),
                              ),
                              new Text(
                                widget.mealType,
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
                                "Meal Description",
                                style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0),
                              ),
                              new Text(
                                widget.mealDescription,
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
                                "Subscription Days",
                                style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0),
                              ),
                              new Text(
                                "${widget.subscriptionDays.toString()} Days",
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
                                "Payment Mode",
                                style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0),
                              ),
                              new Text(
                                widget.paymentMode,
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
                                "Order Suggestion",
                                style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0),
                              ),
                              new Text(
                                widget.orderSuggestion == ""
                                    ? "Nothing"
                                    : widget.orderSuggestion,
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
                                "Total Amout",
                                style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0),
                              ),
                              new Text(
                                "₹ ${widget.totalCost}".toString(),
                                style: new TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
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
                                  builder: (context) => PaymentSumm( paymentProof: widget.proofOfPayment)));
                        },
                        child: new Text(
                          "Payment Proof",
                          style: new TextStyle(
                            color: Colors.white,
                          ),
                        )),
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
                  fontSize: 25.0),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                    onPressed: () {
                      acceptOrder();
                      DialogBox().information(
                          context, "Order", "order has been accepted");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AcceptedOrders(
                                orderId: widget.orderSuggestion,
                                vendorEmail: widget.vendorEmail
                              )));
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
                    onPressed: () {},
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

  Future<void> acceptOrder() async {
    String email = (await FirebaseAuth.instance.currentUser()).email;

    _firestore
        .collection('tiffen_service_details/$email/orders')
        .document(widget.orderId)
        .updateData({"orderAccepted": true}).whenComplete(() {
      ordersAcceptedReplica();
    });
  }

  Future<void> ordersAcceptedReplica() async {
    String email = (await FirebaseAuth.instance.currentUser()).email;

    _firestore
        .collection('tiffen_service_details/$email/orders')
        .document(widget.orderId)
        .get()
        .then((datasnapshot) {
      if (datasnapshot.exists) {
        var data = datasnapshot.data;

        _firestore
            .collection('tiffen_service_details/$email/AcceptedOrders')
            .document(widget.orderId)
            .setData(data)
            .whenComplete(() {
          _firestore
              .collection('tiffen_service_details/$email/orders')
              .document(widget.orderId)
              .delete();
        });
      }
    });
  }
}
