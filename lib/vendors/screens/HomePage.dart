import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/screens/MyAppBar.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:intl/intl.dart';
import '../widgets/ordersData.dart';
import 'orderInfo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  OrdersData _ordersData = new OrdersData();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM y').format(now);

    return Scaffold(
      appBar: PreferredSize(
        child: MyAppBar(),
        preferredSize: Size.fromHeight(60.0),
      ),
      body: new ListView(
        children: <Widget>[
//          Padding(padding: EdgeInsets.only(top: 2),),
          Container(
            height: 300,
            child: Carousel(
              boxFit: BoxFit.fitWidth,
              dotSize: 4.0,
              dotColor: Colors.white,
              autoplay: true,
              images: [
                AssetImage("assets/slider1.png"),
                AssetImage("assets/slider2.jpg"),
                AssetImage("assets/slider3.jpg"),
                AssetImage("assets/slider4.jpg"),
                AssetImage("assets/slider5.jpg"),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 8.0),),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: new Text(
                  "Welcome UserName,  have a good day",
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: secondaryColor,
                      fontWeight: FontWeight.w600),
                ),
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
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: new Text(
                        "ORDERS",
                        style: new TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 25.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: new Text(formattedDate),
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
                    itemCount: _ordersData.customerName.length,
                    itemBuilder: (context, index) {
                      int i = index + 1;
                      return Container(
                        child: Card(
                          elevation: 6.0,
                          child: new Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image(
                                    image: AssetImage("assets/my1.png"),
                                  height: 85.0,
                                  width: 65.0,
                                ),

                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "ORDER No: #$i",
                                      style: new TextStyle(
                                          color: secondaryColor, fontSize: 15),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      child: new Text(
                                        _ordersData.customerName[index],
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
                                              _ordersData.customerAddress[index],
                                              style: new TextStyle(
                                                  color: secondaryColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18.0),
                                          ),
                                      )
                                  ],
                                ),
                                Container(
                                  child: RaisedButton(
                                    color: primaryColor,
                                    onPressed: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(
                                            builder: (context) => OrderInfo(
                                                index,
                                                _ordersData.customerName[index],
                                                _ordersData.customerAddress[index])));
                                    },
                                    child: new Text("Order Info"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 20.0,
              )
            ],
          )
        ],
      ),
    );
  }
}
