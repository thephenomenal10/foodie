import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodieapp/vendors/bottomNavigationBar.dart';
import 'package:foodieapp/vendors/screens/createTiffenCentre.dart';
import 'package:foodieapp/vendors/screens/login.dart';
import 'package:foodieapp/vendors/screens/subPaymentScreen.dart';
import 'package:foodieapp/vendors/services/firebase_service.dart';
import 'package:foodieapp/vendors/widgets/dialogBox.dart';

class IsUserLoggedIn extends StatefulWidget {
  @override
  _IsUserLoggedInState createState() => _IsUserLoggedInState();
}

class _IsUserLoggedInState extends State<IsUserLoggedIn> {
  FirebaseUser user;
  Map<String, dynamic> centerData;
  String proofOfPayment;
  DateTime currentDate;
  DateTime endDate;
  bool exists = true;

  Future<void> getVendorData() async {
    currentDate = DateTime.now();
    user = await FirebaseAuth.instance.currentUser();
    centerData = (await Firestore.instance
            .collection('tiffen_service_details')
            .document(user.email)
            .get())
        .data;
    if (centerData != null) {
      endDate = DateTime.parse(centerData['SubscriptionEndDate']);
      proofOfPayment = centerData['Proof of Payment Photos'];
    }
    // if (user.phoneNumber == null) {
    //   try {
    //     await Firestore.instance
    //         .collection('tiffen_service_details')
    //         .document(user.email)
    //         .delete();
    //   } catch (error) {
    //     print(error);
    //   }
    //   try {
    //     await Firestore.instance
    //         .collection('vendor_collection/vendors/registered_vendors')
    //         .document(user.email)
    //         .delete();
    //   } catch (error) {
    //     print(error);
    //   }
    //   try {
    //     await user.delete();
    //   } catch (error) {
    //     print(error);
    //   }
    // }
    print('got data');
  }

  @override
  void initState() {
    currentDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return FutureBuilder(
      future: getVendorData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            ),
          );
        }
        if (user != null && user.isEmailVerified) {
          if (centerData == null) {
            print('center not set');
            return CreateTiffenCentre();
          } else if (proofOfPayment == null) {
            print('not subscribed');
            return PaymentScreen(
              vendorEmail: user.email,
            );
          } else if (endDate.difference(currentDate).isNegative) {
            print('subscription over');
            return PaymentScreen(
              isRenewal: true,
            );
          }
          print('user exists');
          return BottomNavigationScreen();
        } else {
          try {
            FirebaseAuth.instance.signOut();
          } catch (error) {}
          print('no user');
          return LoginScreen();
        }
      },
    );
  }
}
