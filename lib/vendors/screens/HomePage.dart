import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:foodieapp/vendors/widgets/Orders.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 7, vsync: this, initialIndex: 3);
    super.initState();
  }

// var date1, date2, date3, date4, date5, date6, date7;

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
        actions: <Widget>[
          GestureDetector(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(Icons.chat_bubble, color: primaryColor, size: 35)),
            onTap: () {},
          ),
          
        ],
        elevation: 10.0,
        flexibleSpace: SizedBox(height: 30),
        bottom: TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.black,
          labelColor: primaryColor,
          tabs: [

            Text(
              DateFormat.yMMMd().format(
                DateTime.now().subtract(
                  Duration(days: 3),
                ),
              ),
              style: new TextStyle(fontSize: 18.0),
            ),
            Text(
              DateFormat.yMMMd().format(
                DateTime.now().subtract(
                  Duration(days: 2),
                ),
              ),
              style: new TextStyle(fontSize: 18.0),
            ),
            Text(
              'Yesterday',
              style: new TextStyle(fontSize: 18.0),
            ),
            Text(
              'Today',
              style: new TextStyle(fontSize: 18.0),
            ),
            Text(
              'Tomorrow',
              style: new TextStyle(fontSize: 18.0),
            ),
            Text(
              DateFormat.yMMMd().format(
                DateTime.now().add(
                  Duration(days: 2),
                ),
              ),
              style: new TextStyle(fontSize: 18.0),
            ),
             Text(
              DateFormat.yMMMd().format(
                DateTime.now().add(
                  Duration(days: 3),
                ),
              ),
              style: new TextStyle(fontSize: 18.0),
            ),
          ],
          controller: tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: new TabBarView(
        children: [
         
          Orders(
            dateTime: DateFormat.yMMMd().format(
                DateTime.now().subtract(
                  Duration(days: 3),
                ),
              ) 
            ),
          Orders(
            dateTime: DateFormat.yMMMd().format(
                DateTime.now().subtract(
                  Duration(days: 2),
                ),
              ) 
          ),
          Orders(
            dateTime: DateFormat.yMMMd().format(
                DateTime.now().subtract(
                  Duration(days: 1),
                ),
              )
            ),
          Orders(
            dateTime: DateFormat.yMMMd().format(
                DateTime.now()
              )
          ),
          Orders(
            dateTime: DateFormat.yMMMd().format(
                DateTime.now().add(
                  Duration(days: 1),
                ),
              )
            ),
          Orders(
             dateTime: DateFormat.yMMMd().format(
                DateTime.now().add(
                  Duration(days: 2),
                ),
              )
          ),
          Orders(
             dateTime: DateFormat.yMMMd().format(
                DateTime.now().add(
                  Duration(days: 3),
                ),
              )
          ),
        ],
        controller: tabController,
      ),
    );
  }
}
