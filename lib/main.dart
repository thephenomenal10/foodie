import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import './vendors/services/isUserLoggedIn.dart';

Future<void> main() async{
    WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: "Vendor",
      home: await isUserLoggedIn(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: primaryColor,
      )));
}
