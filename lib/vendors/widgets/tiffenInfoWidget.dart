import 'package:flutter/material.dart';

Widget tiffenInfo({BuildContext context, String data, String title}) {
  return ExpansionTile(
    title: new Text(title,
        style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        textAlign: TextAlign.start),
    trailing: Icon(
      Icons.arrow_drop_down,
      color: Colors.black,
    ),
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

Widget mealInfo({BuildContext context, title, desc, cost}) {
  return ExpansionTile(
    trailing: Icon(
      Icons.arrow_drop_down,
      color: Colors.black,
    ),
    title: new Text(title,
        style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        textAlign: TextAlign.start),
    children: [
      ListView.builder(
          shrinkWrap: true,
          itemCount: desc.length,
          itemBuilder: (context, int index) {
            return new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 16.0),
                      child: new Text(desc[index].toString()),
                    ),
                    // SizedBox(height:20.0),
                    Container(
                      // margin: EdgeInsets.only(right: 16.0),
                      child: new Text(cost[index].toString()),
                    ),
                    SizedBox(height: 20.0),
                  ],
                )
              ],
            );
          })
    ],
  );
}
