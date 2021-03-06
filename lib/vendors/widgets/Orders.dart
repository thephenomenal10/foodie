import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/screens/orderInfo.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';

class Orders extends StatelessWidget {
  final String dateTime;
  final orders;
  final vendorName;
  final bool isSunday;

  const Orders(
      {Key key, this.dateTime, this.orders, this.vendorName, this.isSunday})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(isSunday);
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
                Flexible(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: new Text(
                      "Welcome $vendorName ,  have a good day",
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
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
            isSunday
                ? Column(
                    children: <Widget>[
                      SizedBox(
                        child: Image.asset(
                          "assets/food1.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        child: Image.asset(
                          "assets/popup_payment.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          'Sunday is Holiday!',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "ACCEPTED ORDERS",
                          style: new TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                        new Text(
                          dateTime.toString(),
                          style: new TextStyle(
                            fontSize: 18.0,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
            SizedBox(
              height: 20.0,
            ),
            if (!isSunday)
              orders.length == 0
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          child: Image.asset(
                            "assets/empty_sub.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            'No Orders!',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.085,
                                          backgroundImage: snapshot
                                                      .data['image'] !=
                                                  null
                                              ? NetworkImage(
                                                  snapshot.data['image'])
                                              : AssetImage("assets/my1.png"),
                                        ),
                                        SizedBox(width: 5),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "ORDER No: #${index + 1}",
                                              style: new TextStyle(
                                                color: secondaryColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.50,
                                              child: new Text(
                                                orders[index]['customerName'],
                                                style: new TextStyle(
                                                  color: secondaryColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: new Text(
                                                orders[index]
                                                    ['customerAddress'],
                                                style: new TextStyle(
                                                  color: secondaryColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15.0,
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
                                                  builder: (context) =>
                                                      OrderInfo(
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
