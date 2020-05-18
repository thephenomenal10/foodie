import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/screens/HomePage.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:foodieapp/vendors/validation/validate.dart';

import 'constants/constants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

    GlobalKey<FormState> _formKey = new GlobalKey();
    TextEditingController _emailController = new TextEditingController();
    TextEditingController _passController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
              ),
              child: Center(
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(left: 0.0, top: 40.0,
                                    right: 210),
                                child: Text(
                                    'Log in',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'OpenSans',
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,

                                    ),
                                ),
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                decoration: kBoxDecorationStyle,
                                margin: EdgeInsets.only(top: 20, bottom: 5),
                                height: 60,
                                width: 330,
                                child: TextFormField(
                                    controller: _emailController,
                                    validator: validateEmail,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(15.0),
                                        hintText: 'Enter your email',
                                        hintStyle: kHintTextStyle,
                                    ),
                                ),
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                decoration: kBoxDecorationStyle,
                                margin: EdgeInsets.only(top: 20, bottom: 5),
                                height: 60,
                                width: 330,
                                child: TextFormField(
                                    controller: _passController,
                                    validator: validatePass,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(15.0),
                                        hintText: 'Enter your Password',
                                        hintStyle: kHintTextStyle,
                                    ),
                                    obscureText: true,
                                ),

                            ),

                            SizedBox(height: 30.0,),
                            RaisedButton(
                                elevation: 10,
                                onPressed: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 80.0,right: 80.0,top: 10.0,bottom: 10.0),
                                    child: Text('Log In',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                                ),
                                color: primaryColor,
                            ),
                            Container(
                                height: 60,
                                child: SingleChildScrollView(
                                    child: Row(
                                        children: <Widget>[
                                            Container(
                                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/2.2,right: 0.0,top: 10.0),
                                                child: Text("forgot ID ?",style: TextStyle(fontSize: 20,)),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(left:0.0,right: 0.0,top: 10.0),
                                                child: FlatButton(
                                                    onPressed: (){
                                                    },
                                                    child: Text("Send Request",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: secondaryColor,),)

                                                )
                                            )
                                        ],
                                    ),
                                )
                            ),
                        ],

                    ) ),
              ) ,
          ),
      );
  }
}
