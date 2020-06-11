import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';

Widget tiffenContainer({BuildContext context, String key, String value}) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text(
          key,
          style: new TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.w400,
              fontSize: 15.0),
        ),
        new Text(
          value,
          style: new TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 15.0),
        )
      ],
    ),
  );
}
