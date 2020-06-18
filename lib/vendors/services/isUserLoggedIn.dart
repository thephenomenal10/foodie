import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodieapp/vendors/bottomNavigationBar.dart';
import 'package:foodieapp/vendors/screens/login.dart';
import 'package:foodieapp/vendors/screens/subPaymentScreen.dart';

class IsUserLoggedIn extends StatefulWidget {
  @override
  _IsUserLoggedInState createState() => _IsUserLoggedInState();
}

class _IsUserLoggedInState extends State<IsUserLoggedIn> {
  FirebaseUser user;
  Map<String, dynamic> centerData;
  Map<String, dynamic> vendorData;
  String proofOfPayment;
  DateTime currentDate;
  DateTime endDate;
  bool exists = true;

  Future<void> getVendorData() async {
    user = await FirebaseAuth.instance.currentUser();
    centerData = (await Firestore.instance
            .collection('tiffen_service_details')
            .document(user.email)
            .get())
        .data;
    vendorData = (await Firestore.instance
            .collection("vendor_collection/vendors/registered_vendors")
            .document(user.email)
            .get())
        .data;
    if (centerData != null) {
      endDate = DateTime.parse(centerData['SubscriptionEndDate']);
      proofOfPayment = centerData['Proof of Payment Photos'];
    }
    if (user.phoneNumber == null || endDate == null || proofOfPayment == null) {
      try {
        await Firestore.instance
            .collection('tiffen_service_details')
            .document(user.email)
            .delete();
      } catch (error) {
        print(error);
      }
      try {
        await Firestore.instance
            .collection('vendor_collection/vendors/registered_vendors')
            .document(user.email)
            .delete();
      } catch (error) {
        print(error);
      }
      try {
        await user.delete();
      } catch (error) {
        print(error);
      }
    }
    print('got data');
  }

  @override
  void initState() {
    currentDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return FutureBuilder(
      future: getVendorData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
        }
        if (firebaseAuth.currentUser() != null && user != null) {
          if (user.phoneNumber == null ||
              endDate == null ||
              proofOfPayment == null) {
            print('no data but exists');
            return LoginScreen();
          }
          if (endDate.difference(currentDate).isNegative) {
            print('subscription over');
            return PaymentScreen(
              isRenewal: true,
            );
          }
          print('user exists');
          return BottomNavigationScreen();
        } else {
          print('no user');
          return LoginScreen();
        }
      },
    );
  }
}
