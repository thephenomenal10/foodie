import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';

Future<dynamic> alertDialog(BuildContext context, String message, route) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(message)),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 70),
                  child: Center(
                    child: RaisedButton(
                      color: primaryColor,
                      child: Text(
                        "ok",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => route));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
