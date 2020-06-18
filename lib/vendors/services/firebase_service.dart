import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/screens/login.dart';
import 'package:foodieapp/vendors/screens/otpVerificationScreen.dart';
import 'package:foodieapp/vendors/services/local_notifications.dart';
import 'package:foodieapp/vendors/widgets/dialogBox.dart';
import 'package:foodieapp/vendors/screens/createTiffenCentre.dart';
import 'package:foodieapp/vendors/bottomNavigationBar.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;
var currentUserUid;

class FirebaseAuthentication {
  void signIn(context, emailController, passwordController) async {
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
        Navigator.pushReplacement(context,
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
              onPressed: () => Navigator.of(context).pop(),
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
      return (e.message);
    }
  }

  Future<void> signUp(
      context, emailController, passwordController, phoneControlloer) async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .catchError((e) {
        print(e.toString());
      });
      await result.user.sendEmailVerification();
      currentUserUid = result.user.uid;
      print(currentUserUid.toString());
      print(result);

      await verifyPhone(context, phoneControlloer);
    } catch (e) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Alert'),
          content: Text(
            e.toString(),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
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
      return (e);
    }
  }

//PHONE NO VERIFICATION .....///////////////////...

  Future<void> verifyPhone(context, String phoneNumber) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    TextEditingController _codeController = new TextEditingController();
    user = await FirebaseAuth.instance.currentUser();

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: null,
        // (AuthCredential credential) async{
        //   Navigator.of(context).pop();

        //   AuthResult result = await _auth.signInWithCredential(credential);

        //   FirebaseUser user = result.user;

        //   if(user != null){
        //     Navigator.push(context, MaterialPageRoute(
        //       builder: (context) => HomeScreen()
        //     ));
        //   }else{
        //     print("Error");
        //   }

        //   //This callback would gets called when verification is done auto maticlly
        // },
        verificationFailed: (AuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
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
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);
                        await user
                            .linkWithCredential(credential)
                            .then((authResult) {
                          user = authResult.user;
                          if (user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateTiffenCentre(),
                              ),
                            );
                          } else {
                            print("Error");
                          }
                        }).catchError((e) {
                          print(e.message.toString());
                        });
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
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
        // (AuthCredential credential) async{
        //   Navigator.of(context).pop();

        //   AuthResult result = await _auth.signInWithCredential(credential);

        //   FirebaseUser user = result.user;

        //   if(user != null){
        //     Navigator.push(context, MaterialPageRoute(
        //       builder: (context) => HomeScreen()
        //     ));
        //   }else{
        //     print("Error");
        //   }

        //   //This callback would gets called when verification is done auto maticlly
        // },
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
