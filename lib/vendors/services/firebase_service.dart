import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/screens/HomePage.dart';
import 'package:foodieapp/vendors/screens/login.dart';


FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;
class FirebaseAuthentication {

    void signIn(BuildContext context, emailController, passwordController) async{
        try {
            AuthResult result = await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: emailController.text,
                password: passwordController.text)
                .catchError((e) {
                print(e);
            });
            print(result.user);
            if(auth.currentUser() !=null){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
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
                            onPressed: () =>
                                Navigator.of(context).pop(),
                            child: Text(
                                'OK',
                                style: TextStyle(
                                    color:
                                    Theme.of(context).primaryColor,
                                ),
                            ),
                        )
                    ],
                ),
            );
            return (e.message);
        }
    }
    int count = 1;
    void signUp(BuildContext context, emailController, passwordController) async {

        try {
            AuthResult result = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(email: emailController.text,
                password: passwordController.text)
                .catchError((e) {
                print(e);
            });
            print(result);
            if(user.isEmailVerified){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
            }

        } catch (e) {
            showDialog(
                context: context,
                child: AlertDialog(
                    title: Text('Alert'),
                    content: Text(
                        'The email already in use',
                    ),
                    actions: <Widget>[
                        FlatButton(
                            onPressed: () =>
                                Navigator.of(context).pop(),
                            child: Text(
                                'OK',
                                style: TextStyle(
                                    color:
                                    Theme.of(context).primaryColor,
                                ),
                            ),
                        )
                    ],
                ),
            );
            return (e.message);
        }
    }


    Future resetPassword(String email) async {
        FirebaseAuth _auth = FirebaseAuth.instance;
        try {
            return await _auth.sendPasswordResetEmail(email: email);
        } catch (e) {
            print(e.message);
        }
    }


    Future<void > signOut(context) async{
         Navigator.pop(context);
         return await auth.signOut().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())));

    }
}


