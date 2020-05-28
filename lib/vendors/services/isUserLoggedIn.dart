import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodieapp/vendors/bottomNavigationBar.dart';
import 'package:foodieapp/vendors/screens/login.dart';

class IsUserLoggedIn extends StatefulWidget {
  @override
  _IsUserLoggedInState createState() => _IsUserLoggedInState();
}

class _IsUserLoggedInState extends State<IsUserLoggedIn> {
  FirebaseUser user = null;

  Future<void> getUserData() async {
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
    });
  }

  @override
  void initState() {
    getUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    if (firebaseAuth.currentUser() != null && user != null) {
      return BottomNavigationScreen();
    } else {
      return LoginScreen();
    }
  }
}
