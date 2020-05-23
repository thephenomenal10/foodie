import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foodieapp/vendors/services/firebase_service.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:foodieapp/vendors/validation/validate.dart';
import './login.dart';
import '../widgets/isLoading.dart' as global;

class Register extends StatefulWidget {
    @override
    _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

    FirebaseAuthentication _firebaseAuthentication = new FirebaseAuthentication();

    GlobalKey<FormState> _formKey = new GlobalKey();
    TextEditingController _emailController = new TextEditingController();
    TextEditingController _passController = new TextEditingController();
    TextEditingController _nameController = new TextEditingController();
    TextEditingController _numberController = new TextEditingController();
    var _isSubscribed = false;


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: global.isSignUpLoading
            ? CircularProgressIndicator()
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
                                                    "Name",
                                                    textScaleFactor: 1.05,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        letterSpacing: 1.25,
                                                    ),
                                                ),
                                            ),
                                            TextFormField(
                                                controller: _nameController,
                                                validator:  (val) {
                                                    if(val.isEmpty){
                                                        return "enter yout name";
                                                    }
                                                    return null;
                                                },
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
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                child: Text(
                                                    "Phone",
                                                    textScaleFactor: 1.05,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        letterSpacing: 1.25,
                                                    ),
                                                ),
                                            ),
                                            TextFormField(
                                                controller: _numberController,
                                                validator:  (val) {
                                                    if(val.isEmpty){
                                                        return "enter your phone";
                                                    }
                                                    return null;
                                                },
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
                                            ),
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
                                            ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: FlatButton(
                                                    color: Theme.of(context).primaryColor,
                                                    onPressed: () {
                                                        //navigate to payment gate way and return with some feed back.
                                                        setState(() {
                                                            _isSubscribed = !_isSubscribed;
                                                        });
                                                    },
                                                    child: Padding(
                                                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                        child: Text(
                                                            "Subscribe",
                                                            textScaleFactor: 1.05,
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                letterSpacing: 1.25,
                                                            ),
                                                        ),
                                                    ),
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
                                                onTap: (!_isSubscribed)
                                                    ? null
                                                    : () {
                                                    signMeUp();
                                                },
                                                child: Container(
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 3,
                                                    ),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: (_isSubscribed) ? Theme.of(context).primaryColor : Colors.black12,
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
                                                            child: Text('Register',
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                                    },
                                    child: Text( "Already have an account ? Login.",
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
        if(_formKey.currentState.validate()){
            _formKey.currentState.save();

            _firebaseAuthentication.signUp(context, _emailController, _passController);
        }

    }
}
