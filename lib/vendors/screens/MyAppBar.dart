import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodieapp/vendors/login.dart';

class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return new AppBar(
        title: new Text("VENDOR APP"),
        centerTitle: false,
        actions: <Widget>[
            GestureDetector(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(
                      AntDesign.logout,
                      semanticLabel: "Logout",
                      size: 30.0,
                  ),
              ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                },
            )
        ],
        brightness: Brightness.dark,
    );
  }
}
