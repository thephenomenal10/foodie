import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:foodieapp/vendors/validation/validate.dart';
import 'package:foodieapp/vendors/widgets/dialogBox.dart';




class ForgotPass extends StatefulWidget {
  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {

    TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  ListView(
          children: <Widget>[
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle,
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/4, bottom: 5),
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
                    SizedBox(height: 30.0,),
                    RaisedButton(
                        elevation: 10,
                        onPressed: () {
                            DialogBox().information(
                                context, "Success", "Your have registered successfully");
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(left: 80.0,right: 80.0,top: 10.0,bottom: 10.0),
                            child: Text('Submit',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                        color: primaryColor,
                    ),
                ],
              ),

      ),
          ],
        ),
    );
  }
}
