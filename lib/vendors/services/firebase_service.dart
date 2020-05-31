import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/screens/login.dart';
import 'package:foodieapp/vendors/screens/otpVerificationScreen.dart';
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

  void signUp(
      context, emailController, passwordController, phoneControlloer) async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .catchError((e) {
        print(e);
      });
      await result.user.sendEmailVerification();
      currentUserUid = result.user.uid;
      print(currentUserUid.toString());
      print(result);
    } catch (e) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Alert'),
          content: Text(
            e.meesage,
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
    verifyPhone(context, phoneControlloer);
  }

//PHONE NO VERIFICATION .....///////////////////...

  Future<bool> verifyPhone(context, String phoneNumber) {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: null,
        verificationFailed: (AuthException exception) {

          user.delete().then((value) {
            print("successfully user deleted.....................................");
          });
          print(exception.message.toString());
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          // TextEditingController _codeController = new TextEditingController();
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPVerifyScreen(
                      verificationId: verificationId, phone: phoneNumber)));
        },
        codeAutoRetrievalTimeout: null);
  }

  Future resetPassword(String email) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> signOut(context) async {
    return await auth.signOut().then((value) => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }
}
