import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:foodieapp/vendors/validation/validate.dart';
import './register.dart';
import 'package:foodieapp/vendors/services/firebase_service.dart';
import '../widgets/isLoading.dart' as global;

class Login extends StatefulWidget {
    @override
    _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

    FirebaseAuthentication _firebaseAuthentication = new FirebaseAuthentication();

    GlobalKey<FormState> _formKey = new GlobalKey();
    TextEditingController _emailController = new TextEditingController();
    TextEditingController _passController = new TextEditingController();


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: global.isSignUpLoading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                            BoxShadow(
                                                color: Colors.black.withOpacity(.3),
                                                offset: Offset(0.0, 8.0),
                                                blurRadius: 8.0,
                                            ),
                                        ],
                                    ),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                child: Text(
                                                    "Email",
                                                    textScaleFactor: 1.05,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        letterSpacing: 1.25,
                                                    ),
                                                ),
                                            ),
                                            TextFormField(
                                                controller: _emailController,
                                                validator:  validateEmail,
                                                decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(12.0),
                                                        ),
                                                        borderSide: BorderSide(
                                                            width: 2,
                                                            color: primaryColor,
                                                        ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                        borderSide: BorderSide(color: Colors.green),
                                                    ),

                                                ),
                                                obscureText: false,
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                child: Text(
                                                    "Password",
                                                    textScaleFactor: 1.05,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        letterSpacing: 1.25,
                                                    ),
                                                ),
                                            ),
                                            TextFormField(
                                                controller: _passController,
                                                validator:  validatePass,
                                                decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(12.0),
                                                        ),
                                                        borderSide: BorderSide(
                                                            width: 2,
                                                            color: primaryColor,
                                                        ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                        borderSide: BorderSide(color: Colors.green),
                                                    ),
                                                ),
                                                obscureText: true,
                                            ),

                                            InkWell(
                                                onTap: ()
                                                {
                                                    signMeUp();
                                                },
                                                child: Container(
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 3,
                                                    ),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context).primaryColor,
                                                        borderRadius: BorderRadius.circular(6.0),
                                                        boxShadow: [
                                                            BoxShadow(
                                                                color: Colors.black.withOpacity(.3),
                                                                offset: Offset(0.0, 4.0),
                                                                blurRadius: 4.0,
                                                            ),
                                                        ],
                                                    ),
                                                    child: Center(
                                                        child: Padding(
                                                            padding: EdgeInsets.symmetric(vertical: 10),
                                                            child: Text(
                                                                'Login',
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold,
                                                                    letterSpacing: 1.5,
                                                                ),
                                                            ),
                                                        ),
                                                    ),
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                                FlatButton(
                                    onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => Register()));
                                    },
                                    child: Text(
                                        "Don't have an account ? Login.",
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                        ),
                                    ),
                                )
                            ],
                        ),
                    ),
                ),
            ),
        );
    }

    void signMeUp() {

        if(_formKey.currentState.validate()) {
            _formKey.currentState.save();

            _firebaseAuthentication.signIn(context, _emailController, _passController);

        }
    }
}
