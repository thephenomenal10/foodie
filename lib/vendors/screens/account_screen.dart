import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/bottomNavigationBar.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/screens/showTiffenInfo.dart';
import 'package:foodieapp/vendors/services/databaseService.dart';
import 'package:foodieapp/vendors/utils/mySlide.dart';
import 'package:image_picker/image_picker.dart';

import '../services/firebase_service.dart';
// import 'package:foodieapp/vendors/widgets/globalVariable.dart' as global;

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

  Uint8List imageFile;
  File _image;

  void saveImageToFirebase(a) {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("vendor_images")
        .child("user_profile")
        .child(a);
    storageReference.child("image_$a.jpg").putFile(_image);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() async {
      _image = image;
      saveImageToFirebase(email); //
      try {
        await fetchImageFromFirebase(email); //
      } catch (error) {}
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationScreen(
            index: 3,
          ),
        ),
      );
    });
  }

  Future<void> fetchImageFromFirebase(a) async {
    try {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child("vendor_images")
          .child("user_profile")
          .child(a);
      int maxSize = 5 * 1024 * 1024;
      imageFile = await storageReference.child("image_$a.jpg").getData(maxSize);
    } catch (error) {
      print(error);
    }
  }

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
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    updateUserInfo();
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
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

  Future<void> getUserInfo() async {
    final currentEmail = (await FirebaseAuth.instance.currentUser()).email;

    final data = await Firestore.instance
        .collection("vendor_collection/vendors/registered_vendors")
        .document(currentEmail)
        .get();
    userName = data['Name'];
    email = data['Email'];
    phone = data['Phone'];
    await fetchImageFromFirebase(email);
  }

  // @override
  // void initState() {
  //   getUserInfo().whenComplete(() {
  //     fetchImageFromFirebase(email);
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: ListView(
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
                            horizontal: 8,
                            vertical: 5,
                          ),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            backgroundImage: imageFile == null
                                ? AssetImage("assets/avatar.png")
                                : MemoryImage(imageFile),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          child: GestureDetector(
                            onTap: getImage,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.camera_alt,
                                color: Theme.of(context).primaryColor,
                              ),
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
                              _isEditMode == true
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TextFormField(
                                        controller: emailController,
                                        // initialValue:
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: email,
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: TextFormField(
                                  controller: nameController,
                                  // initialValue:
                                  enabled: _isEditMode,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter username';
                                    } else if (value.length > 20) {
                                      return "username is too long!";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText:
                                        _isEditMode == true ? "Name" : userName,
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: phoneController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter phone number';
                                    }
                                    return null;
                                  },
                                  // initialValue: _isEditMode == true ? phone : null,
                                  enabled: _isEditMode,
                                  decoration: InputDecoration(
                                    prefixText: '+ 91 ',
                                    labelText:
                                        _isEditMode == true ? "Phone" : phone,
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
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
              _isEditMode
                  ? SizedBox()
                  : Container(
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
                          'Show Tiffin Details',
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
      },
    );
  }

  showTiffenInfo() {
    Route route = MySlide(builder: (context) => ShowTiffenInfo());
    Navigator.push(context, route);
  }

  Future<void> updateUserInfo() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final instance = await FirebaseAuth.instance.currentUser();
      email = instance.email;
      String name = nameController.text.trim();
      String phone = '+ 91 ' + phoneController.text.trim();
      await FirebaseAuthentication().updatePhoneNumber(context, phone, name);
      setState(() {
        _isEditMode = !_isEditMode;
        nameController.clear();
        phoneController.clear();
        emailController.clear();
        getUserInfo();
      });
    }
  }
}
