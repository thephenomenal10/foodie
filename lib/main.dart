import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/login_register.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';

void main() {
  runApp(MaterialApp(
      title: "Vendor",
      home: Login(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: primaryColor,
      )
      ));
}
