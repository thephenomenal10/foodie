import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodieapp/vendors/services/databaseService.dart';
import 'package:foodieapp/vendors/widgets/dialogBox.dart';
import 'package:foodieapp/vendors/screens/verify_email_screen.dart';

/*
OTP verification screen
*/

String verificationId;
int forceResendingToken;

class VerifyPhoneScreen extends StatelessWidget {
  final Map<String, String> accountInfo;
  VerifyPhoneScreen(this.accountInfo);

//   @override
//   _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
// }

// class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {

  @override
  Widget build(BuildContext context) {
    _verifyPhoneNumber(context);
    return Scaffold(
      body: Column(
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
          VerifyPhoneNumber(accountInfo),
          // return Container(
          //   padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       Text(
          //         "Enter Verification Code",
          //         textScaleFactor: 1.1,
          //         style: TextStyle(
          //           color: Colors.black87,
          //           letterSpacing: 1,
          //           fontWeight: FontWeight.w800,
          //         ),
          //       ),
          //       SizedBox(
          //         height: 15,
          //       ),
          //       Text("",
          //         // "Enter the 6-digit verification code sent to\n" +
          //             // widget.accountInfo['phone'],
          //         textScaleFactor: 0.9,
          //         style: TextStyle(
          //           color: Colors.black54,
          //           letterSpacing: 1.1,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //       SizedBox(
          //         height: 20,
          //       ),
          //       Form(
          //         // key: _formKey,
          //         child: TextFormField(
          //           // controller: otpController,
          //           validator: (String val) {
          //             if (val.length < 6) {
          //               return "Enter 6-digit code";
          //             }
          //             return null;
          //           },
          //         ),
          //       ),
          //       SizedBox(
          //         height: 25,
          //       ),
          //       Align(
          //         alignment: Alignment.center,
          //         child: FloatingActionButton.extended(
          //           label: Text(
          //             'CONFIRM',
          //             textScaleFactor: 1.2,
          //             style: TextStyle(
          //               fontWeight: FontWeight.w800,
          //               letterSpacing: 1.5,
          //             ),
          //           ),
          //           backgroundColor: Theme.of(context).primaryColor,
          //           onPressed: () {
          //             // verifyOTP();
          //           },
          //         ),
          //       ),
          //       SizedBox(
          //         height: 25,
          //       ),
          //     ],
          //   ),
          // );
        ],
      ),
    );
  }

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      forceResendingToken = forceCodeResend;
      verificationId = verId;
    };
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: accountInfo['phone'],
        codeAutoRetrievalTimeout: null,
        codeSent: smsOTPSent,
        timeout: const Duration(seconds: 120),
        verificationCompleted: null,
        verificationFailed: (AuthException exception) {
          print("verificationFailed: ${exception.message}");
          DialogBox().information(context, "Error", exception.message);
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
}

class VerifyPhoneNumber extends StatefulWidget {
  final Map<String, String> accountInfo;
  VerifyPhoneNumber(this.accountInfo);
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
        try {
          setState(() {
            _isLoading = true;
          });
          final emailResult = await FirebaseAuth.instance
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
          setState(() {
            _isLoading = false;
          });
          print(e.message.toString());
          DialogBox().information(context, "Error", e.message);
        } catch (e) {
          _isLoading = false;
          print(e.toString());
          DialogBox().information(context, "Error", e);
        }
      } on PlatformException catch (e) {
        _isLoading = false;
        print(e.message);
        DialogBox().information(context, "Error", e.message);
      } catch (e) {
        _isLoading = false;
        print("VerifyOTP: " + e.toString());
        DialogBox().information(
          context,
          "Error",
          e.toString(),
        );
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
                Row(
                  children: <Widget>[
                    Text('Did not get OTP?')
                  ],
                )
              ],
            ),
          );
  }
}
