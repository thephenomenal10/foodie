import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:foodieapp/vendors/widgets/Orders.dart';
import 'package:foodieapp/vendors/widgets/ordersData.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController tabController;
  var email;

  Future<void> getCurrentUser() async {
    email = (await FirebaseAuth.instance.currentUser()).email;
  }

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 7, vsync: this, initialIndex: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Image(
          image: AssetImage("assets/appLogo.jpg"),
          height: 120.0,
          width: 120.0,
        ),
        backgroundColor: Colors.white,
        elevation: 10.0,
        flexibleSpace: SizedBox(height: 150),
        bottom: TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.black,
          labelColor: primaryColor,
          labelPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 3.0),
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
      body: FutureBuilder(
        future: getCurrentUser(),
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
          return StreamBuilder(
              stream: Firestore.instance
                  .collection('tiffen_service_details/$email/acceptedOrders')
                  .orderBy('startDate', descending: true)
                  .snapshots(),
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
                final orders = snapshot.data.documents;
                return TabBarView(
                  children: [
                    Orders(
                      dateTime: DateFormat.yMMMd().format(
                        DateTime.now().subtract(
                          Duration(
                            days: 3,
                          ),
                        ),
                      ),
                      orders: OrdersList(
                        orders: orders,
                        date: DateTime.now().subtract(
                          Duration(
                            days: 3,
                            hours: DateTime.now().hour,
                            minutes: DateTime.now().minute,
                            seconds: DateTime.now().second,
                          ),
                        ),
                      ).getDayOrders(),
                    ),
                    Orders(
                      dateTime: DateFormat.yMMMd().format(
                        DateTime.now().subtract(
                          Duration(days: 2),
                        ),
                      ),
                      orders: OrdersList(
                        orders: orders,
                        date: DateTime.now().subtract(
                          Duration(
                            days: 2,
                            hours: DateTime.now().hour,
                            minutes: DateTime.now().minute,
                            seconds: DateTime.now().second,
                          ),
                        ),
                      ).getDayOrders(),
                    ),
                    Orders(
                      dateTime: DateFormat.yMMMd().format(
                        DateTime.now().subtract(
                          Duration(days: 1),
                        ),
                      ),
                      orders: OrdersList(
                        orders: orders,
                        date: DateTime.now().subtract(
                          Duration(
                            days: 1,
                            hours: DateTime.now().hour,
                            minutes: DateTime.now().minute,
                            seconds: DateTime.now().second,
                          ),
                        ),
                      ).getDayOrders(),
                    ),
                    Orders(
                      dateTime: DateFormat.yMMMd().format(DateTime.now()),
                      orders: OrdersList(
                        orders: orders,
                        date: DateTime.now().subtract(Duration(
                          hours: DateTime.now().hour,
                          minutes: DateTime.now().minute,
                          seconds: DateTime.now().second,
                        )),
                      ).getDayOrders(),
                    ),
                    Orders(
                      dateTime: DateFormat.yMMMd().format(
                        DateTime.now().add(
                          Duration(days: 1),
                        ),
                      ),
                      orders: OrdersList(
                        orders: orders,
                        date: DateTime.now()
                            .subtract(Duration(
                              hours: DateTime.now().hour,
                              minutes: DateTime.now().minute,
                              seconds: DateTime.now().second,
                            ))
                            .add(
                              Duration(days: 1),
                            ),
                      ).getDayOrders(),
                    ),
                    Orders(
                      dateTime: DateFormat.yMMMd().format(
                        DateTime.now().add(
                          Duration(days: 2),
                        ),
                      ),
                      orders: OrdersList(
                        orders: orders,
                        date: DateTime.now()
                            .subtract(Duration(
                              hours: DateTime.now().hour,
                              minutes: DateTime.now().minute,
                              seconds: DateTime.now().second,
                            ))
                            .add(
                              Duration(days: 2),
                            ),
                      ).getDayOrders(),
                    ),
                    Orders(
                      dateTime: DateFormat.yMMMd().format(
                        DateTime.now().add(
                          Duration(days: 3),
                        ),
                      ),
                      orders: OrdersList(
                        orders: orders,
                        date: DateTime.now()
                            .subtract(Duration(
                              hours: DateTime.now().hour,
                              minutes: DateTime.now().minute,
                              seconds: DateTime.now().second,
                            ))
                            .add(
                              Duration(days: 3),
                            ),
                      ).getDayOrders(),
                    ),
                  ],
                  controller: tabController,
                );
              });
        },
      ),
    );
  }
}
