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
import 'package:foodieapp/vendors/screens/subPaymentScreen.dart';
import 'package:foodieapp/vendors/widgets/globalVariable.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;
var currentUserUid;
DatabaseService _databaseService = new DatabaseService();

class FirebaseAuthentication {
  Future<void> signIn(context, emailController, passwordController) async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      print(result.user.toString() +
          "  check one" +
          " ${result.user.isEmailVerified}");
      if (auth.currentUser() != null && result.user.isEmailVerified) {
        await LocalNotifications.storeFCMToken(result.user.email);
        final docSnap = await Firestore.instance
            .collection('tiffen_service_details')
            .document(result.user.email)
            .get();
        if (docSnap.data == null) {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CreateTiffenCentre(),
            ),
          );
          await DialogBox()
              .information(context, "Alert", "Create your tiffin center!");
        } else if (docSnap.data['Proof of Payment'] == null) {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                vendorEmail: result.user.email,
              ),
            ),
          );
          DialogBox().information(
              context, "Alert", "Subscription pending!\nSubscribe to us.");
        } else {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigationScreen(),
            ),
          );
          DialogBox()
              .information(context, "Success", "Your have Login successfully");
        }
      }
      DialogBox().information(context, "Alert", "Please verify your account!");
    } catch (e) {
      print(e.toString());
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
    userName,
    Map<String, String> userInfo,
  ) async {
    // AuthResult result;
    try {
      // TextEditingController _codeController = new TextEditingController();
      int resendingCode;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneControlloer.trim(),
        timeout: Duration(seconds: 60),
        verificationCompleted: null,
        verificationFailed: (AuthException exception) {
          print(exception.message.toString() + "auth exception");
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Alert'),
              content: Text('Something went wrong, try using other number'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('ok'),
                ),
              ],
            ),
          );
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          resendingCode = forceResendingToken;
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return ShowDialog(
                context: context,
                email: emailController.text,
                password: passwordController.text,
                info: userInfo,
                verificationId: verificationId,
              );
              // return AlertDialog(
              //   title: Text("Enter the 6-digit code "),
              //   content: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     children: <Widget>[
              //       TextField(
              //         controller: _codeController,
              //       ),
              //     ],
              //   ),
              //   actions: <Widget>[
              //     FlatButton(
              //       child: Text("Confirm"),
              //       textColor: Colors.white,
              //       color: myGreen,
              //       onPressed: () async {
              //         AuthCredential credential;
              //         print("check one");
              //         final code = _codeController.text.trim();
              //         credential = PhoneAuthProvider.getCredential(
              //             verificationId: verificationId, smsCode: code);
              //         print("check two");
              //         AuthResult authResult;
              //         try {
              //           authResult = await FirebaseAuth.instance
              //               .createUserWithEmailAndPassword(
              //                   email: emailController.text,
              //                   password: passwordController.text);
              //           print('check three');
              //           result = await authResult.user
              //               .linkWithCredential(credential);
              //           user = result.user;
              //           if (user != null) {
              //             Navigator.pushReplacement(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => CreateTiffenCentre(),
              //               ),
              //             );
              //           }
              //           print('chech four');
              //           await result.user.sendEmailVerification();
              //           print('chech five');
              //           await _databaseService.addUserData(
              //               userInfo, emailController.text);
              //           print('chech six');
              //           await LocalNotifications.storeFCMToken(
              //               emailController.text.trim());
              //           print('chech seven');
              //         } on PlatformException catch (error) {
              //           await authResult.user.delete();
              //           Navigator.of(context).pop();
              //           showDialog(
              //             context: context,
              //             builder: (context) => AlertDialog(
              //               content: Text(error.message),
              //               actions: <Widget>[
              //                 FlatButton(
              //                   onPressed: () {
              //                     Navigator.of(context).pop();
              //                   },
              //                   child: Text('ok'),
              //                 ),
              //               ],
              //             ),
              //           );
              //         }
              //       },
              //     ),
              //   ],
              // );
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
                    AuthCredential credential = PhoneAuthProvider.getCredential(
                        verificationId: verificationId, smsCode: code);
                    user
                        .updatePhoneNumberCredential(credential)
                        .then((authResult) {
                      if (user != null) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationScreen(),
                          ),
                        );
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
          },
        );
      },
      codeAutoRetrievalTimeout: null,
    );
  }
}

class ShowDialog extends StatefulWidget {
  final context;
  final email;
  final password;
  final verificationId;
  final Map<String, String> info;
  ShowDialog(
      {this.context,
      this.email,
      this.password,
      this.verificationId,
      this.info});
  @override
  _ShowDialogState createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  bool _isLoading = false;
  final _codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? AlertDialog(
            title: Text('Please wait...'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          )
        : AlertDialog(
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
                  setState(() {
                    _isLoading = true;
                  });
                  AuthCredential credential;
                  print("check one");
                  final code = _codeController.text.trim();
                  credential = PhoneAuthProvider.getCredential(
                      verificationId: widget.verificationId, smsCode: code);
                  print("check two");
                  AuthResult authResult;
                  try {
                    authResult = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: widget.email, password: widget.password);
                    print(authResult.toString());
                    print('check three');
                    AuthResult result =
                        await authResult.user.linkWithCredential(credential);
                    user = result.user;
                    print('chech four');
                    await result.user.sendEmailVerification();
                    print('chech five');
                    await _databaseService.addUserData(
                        widget.info, widget.email);
                    print('chech six');
                    // await LocalNotifications.storeFCMToken(widget.email);
                    // print('chech seven');
                  } on PlatformException catch (error) {
                    if (authResult != null) {
                      await authResult.user.delete();
                    }
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
                  } catch (error) {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text("something went wrong!"),
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
                  setState(() {
                    _isLoading = false;
                  });
                  if (user != null) {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Message'),
                        content: Text(
                            "A verification link is sent to your Email, Please verify"),
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
                    Navigator.of(context).pop();
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  }
                },
              ),
            ],
          );
  }
}
