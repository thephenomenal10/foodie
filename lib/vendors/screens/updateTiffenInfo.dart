import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodieapp/vendors/bottomNavigationBar.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/screens/searchLocalityScree.dart';
import 'package:foodieapp/vendors/widgets/globalVariable.dart' as global;
import 'package:foodieapp/vendors/services/databaseService.dart';
import 'package:foodieapp/vendors/widgets/dialogBox.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../widgets/addTiffinTypes.dart';

class UpdateTiffenInfo extends StatefulWidget {
  @override
  UpdateTiffenInfoState createState() => UpdateTiffenInfoState();
}

class UpdateTiffenInfoState extends State<UpdateTiffenInfo> {
  DatabaseService _databaseService = new DatabaseService();

  TextEditingController tiffinController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  // TextEditingController emailController = new TextEditingController();
  TextEditingController ownerNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController licenseController = new TextEditingController();
  TextEditingController costController = new TextEditingController();
  TextEditingController bankAccountController = new TextEditingController();
  TextEditingController upiController = new TextEditingController();
  TextEditingController ifscController = new TextEditingController();
  TextEditingController paytmController = new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey();

  List<dynamic> foodCategory;
  String foodCategoryResult;

  List<Asset> coverImages = List<Asset>();
  List<Asset> logoImage = List<Asset>();
  List<Asset> menuImages = List<Asset>();
  String logoImageUrl;
  List<String> coverImageUrls = <String>[];
  List<String> menuImageUrls = <String>[];

  String _error = 'No Error Dectected';
  bool isUploading = false;

  TimeOfDay _time = TimeOfDay.now();
  var now = new DateTime.now();
  var dt = DateTime.now();

  var breakFastTimefrom = "7:00 AM";
  var breakFastTimeto = "9:00 AM";
  var lunchTimefrom = "1:00 PM";
  var lunchTimeto = "3:00 PM";
  var dinnerTimefrom = "8:00 PM";
  var dinnerTimeto = "10:00 PM";
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

  ///TAKING IMAGES FROM THE GALLERY OF MOBILE and uploading to the firebase storage and urls to database as a List

  Future<void> loadLogoImage() async {
    List<Asset> resultList = List<Asset>();

    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: logoImage,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      print(resultList.length);
      print((await resultList[0].getThumbByteData(122, 100)));
      print((await resultList[0].getByteData()));
      print((await resultList[0].metadata));
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    setState(() {
      logoImage = resultList;
      _error = error;
    });
  }

  Future<void> uploadLogoImage() async {
    try {
      for (int i = 0; i < logoImage.length; i++) {
        final StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child("vendor_images")
            .child("Logo_image")
            .child(email)
            .child("logo_image_${i + 1}");
        final StorageUploadTask uploadTask = storageReference
            .putData((await logoImage[i].getByteData()).buffer.asUint8List());

        final StreamSubscription<StorageTaskEvent> streamSubscription =
            uploadTask.events.listen((event) {
          print("EVENT ${event.type}");
        });

        await uploadTask.onComplete;
        await streamSubscription.cancel();

        logoImageUrl = await storageReference.getDownloadURL();

        await Firestore.instance
            .collection("tiffen_service_details")
            .document(email)
            .updateData({'Logo Image': logoImageUrl});
      }
    } catch (e) {
      print(e.message);
    }
  }

//code for cover photos

  Future<void> loadCoverImages() async {
    List<Asset> resultList = List<Asset>();

    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: coverImages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      print(resultList.length);
      print((await resultList[0].getThumbByteData(122, 100)));
      print((await resultList[0].getByteData()));
      print((await resultList[0].metadata));
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    setState(() {
      coverImages = resultList;
      _error = error;
    });
  }

