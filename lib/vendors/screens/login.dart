import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/screens/register.dart';
import 'package:foodieapp/vendors/services/firebase_service.dart';
import 'package:foodieapp/vendors/validation/validate.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuthentication firebaseAuthentication = new FirebaseAuthentication();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey();

  bool _rememberMe = false;

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: TextFormField(
                  controller: emailController,
                  validator: validateEmail,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    fillColor: Color(0xFF00B712),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                    ),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: TextFormField(
                  controller: passController,
                  validator: validatePass,
                  obscureText: true,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    fillColor: Color(0xFF00B712),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        child: Text(
          'Forgot Password?',
          textScaleFactor: 0.7,
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            textScaleFactor: 0.9,
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn(height) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: height * 0.03),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          return signInMe();
        }, 
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          textScaleFactor: 1.5,
          style: TextStyle(
            color: myGreen,
            letterSpacing: 1.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          textScaleFactor: 1.1,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          textScaleFactor: 0.9,
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow(width) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/facebook.jpg',
            ),
          ),
          SizedBox(
            width: width * 0.15,
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterScreen(),
        ),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Form(
                key: _formKey,
                  child: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF5AFF15),
                  Color(0xFF5AFF15),
                  Color(0xFF00B712),
                  Color(0xFF00B712),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF5AFF15),
                              Color(0xFF5AFF15),
                              Color(0xFF00B712),
                              Color(0xFF00B712),
                            ],
                            stops: [0.1, 0.4, 0.7, 0.9],
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.3),
                                //offset: Offset(0.0, 8.0),
                                blurRadius: 8.0)
                          ]),
                    ),
                    Container(
                      height: double.infinity,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.1,
                          vertical: height * 0.05,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Sign In',
                              textScaleFactor: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            _buildEmailTF(),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            _buildPasswordTF(),
                            _buildForgotPasswordBtn(),
                            _buildRememberMeCheckbox(),
                            _buildLoginBtn(height),
                            _buildSignInWithText(),
                            _buildSocialBtnRow(width),
                            _buildSignupBtn(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  signInMe() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      firebaseAuthentication.signIn(context, emailController, passController);
      
    }
  }
}
