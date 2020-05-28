import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/widgets/dialogBox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodieapp/vendors/bottomNavigationBar.dart';

class CreateTiffenCentre extends StatefulWidget {
  @override
  CreateTiffenCentreState createState() => CreateTiffenCentreState();
}

class CreateTiffenCentreState extends State<CreateTiffenCentre> {
  TextEditingController tiffenController = new TextEditingController();
  TextEditingController tiffenAddressController = new TextEditingController();
  TextEditingController vegNonVegController = new TextEditingController();

StorageReference storageReference = FirebaseStorage.instance.ref().child("vendor_tiffen_cover_image");

  Uint8List imageFile;
  File _image;

    saveImageToFirebase(a) {

    storageReference.child("image_$a.jpg").putFile(_image);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      saveImageToFirebase("tiffenCentername");
      fetchImageFromFirebase("tiffenCentername");
    });
  }



  fetchImageFromFirebase(a) {
    int maxSize = 5*1024*1024;
    storageReference.child("image_$a.jpg").getData(maxSize).then((value){
        setState(() {
          imageFile = value;
        });
    });
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      fetchImageFromFirebase("tiffenCentername");
    });
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

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
                      "Setup your Tiffen Centre",
                      textScaleFactor: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 10),
                    ),
                  ],
                ),
                Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 20),
                      child: Container(
                        width: 300,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: imageFile == null
                            ? NetworkImage("https://scontent.fbek1-1.fna.fbcdn.net/v/t31.0-8/22712358_1445487845569862_704682422345514729_o.jpg?_nc_cat=107&_nc_sid=09cbfe&_nc_ohc=cFNwkNbvrbsAX89FH3M&_nc_ht=scontent.fbek1-1.fna&oh=7e02ebc1165d837a8db900f83e632850&oe=5EF35CD5")
                            : MemoryImage(
                                imageFile),
                                fit: BoxFit.cover
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: getImage,

                      child: Positioned(
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
                        'Tiffen Centre Information',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                        controller: tiffenController,
                        decoration: InputDecoration(
                          labelText: "Tiffen Name",
                        ),
                        keyboardType: TextInputType.text),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                        controller: tiffenAddressController,
                        decoration: InputDecoration(
                          labelText: "Full Address",
                        ),
                        keyboardType: TextInputType.text),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                        controller: vegNonVegController,
                        decoration: InputDecoration(
                          labelText: "Veg or NonVeg",
                        ),
                        keyboardType: TextInputType.text),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: height * 0.03),
                    width: double.infinity,
                    child: RaisedButton(
                      elevation: 5.0,
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => BottomNavigationScreen()));
                        DialogBox().information(context, "Success",
                            "Your have Registered successfully");
                      },
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.white,
                      child: Text(
                        'SAVE',
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
            ),
          ),
        ],
      ),
    );
  }
}
