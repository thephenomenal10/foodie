import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foodieapp/vendors/screens/HomePage.dart';
// import 'package:foodieapp/vendors/screens/forgotPass.dart';
// import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:foodieapp/vendors/validation/validate.dart';
import 'package:foodieapp/vendors/widgets/dialogBox.dart';

// import 'constants/constants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _numberController = new TextEditingController();
  var _isLogin = true;
  var _isSubscribed = false;

  Widget _textWidget(String title,[Color color=Colors.black]) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        title,
        textScaleFactor: 1.05,
        style: TextStyle(
          color: color,
          letterSpacing: 1.25,
        ),
      ),
    );
  }

  Widget _textFormWidget(TextEditingController controller, bool obscureText) {
    return TextFormField(
      controller: controller,
      validator: validateEmail,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
      obscureText: obscureText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "foodifi.in",
          textScaleFactor: 1.5,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
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
                      _isLogin ? SizedBox() : _textWidget('Name'),
                      _isLogin
                          ? SizedBox()
                          : _textFormWidget(_nameController, false),
                      _isLogin ? SizedBox() : _textWidget('Phone'),
                      _isLogin
                          ? SizedBox()
                          : _textFormWidget(_numberController, false),
                      _textWidget('Email'),
                      _textFormWidget(_emailController, false),
                      _textWidget('Password'),
                      _textFormWidget(_passController, true),
                      _isLogin
                          ? SizedBox()
                          : ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: FlatButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  //navigate to payment gate way and return with some feed back.
                                  setState(() {
                                    _isSubscribed = !_isSubscribed;
                                  });
                                },
                                child: _textWidget('Subscribe',Colors.white),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.info,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () => showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    title: Text('Subscribe to Continue'),
                                    content: Text(
                                      'You need to subscribe inorder to maintain your shop.\n\nSubscription amount is Rs 199',
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
                                          'Okay',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      InkWell(
                        onTap: (!_isLogin && !_isSubscribed)
                            ? null
                            : () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Home(),
                                  ),
                                );
                              },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 3,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: (_isSubscribed || _isLogin) ? Theme.of(context).primaryColor : Colors.black12,
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
                                _isLogin ? 'Login' : 'Register',
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
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin
                        ? "Don't have an account ? Register."
                        : "Already have an account ? Login.",
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
}
