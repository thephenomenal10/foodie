import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/screens/login.dart';
// import 'package:foodieapp/vendors/screens/otpVerificationScreen.dart';
import 'package:foodieapp/vendors/services/databaseService.dart';
import 'package:foodieapp/vendors/services/local_notifications.dart';
import 'package:foodieapp/vendors/widgets/dialogBox.dart';
import 'package:foodieapp/vendors/screens/createTiffenCentre.dart';
import 'package:foodieapp/vendors/bottomNavigationBar.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;
var currentUserUid;
DatabaseService _databaseService = new DatabaseService();

class FirebaseAuthentication {
  Future<void> signIn(context, emailController, passwordController) async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .catchError((e) {
        print(e);
      });
      print(result.user);
      if (auth.currentUser() != null) {
        await LocalNotifications.storeFCMToken(emailController.text.trim());
        await Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavigationScreen()));
        DialogBox()
            .information(context, "Success", "Your have Login successfully");
      }
    } catch (e) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Alert'),
          content: Text(
            'Your email id or password is wrong',
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          ],
        ),
      );
      return e;
    }
  }

  Future<void> signUp(
    context,
    emailController,
    passwordController,
    phoneControlloer,
    Map<String, String> userInfo,
  ) async {
    AuthResult result;
    try {
      TextEditingController _codeController = new TextEditingController();
      int resendingCode;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneControlloer.trim(),
        timeout: Duration(seconds: 60),
        verificationCompleted: null,
        verificationFailed: (AuthException exception) {
          print(exception.toString() + "auth exception");
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          resendingCode = forceResendingToken;
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Enter the 6-digit code "),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Confirm"),
                    textColor: Colors.white,
                    color: myGreen,
                    onPressed: () async {
                      AuthCredential credential;
                      print("check one");
                      final code = _codeController.text.trim();
                      credential = PhoneAuthProvider.getCredential(
                          verificationId: verificationId, smsCode: code);
                      print("check two");
                      AuthResult authResult;
                      try {
                        authResult = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                        print('check three');
                        result = await authResult.user.linkWithCredential(credential);
                        print('chech four');
                        await result.user.sendEmailVerification();
                        print('chech five');
                        await _databaseService.addUserData(
                            userInfo, emailController.text);
                        print('chech six');
                        await LocalNotifications.storeFCMToken(
                            emailController.text.trim());
                        print('chech seven');
                        user = result.user;
                      } on PlatformException catch (error) {
                        await authResult.user.delete();
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text(error.message),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('ok'),
                              ),
                            ],
                          ),
                        );
                      }
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTiffenCentre(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        codeAutoRetrievalTimeout: null,
        forceResendingToken: resendingCode,
      );
    } catch (error) {
      throw error;
    }
  }

  Future resetPassword(String email) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.message.toString());
    }
  }

  Future<void> signOut(context) async {
    user = await FirebaseAuth.instance.currentUser();
    final ref = Firestore.instance
        .collection('vendor_collection/vendors/registered_vendors')
        .document(user.email);
    var tokens = [...(await ref.get()).data['fcmTokens']];
    final token = await FirebaseMessaging().getToken();
    tokens.remove(token);
    await ref.updateData({'fcmTokens': tokens});
    return await auth.signOut().then((value) => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }

  Future<void> updatePhoneNumber(context, String phoneNumber) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    TextEditingController _codeController = new TextEditingController();
    user = await FirebaseAuth.instance.currentUser();

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: null,
        verificationFailed: (AuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Enter the 6-digit code "),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: myGreen,
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);
                        user
                            .updatePhoneNumberCredential(credential)
                            .then((authResult) {
                          if (user != null) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BottomNavigationScreen()));
                          } else {
                            print("Error");
                          }
                        }).catchError((e) {
                          print(e.message);
                        });
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }
}
