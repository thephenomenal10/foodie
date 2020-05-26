import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodieapp/vendors/constants/constants.dart';

class DialogBox {
  information(BuildContext context, String title, String desc) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              title,
              style: TextStyle(
                  color: myGreen, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  return Navigator.pop(context);
                },
                child: FaIcon(
                  FontAwesomeIcons.checkCircle,
                  color: myGreen,
                ),
              ),
            ],
          );
        });
  }
}