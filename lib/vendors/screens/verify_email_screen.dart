import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodieapp/vendors/screens/createTiffenCentre.dart';
import 'package:foodieapp/vendors/services/databaseService.dart';
import 'package:foodieapp/vendors/widgets/dialogBox.dart';

/*
Email verification screen
*/

class VerifyEmailScreen extends StatefulWidget {
  // final Map<String, String> accountInfo;
  final FirebaseUser user;
  VerifyEmailScreen(this.user);
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isLoading = false;
  bool _isUserEmailVerified = false;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    Future(() async {
      _timer = Timer.periodic(
          Duration(
            seconds: 3,
          ), (timer) async {
        await FirebaseAuth.instance.currentUser()
          ..reload();
        var user = await FirebaseAuth.instance.currentUser();
        if (user.isEmailVerified) {
          setState(() {
            _isUserEmailVerified = user.isEmailVerified;
          });
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                left: 20,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "EMAIL VERIFICATION",
                  textScaleFactor: 1.4,
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Center(
                      child: _isUserEmailVerified
                          ? Column(
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: "☑ ",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "VERIFIED",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black45,
                                          letterSpacing: 1.1,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RaisedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await DatabaseService.storeFCMToken(
                                        widget.user.email);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateTiffenCentre(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'PROCEED',
                                    textScaleFactor: 1.1,
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0.9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                )
                              ],
                            )
                          : Column(
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: "✉ ",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            "Email has been sent.\nWaiting for confirmation..",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black45,
                                          letterSpacing: 1.1,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Did not get Email?'),
                                    FlatButton(
                                      onPressed: () async {
                                        await widget.user
                                            .sendEmailVerification();
                                        await DialogBox().information(
                                          context,
                                          'Success',
                                          'A verification email is sent, please verify',
                                        );
                                      },
                                      child: Text(
                                        'Resend',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
