import 'package:flutter/material.dart';

Widget tiffenInfo({BuildContext context, String data, String title}) {
  return ExpansionTile(
    title: new Text(title,
        style: new TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.start),
    children: [
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 16.0), child: new Text(data)),
            ],
          ),
          SizedBox(
            height: 20.0,
          )
        ],
      ),
    ],
  );
}
