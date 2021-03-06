import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/screens/login.dart';
import 'package:foodieapp/vendors/screens/verify_phone_screen.dart';
import 'package:foodieapp/vendors/services/firebase_service.dart';
import 'package:foodieapp/vendors/validation/validate.dart';
import 'package:foodieapp/vendors/widgets/globalVariable.dart' as global;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FirebaseAuthentication firebaseAuthentication = new FirebaseAuthentication();

  //bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = new GlobalKey();

  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController confirmPassController = new TextEditingController();

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 5),
        Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: TextFormField(
                  controller: nameController,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Enter your name";
                    } else if (val.length > 20) {
                      return "Name is too long!";
                    }
                    return null;
                  },
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
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    hintText: 'Enter your name',
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

  Widget _buildPhoneTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone',
          style: kLabelStyle,
        ),
        SizedBox(height: 5),
        Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val.isEmpty) {
                    return "enter your phone number";
                  }
                  return null;
                },
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  prefixText: '+ 91 ',
                  prefixStyle: TextStyle(fontSize: 12),
                  fillColor: Color(0xFF00B712),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                  ),
                  hintText: 'Enter your phone',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 5),
        Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: TextFormField(
                controller: emailController,
                validator: validateEmail,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.emailAddress,
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
                ),
              ),
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
        SizedBox(height: 5),
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
                        Icons.lock_open,
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

  Widget _buildConfirmPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm password',
          style: kLabelStyle,
        ),
        SizedBox(height: 5),
        Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: TextFormField(
                  controller: confirmPassController,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "your password not matched";
                    }
                    return null;
                  },
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
                        Icons.lock_outline,
                        color: Colors.white,
                      ),
                    ),
                    hintText: 'Confirm your password',
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

  Widget _buildRegisterBtn(height) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: height * 0.03),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          return signMeUp();
        },
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'REGISTER',
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

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign In',
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

  // @override
  // void initState() {
  //   global.isLoading = false;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // body: global.isLoading == true
      //     ? Center(
      //         child: CircularProgressIndicator(
      //           valueColor: AlwaysStoppedAnimation<Color>(
      //             Theme.of(context).primaryColor,
      //           ),
      //           backgroundColor: Colors.transparent,
      //         ),
      //       )
      // :
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
                          vertical: height * 0.02,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Sign Up',
                              textScaleFactor: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            _buildNameTF(),
                            SizedBox(height: height * 0.005),
                            _buildPhoneTF(),
                            SizedBox(height: height * 0.005),
                            _buildEmailTF(),
                            SizedBox(height: height * 0.005),
                            _buildPasswordTF(),
                            SizedBox(height: height * 0.005),
                            _buildConfirmPasswordTF(),
                            _buildRegisterBtn(height),
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

  signMeUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // setState(() {
      //   global.isLoading = true;
      // });
      setState(() {
        global.phone = '+91' + phoneController.text.trim();
      });

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString("currentUserEmail", emailController.text);
      // await prefs.setString("currentUserName", emailController.text);
      final Map<String, String> accountInfo = {
        'email': emailController.text.trim(),
        'password': passController.text.trim(),
        'name': nameController.text.trim(),
        'phone': '+ 91 ' + phoneController.text.trim(),
      };
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VerifyPhoneScreen(accountInfo),
        ),
      );
      
    }
  }
}
