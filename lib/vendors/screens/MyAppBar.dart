import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';


class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: new Image(
            image: AssetImage("assets/appLogo.jpg"),
                height: 120.0, width: 120.0
        ),
        actions: <Widget>[
            GestureDetector(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(
                      Icons.chat_bubble, color: primaryColor,size: 35)),

                onTap: () {

                },
            ),
        ],
    );
  }
}