  Future uploadCoverImages() async {
    try {
      for (int i = 0; i < coverImages.length; i++) {
        final StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child("vendor_images")
            .child("cover_images")
            .child(email)
            .child("cover_image_${i + 1}");
        final StorageUploadTask uploadTask = storageReference
            .putData((await coverImages[i].getByteData()).buffer.asUint8List());

        final StreamSubscription<StorageTaskEvent> streamSubscription =
            uploadTask.events.listen((event) {
          print("EVENT ${event.type}");
        });

        await uploadTask.onComplete;
        await streamSubscription.cancel();

        String imageUrl = await storageReference.getDownloadURL();

        coverImageUrls.add(imageUrl.toString());
        await Firestore.instance
            .collection("tiffen_service_details")
            .document(email)
            .updateData({'Cover Photos': coverImageUrls});
      }
    } catch (e) {
      print(e.message);
    }
  }

//////////////////////////MENU IMAGES CODE

  Future<void> loadMenuImages() async {
    List<Asset> resultList = List<Asset>();

    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 7,
        enableCamera: true,
        selectedAssets: menuImages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#95f783",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#95f783",
        ),
      );
      print(resultList.length);
      print((await resultList[0].getThumbByteData(122, 100)));
      print((await resultList[0].getByteData()));
      print((await resultList[0].metadata));
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    setState(() {
      menuImages = resultList;
      _error = error;
    });
  }

  Future<void> uploadMenuImages() async {
    try {
      for (int i = 0; i < menuImages.length; i++) {
        final StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child("vendor_images")
            .child("menu_images")
            .child(email)
            .child("menu_image_${i + 1}");
        final StorageUploadTask uploadTask = storageReference
            .putData((await menuImages[i].getByteData()).buffer.asUint8List());

        final StreamSubscription<StorageTaskEvent> streamSubscription =
            uploadTask.events.listen((event) {
          print("EVENT ${event.type}");
        });

        await uploadTask.onComplete;
        await streamSubscription.cancel();

        String imageUrl = await storageReference.getDownloadURL();

        menuImageUrls.add(imageUrl.toString());
        await Firestore.instance
            .collection("tiffen_service_details")
            .document(email)
            .updateData({'Meal Images': menuImageUrls});
      }
    } catch (e) {
      print(e.message);
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



//radio button for handelling PAYMENT MODE
  String payment = "Cash On Delivery";
  int paymentValue = 0;
  void _handlePaymentValueChange(int value) {
    setState(() {
      paymentValue = value;

      switch (paymentValue) {
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
    print(payment);
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

  Widget getFormField(
      TextEditingController controller, String errorMsg, String labelText) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        validator: (val) {
          if (val.isEmpty) {
            return errorMsg;
          } else if (val.length > 20) {
            return "please enter in less than 20 characters";
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle:
                TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.2)),
        keyboardType: TextInputType.text,
      ),
    );
  }

  String email;
  Future<void> getEmail() async {
    email = (await FirebaseAuth.instance.currentUser()).email;
    print(email);
  }

  @override
  void initState() {
    // getEmail();
    super.initState();
    foodCategory = [];
    foodCategoryResult = '';
    global.isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: global.isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            )
          : FutureBuilder(
              future: getEmail(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                }
                return ListView(
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
                                "Setup your Tiffin Centre",
                                textScaleFactor: 2,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                          Stack(
                            fit: StackFit.loose,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 20,
                                ),
                                child: Container(
                                  width: 300,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/food1.png",
                                      ),
                                      fit: BoxFit.cover,
                                      // image: NetworkImage(
                                      //     "https://scontent.fbek1-1.fna.fbcdn.net/v/t31.0-8/22712358_1445487845569862_704682422345514729_o.jpg?_nc_cat=107&_nc_sid=09cbfe&_nc_ohc=cFNwkNbvrbsAX89FH3M&_nc_ht=scontent.fbek1-1.fna&oh=7e02ebc1165d837a8db900f83e632850&oe=5EF35CD5"),
                                      // fit: BoxFit.cover,
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
                    Form(
                      key: _formKey,
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    'Tiffin Centre Information',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                                  ),
                                ],
                              ),
                              Divider(
                                color: myGreen,
                                endIndent: width * 0.7,
                                indent: width * 0.005,
                                height: 8,
                                thickness: 3.0,
                              ),
                              SizedBox(height: 30.0),
                              Divider(
                                color: myGreen,
                                endIndent: width * 0.75,
                                indent: width * 0.005,
                                height: 8,
                                thickness: 3.0,
                              ),

                              /////////////////////BASIC INFO///////////////////////////
                              ExpansionTile(
                                title: new Text(
                                  "Basic Info",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w600),
                                ),
                                trailing:
                                    Icon(Feather.arrow_down, color: myGreen),
                                leading: Icon(Entypo.info_with_circle,
                                    color: myGreen),
                                children: [
                                  getFormField(
                                    tiffinController,
                                    'enter your tiffin service name',
                                    'Tiffin Service Name',
                                  ),
                                  getFormField(
                                    ownerNameController,
                                    'enter your Name',
                                    'Owner Name',
                                  ),
                                  getFormField(
                                    cityController,
                                    'enter your City',
                                    'City',
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: TextFormField(
                                      controller: addressController,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return 'enter your address';
                                        } else if (val.length > 30) {
                                          return "please enter in less than 30 characters";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Full address',
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.2)),
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: TextFormField(
                                      initialValue: email,
                                      enabled: false,
                                      // decoration: InputDecoration(
                                      //     labelText: email,
                                      //     labelStyle: TextStyle(
                                      //         color: Colors.black,
                                      //         fontWeight: FontWeight.w600,
                                      //         letterSpacing: 1.2)),
                                    ),
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
                                          prefix: Text("+91 "),
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.2)),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SearchLocality(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Tiffin Center Address',
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  global.localityAddress == null
                                      ? Container()
                                      : Padding(
                                          padding: EdgeInsets.all(10),
                                          child: TextFormField(
                                            enabled: false,
                                            initialValue:
                                                global.localityAddress,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.2),
                                          ),
                                        ),
                                  SizedBox(
                                    height: 20.0,
                                  )
                                ],
                              ),
                              ////////////////////////////////////////////////////////
                              SizedBox(height: 30.0),
                              Divider(
                                color: myGreen,
                                endIndent: width * 0.75,
                                indent: width * 0.005,
                                height: 8,
                                thickness: 3.0,
                              ),
                              /////////////////////////////FOOD INFO////////////////////////
                              ExpansionTile(
                                title: new Text(
                                  "Food Info",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w600),
                                ),
                                trailing:
                                    Icon(Feather.arrow_down, color: myGreen),
                                leading: Icon(FlutterIcons.food_fork_drink_mco,
                                    color: myGreen),
                                children: [
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
                                        {
                                          "display": "Non-Veg",
                                          "value": "Non-Veg"
                                        }
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
                                    padding: const EdgeInsets.all(10),
                                    child: AddTiffinTypes(),
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
                                          labelText:
                                              "Average Cost per Tiffin (in Rupees)",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.2)),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  )
                                ],
                              ),

                              /////////////////////////////////////////////////////////
                              SizedBox(height: 30.0),
                              Divider(
                                color: myGreen,
                                endIndent: width * 0.75,
                                indent: width * 0.005,
                                height: 8,
                                thickness: 3.0,
                              ),

                              ///////////////////////TIFFEN SERVICE TIMING///////////////////////
                              ExpansionTile(
                                title: new Text(
                                  "Tiffin Service Timing",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w600),
                                ),
                                trailing:
                                    Icon(Feather.arrow_down, color: myGreen),
                                leading: Icon(Icons.timelapse, color: myGreen),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: new Text(
                                      "Service days",
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2),
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
                                              onChanged:
                                                  _handleServiceDaysValueChange,
                                            ),
                                            new Text(
                                              '7 Days',
                                              style: new TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            new Radio(
                                              activeColor: Colors.green,
                                              value: 1,
                                              groupValue: daysValue,
                                              onChanged:
                                                  _handleServiceDaysValueChange,
                                            ),
                                            new Text(
                                              '6 Days(Sunday- Closed)',
                                              style: new TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.green),
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
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                            style:
                                                TextStyle(color: Colors.black)),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                            style:
                                                TextStyle(color: Colors.black)),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  )
                                ],
                              ),

                              ////////////////////////////////////////////////////////////////////
                              SizedBox(height: 30.0),
                              Divider(
                                color: myGreen,
                                endIndent: width * 0.75,
                                indent: width * 0.005,
                                height: 8,
                                thickness: 3.0,
                              ),

                              ////////////////////Tiffen image section/////////////////////////////////
                              ExpansionTile(
                                title: new Text(
                                  "Tiffin  Images",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w600),
                                ),
                                trailing:
                                    Icon(Feather.arrow_down, color: myGreen),
                                leading: Icon(FlutterIcons.ios_photos_ion,
                                    color: myGreen),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: new Text(
                                      "Select Logo image for your Tiffin Service",
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: loadLogoImage,
                                    color: myGreen,
                                    child: new Text(
                                      "Select Logo Image",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  //Code for images
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: new Text(
                                      "Select Cover images for your Tiffin Service",
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: loadCoverImages,
                                    color: myGreen,
                                    child: new Text(
                                      "Select Cover Images",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  //Meal images code
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: new Text(
                                      "Select Meal images for your Tiffin Service",
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2),
                                    ),
                                  ),
                                  FlatButton(
                                    color: myGreen,
                                    onPressed: loadMenuImages,
                                    child: new Text(
                                      "Select Meal Images",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  )
                                ],
                              ),

                              /////////////////////////////////////////////////////////////////////
                              SizedBox(height: 30.0),
                              Divider(
                                color: myGreen,
                                endIndent: width * 0.75,
                                indent: width * 0.005,
                                height: 8,
                                thickness: 3.0,
                              ),

                              /////////////////////////////////////////////////////more info sectiom///////////////////
                              ExpansionTile(
                                title: new Text(
                                  "More Info",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w600),
                                ),
                                trailing:
                                    Icon(Feather.arrow_down, color: myGreen),
                                leading:
                                    Icon(MaterialIcons.payment, color: myGreen),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: new Text(
                                      "Do you have FSSAI License?",
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: new Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            new Radio(
                                              activeColor: Colors.green,
                                              value: 0,
                                              groupValue: licenseValue,
                                              onChanged:
                                                  _handleLicenseValueChange,
                                            ),
                                            new Text(
                                              'No',
                                              style: new TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            new Radio(
                                              activeColor: Colors.green,
                                              value: 1,
                                              groupValue: licenseValue,
                                              onChanged:
                                                  _handleLicenseValueChange,
                                            ),
                                            new Text(
                                              'Yes',
                                              style: new TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.green),
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
                                                  hintText:
                                                      "xxxxxxxxxxxxxxxxxxxx",
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
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
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8), //////
                                    child: new Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            new Radio(
                                              activeColor: Colors.green,
                                              value: 0,
                                              groupValue: paymentValue,
                                              onChanged:
                                                  _handlePaymentValueChange,
                                            ),
                                            new Text(
                                              'Cash On Delivery',
                                              style: new TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            new Radio(
                                              activeColor: Colors.green,
                                              value: 1,
                                              groupValue: paymentValue,
                                              onChanged:
                                                  _handlePaymentValueChange,
                                            ),
                                            new Text(
                                              'Online Payment',
                                              style: new TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            new Radio(
                                              activeColor: Colors.green,
                                              value: 2,
                                              groupValue: paymentValue,
                                              onChanged:
                                                  _handlePaymentValueChange,
                                            ),
                                            new Text(
                                              'Both (Cash + Online Payment)',
                                              style: new TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        paymentValue == 1
                                            ? Column(
                                                children: <Widget>[
                                                  TextFormField(
                                                    controller: upiController,
                                                    // validator: (val) {
                                                    //   if (val.isEmpty) {
                                                    //     return "enter your UPI id";
                                                    //   }
                                                    //   return null;
                                                    // },
                                                    decoration: InputDecoration(
                                                      labelText: "UPI ID",
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        bankAccountController,
                                                    validator: (val) {
                                                      if (val.isEmpty) {
                                                        return "enter your Bank Account no";
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Bank account no.",
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
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
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
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
                                                    // validator: (val) {
                                                    //   if (val.isEmpty) {
                                                    //     return "enter your UPI id";
                                                    //   }
                                                    //   return null;
                                                    // },
                                                    decoration: InputDecoration(
                                                      labelText: "UPI ID",
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        bankAccountController,
                                                    validator: (val) {
                                                      if (val.isEmpty) {
                                                        return "enter your Bank Account no";
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Bank account no.",
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
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
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: paytmController,
                                                    // validator: (val) {
                                                    //   if (val.isEmpty) {
                                                    //     return "enter your Paytm Number";
                                                    //   }
                                                    //   return null;
                                                    // },
                                                    decoration: InputDecoration(
                                                      labelText: "Paytm No.",
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
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
                                      "Do you offer Refund policy for subscription with refund?",
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
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
                                                  fontSize: 16.0,
                                                  color: Colors.green),
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
                                                  fontSize: 16.0,
                                                  color: Colors.green),
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
                                  SizedBox(
                                    height: 20.0,
                                  )
                                ],
                              ),

                              ///////////////////////////////////////////////////////////////////////////////

                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.03),
                                width: double.infinity,
                                child: RaisedButton(
                                  elevation: 5.0,
                                  onPressed: () async {
                                    await createTiffen();
                                  },
                                  padding: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: Colors.white,
                                  child: Text(
                                    'Update Tiffin',
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
                );
              }),
    );
  }

  Future<void> createTiffen() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      print(global.cost.toString());
      print(global.mealDescription.toString());

      setState(() {
        global.isLoading = true;
      });

      setState(() {
        foodCategoryResult =
            foodCategory.length == 2 ? 'Both' : foodCategory[0].toString();
      });

      if (global.mealDescription.length == 0 || global.cost.length == 0) {
        setState(() {
          global.isLoading = false;
        });
        DialogBox().information(
            context, 'Alert', 'Meal Description or Cost is not provided');
      } else if (logoImage.length == 0 ||
          coverImages.length != 4 ||
          menuImages.length < 4) {
        setState(() {
          global.isLoading = false;
        });
        DialogBox().information(context, 'Alert - Images missing',
            'Provide atleast 1 Logo image, 4 Cover Images, 4 Menu images');
      } else {
        if (license == "No") {
          licenseController.clear();
        }

        print(foodCategoryResult);
        Map<String, dynamic> tiffenInfo = {
          "Tiffen Name": tiffinController.text,
          "Email": email,
          "OwnerName": ownerNameController.text,
          "Address": addressController.text,
          "Phone": phoneController.text,
          "City": cityController.text,
          "CostPerMeal": double.parse(costController.text),
          "Food Category": foodCategoryResult,
          "Service Days": days,
          "FSSAI License": license,
          "FSSAI License Number": licenseController.text,
          "Payment Mode": payment,
          "UPI ID": upiController.text,
          // "Bank Account No.": bankAccountController.text,
          "IFSC code": ifscController.text,
          "Paytm Number": paytmController.text,
          "refundPolicy": sub,
          "BreakFast Time": "$breakFastTimefrom" + "-" "$breakFastTimeto",
          "Lunch Time": "$lunchTimefrom" + "-" "$lunchTimeto",
          "Dinner Time": "$dinnerTimefrom" + "-" "$dinnerTimeto",
          "Meal Description": global.mealDescription,
          "Meal Cost": global.cost,
          "Locality": [
            global.tiffenCentreLatitude,
            global.tiffenCentreLongitude
          ],
          "Tiffen Service Address": global.localityAddress,
        };
        _databaseService.updateTiffenInfo(tiffenInfo, email);
        await uploadCoverImages().whenComplete(() async {
          await uploadMenuImages().whenComplete(() async {
            await uploadLogoImage();
          });
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationScreen(
              index: 3,
            ),
          ),
        );
      }
    }
  }
}
