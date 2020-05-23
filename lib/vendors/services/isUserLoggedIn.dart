import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodieapp/vendors/screens/HomePage.dart';
import 'package:foodieapp/vendors/screens/login.dart';

Future<Widget> isUserLoggedIn () async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    if(await firebaseAuth.currentUser() != null){
        return Home();
    }
    else{
        return Login();
    }
}