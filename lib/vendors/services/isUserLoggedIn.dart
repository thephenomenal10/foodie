import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodieapp/vendors/bottomNavigationBar.dart';
import 'package:foodieapp/vendors/screens/login.dart';
import 'package:intl/intl.dart';

class IsUserLoggedIn extends StatefulWidget {
  @override
  _IsUserLoggedInState createState() => _IsUserLoggedInState();
}

class _IsUserLoggedInState extends State<IsUserLoggedIn> {
  FirebaseUser user;

  Future<void> getUserData() async {
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
    });
  }

  String startDate;
  String endDate;

  Future<void> getVendorData() async {
    final currentEmail = (await FirebaseAuth.instance.currentUser()).email;

    final data = await Firestore.instance
        .collection("tiffen_service_details")
        .document(currentEmail)
        .get();
    setState(() {
      startDate = data['SubscriptionStartDate'];
      endDate = data['SubscriptionEndDate'];
    });

    print(startDate);
    print(endDate);
  }

  @override
  void initState() {
    getUserData();
    getVendorData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    if (firebaseAuth.currentUser() != null && user != null) {
      if (user.phoneNumber == null || user.phoneNumber == '') {
        if(startDate.compareTo(endDate).isNegative){
          print("negative");

          return LoginScreen();
        }
        print(user.phoneNumber);
        print(user.email);
        user.delete().catchError((error) {});
        return LoginScreen();
      }
      print(user.phoneNumber);
      return BottomNavigationScreen();
    } else {
      return LoginScreen();
    }
  }
}
