import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/screens/splash_screen.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';

Future<void> main() async{
    WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: "Vendor",
      home:  SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          hintColor: Color(0xFF00B712),
        fontFamily: 'Roboto',
        primaryColor: primaryColor,
      )));
}
