import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';

import 'MyAppBar.dart';
import 'orderInfo.dart';

class PendingOrders extends StatelessWidget {
  final _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: MyAppBar(),
        preferredSize: Size.fromHeight(60.0),
      ),
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          }
          final FirebaseUser user = snapshot.data;
          return ListView(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: new Text(
                        "Pending Orders",
                        style: new TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 25.0,
                        ),
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
                          'tiffen_service_details/${user.email}/acceptedOrders')
                      .snapshots(),
                  builder: (context, streamSnapshot) {
                    if (streamSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      );
                    }
                    final docs = streamSnapshot.data.documents;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => FutureBuilder(
                        future: Firestore.instance
                            .collection('customer_collection')
                            .document(docs[index]['customerId'])
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          }
                          return Container(
                            child: Card(
                              elevation: 6.0,
                              child: new Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 10.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image(
                                      image: snapshot.data['image'] != null
                                          ? NetworkImage(snapshot.data['image'])
                                          : AssetImage("assets/my1.png"),
                                      height: 85.0,
                                      width: 65.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "ORDER No: #${index + 1}",
                                          style: new TextStyle(
                                              color: secondaryColor,
                                              fontSize: 15),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: new Text(
                                            docs[index]['customerName'],
                                            style: new TextStyle(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: new Text(
                                            docs[index]['customerAddress'],
                                            style: new TextStyle(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: RaisedButton(
                                        color: primaryColor,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => OrderInfo(
                                                index,
                                                docs[index],
                                                snapshot.data['phone'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: new Text("Order Info"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      itemCount: docs.length,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}