import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/login.dart';
import 'package:foodieapp/vendors/screens/HomePage.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';

void main() {
  runApp(MaterialApp(
      title: "Vendor",
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: primaryColor,
      )
      ));
}
