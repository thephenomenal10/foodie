import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodieapp/vendors/screens/HomePage.dart';
import 'package:foodieapp/vendors/screens/pendingOrdersScreen.dart';
import 'package:foodieapp/vendors/screens/account_screen.dart';
import 'package:foodieapp/vendors/screens/customer_orders_screen.dart';
import 'package:foodieapp/vendors/services/local_notifications.dart';

class BottomNavigationScreen extends StatefulWidget {
  final index;
  BottomNavigationScreen({this.index=0});
  @override
  State<StatefulWidget> createState() {
    return BottomNavigationScreenState();
  }
}

class BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex=widget.index;
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (message) {
        print(message);
        LocalNotifications.showNotification(message);
        return;
      },
      onResume: (message) {
        print(message);
        return;
      },
      onLaunch: (message) {
        print(message);
        return;
      },
    );
    LocalNotifications.showScheduledNotification();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: new Container(
          child: [
            Center(child: Home()),
            Center(child: CustomerOrdersScreen()),
            Center(child: PendingOrders()),
            Center(child: AccountScreen()),
          ][_currentIndex],
        ),
        bottomNavigationBar: new BottomNavigationBar(
          currentIndex: _currentIndex,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text("Home"),
                backgroundColor: Colors.greenAccent),
            BottomNavigationBarItem(
              icon: new Icon(Icons.event_note),
              title: new Text("Orders"),
            ),
            BottomNavigationBarItem(
              icon: new Icon(FlutterIcons.note_text_mco),
              title: new Text("Pending Orders"),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              title: new Text("Profile"),
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
