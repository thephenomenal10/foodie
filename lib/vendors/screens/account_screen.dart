import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/screens/showTiffenInfo.dart';
import 'package:foodieapp/vendors/services/databaseService.dart';
import 'package:foodieapp/vendors/utils/mySlide.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/firebase_service.dart';
import 'package:foodieapp/vendors/widgets/globalVariable.dart' as global;

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  FirebaseAuthentication _firebaseAuthentication = new FirebaseAuthentication();
  DatabaseService databaseService = new DatabaseService();

  String userName;
  String email;
  String phone;
  String address;
  var _isEditMode = false;

  Firestore firestore = Firestore.instance;

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey();

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 10.0),
              child: RaisedButton(
                child: Text("Save"),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  updateUserInfo();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              child: RaisedButton(
                child: Text("Cancel"),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() {
                    _isEditMode = !_isEditMode;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _isEditMode = !_isEditMode;
        });
      },
    );
  }

  Future<void> getVendorInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentUserEmail = prefs.getString("currentUserEmail");
    await firestore
        .collection("vendor_collection")
        .document("vendors")
        .collection("registered_vendors")
        .document(currentUserEmail)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        userName = ds['Name'];
        print(userName);
        phone = ds['Phone'];

        email = ds['Email'];
        print(email);
      });
    });
  }

  @override
  void initState() {
    getVendorInfo();
    global.isSignUpLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userName == null || email == null || phone == null
          ? Center(child: CircularProgressIndicator( ))
          : ListView(
              children: <Widget>[
                Container(
                  height: 250,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Profile",
                            textScaleFactor: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.exit_to_app,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onTap: () {
                              _firebaseAuthentication.signOut(context);
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Stack(
                        fit: StackFit.loose,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                'https://www.shareicon.net/data/512x512/2016/07/26/802043_man_512x512.png',
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 0,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.camera_alt,
                                //size: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              'Account Information',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            !_isEditMode ? _getEditIcon() : SizedBox(),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    controller: nameController,
                                    // initialValue:
                                    enabled: _isEditMode,
                                    decoration: InputDecoration(
                                        labelText: _isEditMode == true
                                            ? "Name"
                                            : userName,
                                        labelStyle:
                                            TextStyle(color: Colors.black)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    controller: emailController,
                                    // initialValue:
                                    enabled: _isEditMode,
                                    decoration: InputDecoration(
                                        labelText: _isEditMode == true
                                            ? "Email"
                                            : email,
                                        labelStyle:
                                            TextStyle(color: Colors.black)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    controller: phoneController,
                                    // initialValue: _isEditMode == true ? phone : null,
                                    enabled: _isEditMode,
                                    decoration: InputDecoration(
                                        labelText: _isEditMode == true
                                            ? "Phone"
                                            : phone,
                                        labelStyle:
                                            TextStyle(color: Colors.black)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _isEditMode ? _getActionButtons() : SizedBox(),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(30.0),
                  child: RaisedButton(
                    elevation: 5.0,
                    onPressed: () {
                      return showTiffenInfo();
                    },
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.white,
                    child: Text(
                      'Show Tiffen Details',
                      textScaleFactor: 1.5,
                      style: TextStyle(
                        color: myGreen,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  showTiffenInfo() {
    Route route = MySlide(builder: (context) => ShowTiffenInfo());
    Navigator.push(context, route);
  }

  void updateUserInfo() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("currentUserEmail", emailController.text);
      Map<String, String> userInfo = {
        "Email": emailController.text,
        "Name": nameController.text,
        "Phone": phoneController.text,
      };

      databaseService.addUserData(userInfo, emailController.text);
      setState(() {
        _isEditMode = !_isEditMode;
        nameController.clear();
        phoneController.clear();
        emailController.clear();
        getVendorInfo();
      });
    }
  }
}
