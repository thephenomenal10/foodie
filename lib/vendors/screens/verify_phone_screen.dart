import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodieapp/vendors/screens/verify_email_screen.dart';
import 'package:foodieapp/vendors/services/databaseService.dart';
import 'package:foodieapp/vendors/widgets/dialogBox.dart';

String verificationId;
int forceResendingToken;

class VerifyPhoneScreen extends StatefulWidget {
  final Map<String, String> accountInfo;
  VerifyPhoneScreen(this.accountInfo);

  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  bool _isLoading = false;

  Future<void> _verifyPhoneNumber(String phone) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      forceResendingToken = forceCodeResend;
      verificationId = verId;
    };
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        codeAutoRetrievalTimeout: (message) {
          print(message);
        },
        codeSent: smsOTPSent,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (AuthCredential credential) async {
          AuthResult emailResult;
          try {
            setState(() {
              _isLoading = true;
            });
            emailResult = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: widget.accountInfo['email'],
                    password: widget.accountInfo['password']);
            final authResult =
                await emailResult.user.linkWithCredential(credential);
            await authResult.user.sendEmailVerification();
            print(authResult.toString());
            Map<String, String> userData = {
              "Email": widget.accountInfo['email'],
              "Name": widget.accountInfo['name'],
              "Phone": widget.accountInfo['phone'],
              "userType": "vendor",
            };
            await DatabaseService()
                .addUserData(userData, widget.accountInfo['email']);
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => VerifyEmailScreen(authResult.user),
              ),
            );
            DialogBox().information(
              context,
              "Success",
              "OTP Verification successfull",
            );
          } on PlatformException catch (e) {
            await emailResult.user.delete();
            setState(() {
              _isLoading = false;
            });
            print(e.message.toString());
            await DialogBox().information(context, "Failed", e.message);
            Navigator.of(context).pop();
          } catch (e) {
            await emailResult.user.delete();
            setState(() {
              _isLoading = false;
            });
            print(e.toString());
            await DialogBox()
                .information(context, "Error", 'Something went wrong!');
            Navigator.of(context).pop();
          }
        },
        verificationFailed: (AuthException exception) async {
          print("verificationFailed: ${exception.message}");
          await DialogBox().information(context, "Error", exception.message);
          Navigator.of(context).pop();
        },
        forceResendingToken: forceResendingToken,
      );
    } on PlatformException catch (e) {
      print(e.message);
      DialogBox().information(context, "Error", e.message);
    } catch (e) {
      print(e.toString());
      DialogBox().information(context, "Error", e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber(widget.accountInfo['phone']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
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
              child: Text(
                "OTP VERIFICATION",
                textScaleFactor: 1.4,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  )
                : VerifyPhoneNumber(_verifyPhoneNumber, widget.accountInfo),
          ],
        ),
      ),
    );
  }
}

class VerifyPhoneNumber extends StatefulWidget {
  final Function verifyPhoneNumber;
  final Map<String, String> accountInfo;
  VerifyPhoneNumber(this.verifyPhoneNumber, this.accountInfo);
  @override
  _VerifyPhoneNumberState createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey();
  bool _isLoading = false;

  Future<void> _verifyOTP() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId,
          smsCode: otpController.text.trim(),
        );
        AuthResult emailResult;
        try {
          setState(() {
            _isLoading = true;
          });
          emailResult = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: widget.accountInfo['email'],
                  password: widget.accountInfo['password']);
          final authResult =
              await emailResult.user.linkWithCredential(credential);
          await authResult.user.sendEmailVerification();
          print(authResult.toString());
          Map<String, String> userData = {
            "Email": widget.accountInfo['email'],
            "Name": widget.accountInfo['name'],
            "Phone": widget.accountInfo['phone'],
            "userType": "vendor",
          };
          await DatabaseService()
              .addUserData(userData, widget.accountInfo['email']);
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => VerifyEmailScreen(authResult.user),
            ),
          );
          DialogBox().information(
            context,
            "Success",
            "OTP Verification successfull",
          );
        } on PlatformException catch (e) {
          await emailResult.user.delete();
          setState(() {
            _isLoading = false;
          });
          print(e.message.toString());
          await DialogBox().information(context, "Failed", e.message);
          Navigator.of(context).pop();
        } catch (e) {
          await emailResult.user.delete();
          setState(() {
            _isLoading = false;
          });
          print(e.toString());
          await DialogBox()
              .information(context, "Error", 'Something went wrong!');
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(e.message);
        await DialogBox().information(context, "Error", e.message);
        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print("VerifyOTP: " + e.toString());
        await DialogBox()
            .information(context, "Error", 'Something went wrong!');
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Enter Verification Code",
                  textScaleFactor: 1.1,
                  style: TextStyle(
                    color: Colors.black87,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Enter the 6-digit verification code sent to\n" +
                      widget.accountInfo['phone'],
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    color: Colors.black54,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: otpController,
                    validator: (String val) {
                      if (val.length < 6) {
                        return "Enter 6-digit code";
                      }
                      return null;
                    },
                  ),
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
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () async {
                      await _verifyOTP();
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SetTimer(widget.accountInfo['phone'], widget.verifyPhoneNumber),
              ],
            ),
          );
  }
}

class SetTimer extends StatefulWidget {
  final phone;
  final Function verifyPhoneNumber;
  SetTimer(this.phone, this.verifyPhoneNumber);
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<SetTimer> {
  bool _isComplete = false;
  int seconds = 120;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        !_isComplete
            ? Center(
                child: CircularCountDownTimer(
                  isReverse: true,
                  width: MediaQuery.of(context).size.width * 0.33,
                  height: MediaQuery.of(context).size.width * 0.33,
                  duration: seconds,
                  strokeWidth: 2,
                  fillColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onComplete: () {
                    setState(() {
                      _isComplete = true;
                    });
                  },
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Did not get OTP?'),
                  FlatButton(
                    onPressed: () async {
                      await widget.verifyPhoneNumber(context, widget.phone);
                      setState(() {
                        _isComplete = false;
                        seconds = 120;
                      });
                    },
                    child: Text(
                      'Resend',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
