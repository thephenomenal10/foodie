import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:foodieapp/vendors/widgets/Orders.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController tabController;

  Firestore firestore = Firestore.instance;

  String currentUserName;

  Future<void> getCurrentUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserName = prefs.getString("currentUserName");
      print(currentUserName);
    });
  }

  // Future<void> getCurrentOrders() async {
  //   firestore
  //       .collection("test_customer_orders")
  //       .where("endDate", isLessThanOrEqualTo: new DateTime.now())
  //       .getDocuments()
  //       .then((value) {
  //     print("Firestore response: ${value.documents.length}");

  //     value.documents.forEach((docs) {
  //       // print("Frestore docs response: ${docs.data}");
  //       if (docs.data['endDate'] == new DateTime.now()) {
  //       } else {
  //         print("there is no current orders, have a nice day");
  //         List res = [docs.data];
  //         print(res);
  //       }
  //     });
  //   });
  // }

  Future<void> getOrders() async {
    firestore
        .collection("tiffen_service_details")
        .document("vendor@test.com")
        .collection("orders")
        .where("endDate", isGreaterThanOrEqualTo: new DateTime.now())
        .getDocuments()
        .then((value) {
      print("Firestore response: ${value.documents.length}");

      value.documents.forEach((docs) {
        print("Frestore docs response: ${docs.data}");
       
      });
    });
  }

  @override
  void initState() {
    getCurrentUserEmail();
    getOrders();
    super.initState();
    tabController = new TabController(length: 7, vsync: this, initialIndex: 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: firestore
            .collection("test_customer_orders")
            .where("startDate", isGreaterThanOrEqualTo: new DateTime.now())
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            var doc = snapshot.data;
            print(doc);
            return Scaffold(
              appBar: new AppBar(
                automaticallyImplyLeading: false,
                title: new Image(
                  image: AssetImage("assets/appLogo.jpg"),
                  height: 120.0,
                  width: 120.0,
                ),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  GestureDetector(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(Icons.chat_bubble,
                            color: primaryColor, size: 35)),
                    onTap: () {},
                  ),
                ],
                elevation: 10.0,
                flexibleSpace: SizedBox(height: 150),
                bottom: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.black,
                  labelColor: primaryColor,
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 3.0),
                  tabs: [
                    Container(
                      padding: EdgeInsetsDirectional.only(bottom: 15.0),
                      child: Text(
                        DateFormat.yMMMd().format(
                          DateTime.now().subtract(
                            Duration(days: 3),
                          ),
                        ),
                        style: new TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.only(bottom: 15.0),
                      child: Text(
                        DateFormat.yMMMd().format(
                          DateTime.now().subtract(
                            Duration(days: 2),
                          ),
                        ),
                        style: new TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.only(bottom: 15.0),
                      child: Text(
                        'Yesterday',
                        style: new TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.only(bottom: 15.0),
                      child: Text(
                        'Today',
                        style: new TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.only(bottom: 15.0),
                      child: Text(
                        'Tomorrow',
                        style: new TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.only(bottom: 15.0),
                      child: Text(
                        DateFormat.yMMMd().format(
                          DateTime.now().add(
                            Duration(days: 2),
                          ),
                        ),
                        style: new TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.only(bottom: 15.0),
                      child: Text(
                        DateFormat.yMMMd().format(
                          DateTime.now().add(
                            Duration(days: 3),
                          ),
                        ),
                        style: new TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ],
                  controller: tabController,
                  indicatorColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
                bottomOpacity: 1,
              ),
              //body...........................
              body: new TabBarView(
                children: [
                  Orders(
                    dateTime: DateFormat.yMMMd().format(
                      DateTime.now().subtract(
                        Duration(days: 3),
                      ),
                    ),
                    userName: "currentUserName",
                  ),
                  Orders(
                    dateTime: DateFormat.yMMMd().format(
                      DateTime.now().subtract(
                        Duration(days: 2),
                      ),
                    ),
                    userName: "currentUserName",
                  ),
                  Orders(
                    dateTime: DateFormat.yMMMd().format(
                      DateTime.now().subtract(
                        Duration(days: 1),
                      ),
                    ),
                    userName: "currentUserName",
                  ),
                  Orders(
                      dateTime: DateFormat.yMMMd().format(
                        DateTime.now(),
                      ),
                      userName: currentUserName),
                  Orders(
                    dateTime: DateFormat.yMMMd().format(
                      DateTime.now().add(
                        Duration(days: 1),
                      ),
                    ),
                    userName: currentUserName,
                  ),
                  Orders(
                    dateTime: DateFormat.yMMMd().format(
                      DateTime.now().add(
                        Duration(days: 2),
                      ),
                    ),
                    userName: currentUserName,
                  ),
                  Orders(
                    dateTime: DateFormat.yMMMd().format(
                      DateTime.now().add(
                        Duration(days: 3),
                      ),
                    ),
                    userName: currentUserName,
                  ),
                ],
                controller: tabController,
              ),
            );
          }
          // return null;
        });
  }
}
