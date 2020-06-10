import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:foodieapp/vendors/tabs.dart';

class BottomNavigationScreen extends StatefulWidget {
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
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (message) {
        print(message);
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
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: new Container(
          child: tabs[_currentIndex],
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
