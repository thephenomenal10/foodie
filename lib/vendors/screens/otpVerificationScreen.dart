import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/screens/createTiffenCentre.dart';

/*
OTP verification screen
*/

class OTPVerifyScreen extends StatefulWidget {
  final String verificationId;
  final String phone;
  const OTPVerifyScreen({Key key, this.verificationId, this.phone})
      : super(key: key);

  @override
  _OTPVerifyScreenState createState() => _OTPVerifyScreenState();
}

class _OTPVerifyScreenState extends State<OTPVerifyScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;
  TextEditingController codeController = new TextEditingController();


  

  Future<void> getData() async {
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();

    setState(() {
      user = userData;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
                color: myGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                )),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "OTP VERIFICATION",
                textScaleFactor: 2,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Enter Verification Code",
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                    "Enter the 4-digit verification code sent to\n ${widget.phone}"),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: codeController,
                ),
                SizedBox(
                  height: 25,
                ),
                Align(
                  alignment: Alignment.center,
                  child: FloatingActionButton.extended(
                    label: Text(
                      'CONFIRM',
                      textScaleFactor: 1.2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    backgroundColor: myGreen,
                    onPressed: () async {
                      try {
                        final code = codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: widget.verificationId,
                                smsCode: code);

                        // AuthResult result = await auth.signInWithCredential(credential);
                        user.linkWithCredential(credential).then((authResult) {
                          print(authResult.toString());
                        });

                        // FirebaseUser user = result.user;

                        if (user != null) {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateTiffenCentre()));
                        } else {
                          print("Error");
                          user.delete().then((value) {
                              print("Successfully user deleted");
                          });
                        }
                      } catch (e) {

                          user.delete().then((value) {
                              print("Successfully user deleted");
                          });

                        print(e.message);
                      }
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
