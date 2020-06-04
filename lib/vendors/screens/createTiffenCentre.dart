import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/services/databaseService.dart';
import 'package:foodieapp/vendors/validation/validate.dart';
import 'package:foodieapp/vendors/widgets/dialogBox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import '../bottomNavigationBar.dart';

class CreateTiffenCentre extends StatefulWidget {
  @override
  CreateTiffenCentreState createState() => CreateTiffenCentreState();
}

class CreateTiffenCentreState extends State<CreateTiffenCentre> {
  DatabaseService _databaseService = new DatabaseService();

  TextEditingController tiffenController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController ownerNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController licenseController = new TextEditingController();
  TextEditingController costController = new TextEditingController();
  TextEditingController bankAccountController = new TextEditingController();
  TextEditingController upiController = new TextEditingController();
  TextEditingController ifscController = new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey();

  List<dynamic> foodCategory;
  String foodCategoryResult;

  int _coverPosition = 0;
  int _menuPosition = 0;
  List<File> _coverImageList = List<File>.generate(4, (file) => File(''));
  List<File> _menuImageList = List<File>.generate(7, (file) => File(''));
  // List<String> _imageStringList = List<String>.generate(2, (i) => '');
  List<String> _coverImageUrls = List();
  List<String> _menuImageUrls = List();

  TimeOfDay _time = TimeOfDay.now();
  var now = new DateTime.now();
  var dt = DateTime.now();

  var breakFastTimefrom = "00:00";
  var breakFastTimeto = "00:00";
  var lunchTimefrom = "00:00";
  var lunchTimeto = "00:00";
  var dinnerTimefrom = "00:00";
  var dinnerTimeto = "00:00";
  var format;

///////////////////////////////////////      this function will set the time into HH:MM am///////////////////////////////////////////////////////////
  void breakFastTimeFrom(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      dt = DateTime(now.year)
          .add(Duration(hours: _time.hour, minutes: _time.minute));
      format = DateFormat.jm();
      breakFastTimefrom = format.format(dt);
      print(breakFastTimefrom);
    });
  }

  void breakFastTimeTo(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      dt = DateTime(now.year)
          .add(Duration(hours: _time.hour, minutes: _time.minute));
      format = DateFormat.jm();
      breakFastTimeto = format.format(dt);
    });
  }

  void lunchTimeFrom(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      dt = DateTime(now.year)
          .add(Duration(hours: _time.hour, minutes: _time.minute));
      format = DateFormat.jm();
      lunchTimefrom = format.format(dt);
    });
  }

  void lunchTimeTo(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      dt = DateTime(now.year)
          .add(Duration(hours: _time.hour, minutes: _time.minute));
      format = DateFormat.jm();
      lunchTimeto = format.format(dt);
    });
  }

  void dinnerTimeFrom(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      dt = DateTime(now.year)
          .add(Duration(hours: _time.hour, minutes: _time.minute));
      format = DateFormat.jm();
      dinnerTimefrom = format.format(dt);
    });
  }

  void dinnerTimeTo(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      dt = DateTime(now.year)
          .add(Duration(hours: _time.hour, minutes: _time.minute));
      format = DateFormat.jm();
      dinnerTimeto = format.format(dt);
      print(dinnerTimeto);
    });
  }

  /////////////////////////////////////

  ///TAKING IMAGES FROM THE GALLERY OF MOBILE
  
  //get cover image form the library
  Future _getCoverImage() async {
    // Get image from gallery.
    File image = await ImagePicker.pickImage(source: ImageSource.gallery).catchError((e){

      print(e.message);
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateTiffenCentre()));
    });
    setState(() {
      _coverImageList[_coverPosition] = image;
    });
  }
//upload multiple image for cover photo
  Future uploadMultipleCoverImage() async {
    List<File> _coverImage = List();

    _coverImage.add(_coverImageList[0]);
    _coverImage.add(_coverImageList[1]);
    _coverImage.add(_coverImageList[2]);
    _coverImage.add(_coverImageList[3]);

    try {
      
      for (int i = 0; i < _coverImage.length; i++) {

        final StorageReference storageReference =
            FirebaseStorage.instance.ref().child("vendor_images").child("cover_images").child(emailController.text).child("cover_image_${i+1}");  
        final StorageUploadTask uploadTask =
            storageReference.putFile(_coverImageList[i]);

        final StreamSubscription<StorageTaskEvent> streamSubscription =
            uploadTask.events.listen((event) {
          print("EVENT ${event.type}");
        });
         // Cancel your subscription when done.
        await uploadTask.onComplete;
        streamSubscription.cancel();

        String imageUrl = await storageReference.getDownloadURL();
        _coverImageUrls.add(imageUrl);
        
      }
    } catch (e) {
      print(e.message);
    }
  }


  //code for menu imaegs

    //get cover image form the library
  Future _getMenuImage() async {
    // Get image from gallery.
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _menuImageList[_menuPosition] = image;
    });
  }
