import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';

import 'MyAppBar.dart';

class AcceptedOrders extends StatefulWidget {
  final String vendorEmail, orderId;

  const AcceptedOrders({Key key, this.vendorEmail, this.orderId})
      : super(key: key);

  @override
  _AcceptedOrdersState createState() => _AcceptedOrdersState();
}

class _AcceptedOrdersState extends State<AcceptedOrders> {
  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: PreferredSize(
        child: MyAppBar(),
        preferredSize: Size.fromHeight(60.0),
      ),
      body: new ListView(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: new Text(
                    "Accepted Orders",
                    style: new TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 25.0),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
              child: new StreamBuilder(
                  stream: _firestore
                      .collection(
                          'tiffen_service_details/${widget.vendorEmail}/AcceptedOrders')
                      .document(widget.orderId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      var doc = snapshot.data;
                      return Card(
                        elevation: 6.0,
                        child: ListTile(
                          leading: Image.asset(
                            "assets/my1.png",
                            fit: BoxFit.contain,
                          ),
                          title: Text(
                            doc['customerName'],
                            style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.03,
                            ),
                          ),
                          subtitle: Text(
                            doc['customerAddress'],
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: height * 0.025,
                            ),
                          ),
                          trailing: RaisedButton(
                            color: primaryColor,
                            onPressed: () {
                              
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: height * 0.11,
                              width: width * 0.22,
                              child: Text(
                                "Show Subscription",
                                style: TextStyle(fontSize: width * 0.0385),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }))
        ],
      ),
    );
  }
}
