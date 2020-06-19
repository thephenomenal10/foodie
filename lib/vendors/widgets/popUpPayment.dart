import 'package:foodieapp/vendors/bottomNavigationBar.dart';
import 'package:foodieapp/vendors/constants/constants.dart';

import 'package:flutter/material.dart';

class PopUpPayment extends StatelessWidget {
  final isRenewal;
  PopUpPayment({this.isRenewal=false});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: height * 0.65,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/popup_payment.png",
                  width: width * 0.5,
                ),
                SizedBox(
                  height: height * 0.035,
                ),
                Text(
                  'Thank you for\nyour Subscription',
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.5,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3,
                    color: myGreen,
                  ),
                ),
                SizedBox(
                  height: height * 0.028,
                ),
                SizedBox(
                  height: height * 0.042,
                ),
                Container(
                  width: width * 0.65,
                  child: FloatingActionButton.extended(
                    elevation: 1,
                    label: Text(
                      'Go to Home page',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.1,
                      ),
                    ),
                    backgroundColor: myGreen,
                    onPressed: () {
                      if (!isRenewal) {
                        Navigator.of(context).pop();
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigationScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
