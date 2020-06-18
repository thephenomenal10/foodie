import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/screens/orderInfo.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';

class Orders extends StatelessWidget {
  final String dateTime;
  final orders;

  const Orders({Key key, this.dateTime, this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: new Text(
                    "Welcome UserName,  have a good day",
                    style: new TextStyle(
                      fontSize: 18.0,
                      color: secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 2.0,
              indent: 10.0,
              endIndent: 10.0,
              color: Colors.grey.shade300,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: new Text(
                      "ACCEPTED ORDERS",
                      style: new TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: new Text(
                      dateTime.toString(),
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: Firestore.instance
                        .collection('customer_collection')
                        .document(orders[index]['customerId'])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image(
                                  image: snapshot.data['image'] != null
                                      ? NetworkImage(snapshot.data['image'])
                                      : AssetImage("assets/my1.png"),
                                  height: 85.0,
                                  width: 65.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "ORDER No: #${index + 1}",
                                      style: new TextStyle(
                                          color: secondaryColor, fontSize: 15),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      child: new Text(
                                        orders[index]['customerName'],
                                        style: new TextStyle(
                                            color: secondaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      child: new Text(
                                        orders[index]['customerAddress'],
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
                                            orders[index],
                                            snapshot.data['phone'],
                                            true,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text("Order Info"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        )
      ],
    );
  }
}