//upload multiple image for cover photo
  Future uploadMultipleMenuImage() async {
    List<File> _menuImage = List();

    _menuImage.add(_menuImageList[0]);
    _menuImage.add(_menuImageList[1]);
    _menuImage.add(_menuImageList[2]);
    _menuImage.add(_menuImageList[3]);
    _menuImage.add(_menuImageList[4]);
    _menuImage.add(_menuImageList[5]);

    try {
      
      for (int i = 0; i < _menuImage.length; i++) {

        final StorageReference storageReference =
            FirebaseStorage.instance.ref().child("vendor_images").child("menu_images").child(emailController.text).child("menu_image_${i+1}");  
        final StorageUploadTask uploadTask =
            storageReference.putFile(_menuImageList[i]);

        final StreamSubscription<StorageTaskEvent> streamSubscription =
            uploadTask.events.listen((event) {
          print("EVENT ${event.type}");
        });
         // Cancel your subscription when done.
        await uploadTask.onComplete;
        streamSubscription.cancel();

        String imageUrl = await storageReference.getDownloadURL();
        _menuImageUrls.add(imageUrl);
        
      }
    } catch (e) {
      print(e.message);
    }
  }

  ///launching terms and condition url
  _launchURL() async {
    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //radio button for handeling service days of tiffen provider
  String days = "7 Days";
  int daysValue = 0;

  void _handleServiceDaysValueChange(int value) {
    setState(() {
      daysValue = value;

      switch (daysValue) {
        case 0:
          days = "7 Days";
          break;
        case 1:
          days = "6 Days(Sunday Closed)";
          break;
      }
    });
  }

//radio button for handelling FASSAI licensence
  String license = "No";
  int licenseValue = 0;
  void _handleLicenseValueChange(int value) {
    setState(() {
      licenseValue = value;

      switch (licenseValue) {
        case 0:
          license = "No";
          break;
        case 1:
          license = "Yes";
          break;
      }
    });
  }

  //radio button for handelling FASSAI licensence
  String want = "No";
  int wantValue = 0;
  void _handleWantValueChange(int value) {
    setState(() {
      wantValue = value;

      switch (wantValue) {
        case 0:
          want = "No";
          break;
        case 1:
          want = "Yes";
          break;
      }
    });
  }

//radio button for handelling PAYMENT MODE
  String payment = "Cash On Delivery";
  int paymentValue = 0;
  void _handlePaymentValueChange(int value) {
    setState(() {
      paymentValue = value;

      switch (licenseValue) {
        case 0:
          payment = "Cash On Delivery";
          break;
        case 1:
          payment = "Online Payment";
          break;
        case 2:
          payment = "Both (Cash + Online Payment)";
          break;
      }
    });
  }

//radio button for handelling Cancelling subscription feature
  String sub = "No";
  int subValue = 1;
  void _handleSubValueChange(int value) {
    setState(() {
      subValue = value;

      switch (subValue) {
        case 0:
          sub = "No";
          break;
        case 1:
          sub = "Yes";
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    foodCategory = [];
    foodCategoryResult = "";
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
                              image: NetworkImage(
                                  "https://scontent.fbek1-1.fna.fbcdn.net/v/t31.0-8/22712358_1445487845569862_704682422345514729_o.jpg?_nc_cat=107&_nc_sid=09cbfe&_nc_ohc=cFNwkNbvrbsAX89FH3M&_nc_ht=scontent.fbek1-1.fna&oh=7e02ebc1165d837a8db900f83e632850&oe=5EF35CD5"),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ],
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Container(
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
                          validator: (val) {
                            if (val.isEmpty) {
                              return "enter your tiffen service name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Tiffen Service Name",
                          ),
                          keyboardType: TextInputType.text),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                          controller: ownerNameController,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "enter your Name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Owner Name",
                          ),
                          keyboardType: TextInputType.text),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                          controller: cityController,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "enter your City";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "City",
                          ),
                          keyboardType: TextInputType.text),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                          controller: addressController,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "enter your address";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Full Address",
                          ),
                          keyboardType: TextInputType.text),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                          controller: emailController,
                          validator: validateEmail,
                          decoration: InputDecoration(
                            labelText: "Owner Email id",
                          ),
                          keyboardType: TextInputType.emailAddress),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                          controller: phoneController,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "enter your phone no";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Phone no.",
                          ),
                          keyboardType: TextInputType.number),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: MultiSelectFormField(
                        autovalidate: false,
                        titleText: "Food Category",
                        validator: (val) {
                          if (val == null || val.length == 0) {
                            return "Please select one or more options";
                          }
                          return null;
                        },
                        dataSource: [
                          {"display": "Veg", "value": "Veg"},
                          {"display": "Non-Veg", "value": "Non-Veg"}
                        ],
                        textField: "display",
                        valueField: "value",
                        okButtonLabel: "OK",
                        initialValue: foodCategory,
                        cancelButtonLabel: "Cancel",
                        hintText: "Please choose Food category",
                        onSaved: (val) {
                          if (val == null) {
                            return "select your food category";
                          }
                          setState(() {
                            foodCategory = val;
                          });
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                          controller: costController,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "enter your average Cost per Tiffen ";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Average Cost per Tiffen(in Rupees)",
                          ),
                          keyboardType: TextInputType.number),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Text(
                        "Service days",
                        style:
                            new TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              new Radio(
                                activeColor: Colors.green,
                                value: 0,
                                groupValue: daysValue,
                                onChanged: _handleServiceDaysValueChange,
                              ),
                              new Text(
                                '7 Days',
                                style: new TextStyle(
                                    fontSize: 16.0, color: Colors.green),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              new Radio(
                                activeColor: Colors.green,
                                value: 1,
                                groupValue: daysValue,
                                onChanged: _handleServiceDaysValueChange,
                              ),
                              new Text(
                                '6 Days(Sunday- Closed)',
                                style: new TextStyle(
                                    fontSize: 16.0, color: Colors.green),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.green,
                            thickness: 1.0,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Text(
                        "Add Time Slot",
                        style:
                            new TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Text("BreakFast",
                          style: new TextStyle(
                            color: Colors.green,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              showPicker(
                                context: context,
                                value: _time,
                                onChange: breakFastTimeFrom,
                                is24HrFormat: false,
                              ),
                            );
                          },
                          child: Text(
                            "From : $breakFastTimefrom",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              showPicker(
                                context: context,
                                value: _time,
                                onChange: breakFastTimeTo,
                                is24HrFormat: false,
                              ),
                            );
                          },
                          child: Text("To : $breakFastTimeto",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Text("Lunch",
                          style: new TextStyle(
                            color: Colors.green,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              showPicker(
                                context: context,
                                value: _time,
                                onChange: lunchTimeFrom,
                                is24HrFormat: false,
                              ),
                            );
                          },
                          child: Text(
                            "From : $lunchTimefrom",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              showPicker(
                                context: context,
                                value: _time,
                                onChange: lunchTimeTo,
                                is24HrFormat: false,
                              ),
                            );
                          },
                          child: Text("To : $lunchTimeto",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Text("Dinner",
                          style: new TextStyle(
                            color: Colors.green,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              showPicker(
                                context: context,
                                value: _time,
                                onChange: dinnerTimeFrom,
                                is24HrFormat: false,
                              ),
                            );
                          },
                          child: Text(
                            "From : $dinnerTimefrom",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              showPicker(
                                context: context,
                                value: _time,
                                onChange: dinnerTimeTo,
                                is24HrFormat: false,
                              ),
                            );
                          },
                          child: Text("To : $dinnerTimeto",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),

                    //Code for images
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Text(
                        "Select Cover images for your Tiffen Service",
                        style:
                            new TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                    ),

                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {
                                _coverPosition = 0;
                                _getCoverImage();
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                child: Card(
                                    child: (_coverImageList[0].path != '')
                                        ? Image.file(
                                            _coverImageList[0],
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(Icons.add_photo_alternate,
                                            size: 20, color: Colors.grey[700])),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {
                                _coverPosition = 1;
                                _getCoverImage();
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                child: Card(
                                    child: (_coverImageList[1].path != '')
                                        ? Image.file(
                                            _coverImageList[1],
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(Icons.add_photo_alternate,
                                            size: 20, color: Colors.grey[700])),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {
                                _coverPosition = 2;
                                _getCoverImage();
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                child: Card(
                                    child: (_coverImageList[2].path != '')
                                        ? Image.file(
                                            _coverImageList[2],
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(Icons.add_photo_alternate,
                                            size: 20, color: Colors.grey[700])),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {
                                _coverPosition = 3;
                                _getCoverImage();
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                child: Card(
                                    child: (_coverImageList[3].path != '')
                                        ? Image.file(
                                            _coverImageList[3],
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(Icons.add_photo_alternate,
                                            size: 20, color: Colors.grey[700])),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //MENU images code
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Text(
                        "Select Menu images for your Tiffen Service",
                        style:
                            new TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                    ),

                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //1 image
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {
                                _menuPosition = 0;
                                _getMenuImage();
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                child: Card(
                                    child: (_menuImageList[0].path != '')
                                        ? Image.file(
                                            _menuImageList[0],
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(Icons.add_photo_alternate,
                                            size: 20, color: Colors.grey[700])),
                              ),
                            ),
                          ),
                          // 2 image
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {
                                _menuPosition = 1;
                                _getMenuImage();
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                child: Card(
                                    child: (_menuImageList[1].path != '')
                                        ? Image.file(
                                            _menuImageList[1],
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(Icons.add_photo_alternate,
                                            size: 20, color: Colors.grey[700])),
                              ),
                            ),
                          ),
                          //3 image
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {
                                _menuPosition = 2;
                                _getMenuImage();
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                child: Card(
                                    child: (_menuImageList[2].path != '')
                                        ? Image.file(
                                            _menuImageList[2],
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(Icons.add_photo_alternate,
                                            size: 20, color: Colors.grey[700])),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //2 row
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //4 image
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {
                                _menuPosition = 3;
                                _getMenuImage();
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                child: Card(
                                    child: (_menuImageList[3].path != '')
                                        ? Image.file(
                                            _menuImageList[3],
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(Icons.add_photo_alternate,
                                            size: 20, color: Colors.grey[700])),
                              ),
                            ),
                          ),
                          //5 image
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {
                                _menuPosition = 4;
                                _getMenuImage();
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                child: Card(
                                    child: (_menuImageList[4].path != '')
                                        ? Image.file(
                                            _menuImageList[4],
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(Icons.add_photo_alternate,
                                            size: 20, color: Colors.grey[700])),
                              ),
                            ),
                          ),
                          //6 image
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new GestureDetector(
                              onTap: () {
                                _menuPosition = 5;
                                _getMenuImage();
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                child: Card(
                                    child: (_menuImageList[5].path != '')
                                        ? Image.file(
                                            _menuImageList[5],
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(Icons.add_photo_alternate,
                                            size: 20, color: Colors.grey[700])),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Text(
                        "Do you have FSSAI License?",
                        style:
                            new TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              new Radio(
                                activeColor: Colors.green,
                                value: 0,
                                groupValue: licenseValue,
                                onChanged: _handleLicenseValueChange,
                              ),
                              new Text(
                                'No',
                                style: new TextStyle(
                                    fontSize: 16.0, color: Colors.green),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              new Radio(
                                activeColor: Colors.green,
                                value: 1,
                                groupValue: licenseValue,
                                onChanged: _handleLicenseValueChange,
                              ),
                              new Text(
                                'Yes',
                                style: new TextStyle(
                                    fontSize: 16.0, color: Colors.green),
                              ),
                            ],
                          ),
                          licenseValue == 1
                              ? TextFormField(
                                  controller: licenseController,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "enter your FSSAI License";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "xxxxxxxxxxxxxxxxxxxx",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                )
                              : Container(),
                          Divider(
                            color: Colors.green,
                            thickness: 1.0,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Text(
                        "Modes of Payment",
                        style:
                            new TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              new Radio(
                                activeColor: Colors.green,
                                value: 0,
                                groupValue: paymentValue,
                                onChanged: _handlePaymentValueChange,
                              ),
                              new Text(
                                'Cash On Delivery',
                                style: new TextStyle(
                                    fontSize: 16.0, color: Colors.green),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              new Radio(
                                activeColor: Colors.green,
                                value: 1,
                                groupValue: paymentValue,
                                onChanged: _handlePaymentValueChange,
                              ),
                              new Text(
                                'Online Payment',
                                style: new TextStyle(
                                    fontSize: 16.0, color: Colors.green),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              new Radio(
                                activeColor: Colors.green,
                                value: 2,
                                groupValue: paymentValue,
                                onChanged: _handlePaymentValueChange,
                              ),
                              new Text(
                                'Both (Cash + Online Payment)',
                                style: new TextStyle(
                                    fontSize: 16.0, color: Colors.green),
                              ),
                            ],
                          ),
                          paymentValue == 1
                              ? Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: upiController,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return "enter your UPI id";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "UPI ID",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                    TextFormField(
                                      controller: bankAccountController,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return "enter your Bank Account no";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Bank account no.",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                    TextFormField(
                                      controller: ifscController,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return "enter your IFSC code";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "IFSC Code",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                          paymentValue == 2
                              ? Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: upiController,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return "enter your UPI id";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "UPI ID",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                    TextFormField(
                                      controller: bankAccountController,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return "enter your Bank Account no";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Bank account no.",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                    TextFormField(
                                      controller: ifscController,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return "enter your IFSC code";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "IFSC Code",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                          Divider(
                            color: Colors.green,
                            thickness: 1.0,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Text(
                        "Do you offer cancellation for subscription with refund?",
                        style:
                            new TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              new Radio(
                                activeColor: Colors.green,
                                value: 0,
                                groupValue: subValue,
                                onChanged: _handleSubValueChange,
                              ),
                              new Text(
                                'No',
                                style: new TextStyle(
                                    fontSize: 16.0, color: Colors.green),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              new Radio(
                                activeColor: Colors.green,
                                value: 1,
                                groupValue: subValue,
                                onChanged: _handleSubValueChange,
                              ),
                              new Text(
                                'Yes',
                                style: new TextStyle(
                                    fontSize: 16.0, color: Colors.green),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.green,
                            thickness: 1.0,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Text(
                        "Are you interested to partner with us?",
                        style:
                            new TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(0.1),
                        child: new FlatButton(
                          child: new Text(
                            "Terms & conditions",
                            style: new TextStyle(
                                color: Colors.green, fontSize: 16.0),
                          ),
                          onPressed: () {
                            _launchURL();
                          },
                        )),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: new Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              new Radio(
                                activeColor: Colors.green,
                                value: 0,
                                groupValue: wantValue,
                                onChanged: _handleWantValueChange,
                              ),
                              new Text(
                                'No',
                                style: new TextStyle(
                                    fontSize: 16.0, color: Colors.green),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              new Radio(
                                activeColor: Colors.green,
                                value: 1,
                                groupValue: wantValue,
                                onChanged: _handleWantValueChange,
                              ),
                              new Text(
                                'Yes',
                                style: new TextStyle(
                                    fontSize: 16.0, color: Colors.green),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.green,
                            thickness: 1.0,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: height * 0.03),
                      width: double.infinity,
                      child: RaisedButton(
                        elevation: 5.0,
                        onPressed: wantValue == 0
                            ? () {
                                DialogBox().information(context, "Alert",
                                    "You have to accept Terms & conditions to work with us");
                              }
                            : () {
                                return createTiffen();
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
          ),
        ],
      ),
    );
  }

  createTiffen() async{
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await uploadMultipleCoverImage();
      await uploadMultipleMenuImage();

      setState(() {
        foodCategoryResult = foodCategory.toString();
      });
      print(foodCategoryResult);

      Map<String, String> tiffenInfo = {
        "Tiffen Name": tiffenController.text,
        "Email": emailController.text,
        "OwnerName": ownerNameController.text,
        "Address": addressController.text,
        "Phone": phoneController.text,
        "City": cityController.text,
        "CostPerMeal": "₹${costController.text}",
        "Food Category": foodCategoryResult,
        "Service Days": days,
        "FSSAI License": license,
        "FSSAI License Number": licenseController.text,
        "Payment Mode": payment,
        "UPI ID": upiController.text,
        "Bank Account No.": bankAccountController.text,
        "IFSC code": ifscController.text,
        "Offer cancellation Subscription": sub,
        "BreakFast Time": "$breakFastTimefrom" + "-" "$breakFastTimeto",
        "Lunch Time": "$lunchTimefrom" + "-" "$lunchTimeto",
        "Dinner Time": "$dinnerTimefrom" + "-" "$dinnerTimeto",
        "cover image 1" : _coverImageUrls[0],
        "cover image 2" : _coverImageUrls[1],
        "cover image 3" : _coverImageUrls[2],
        "cover image 4" : _coverImageUrls[3],
        "Menu Image 1" : _menuImageUrls[0],
        "Menu Image 2" : _menuImageUrls[1],
        "Menu Image 3" : _menuImageUrls[2],
        "Menu Image 4" : _menuImageUrls[3],
        "Menu Image 5" : _menuImageUrls[4],
        "Menu Image 6" : _menuImageUrls[5],
      };

      _databaseService.createTiffen(tiffenInfo, emailController.text);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => BottomNavigationScreen()));
      DialogBox()
          .information(context, "Success", "Your have Login successfully");
    }
  }
}
