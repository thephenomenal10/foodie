import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/services/isUserLoggedIn.dart';


/*
splash screen
*/

class SplashScreen extends StatefulWidget {
    @override
    _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    @override
    void initState() {
        super.initState();
        // splashscreen duration
        Future.delayed(Duration(seconds: 3), () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => IsUserLoggedIn()));
        });
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Splash.png"),
                    fit: BoxFit.cover,
                ),
            ),
        );
    }
}