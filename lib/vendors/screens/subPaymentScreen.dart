import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:io';

import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/widgets/popUpPayment.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

/*
example payment screen
*/

class PaymentScreen extends StatefulWidget {
  final String vendorEmail;

  const PaymentScreen({Key key, this.vendorEmail}) : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedPaymentOption = 0;
  int mode;
  DateTime startDate;
  DateTime initialDate;

///////////////////////////////////////////////
  List<Asset> proofImages = List<Asset>();
  String proofImageUrl;
  String _error = 'No Error Dectected';
  bool isUploading = false;

  Future<void> loadProofImages() async {
    List<Asset> resultList = List<Asset>();

    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: proofImages,
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
      proofImages = resultList;
      _error = error;
    });
  }

  Future uploadProofImages() async {
    try {
      for (int i = 0; i < proofImages.length; i++) {
        final StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child("vendor_images")
            .child("PaymentProof_images")
            .child(widget.vendorEmail)
            .child("proof_image_${i + 1}");
        final StorageUploadTask uploadTask = storageReference
            .putData((await proofImages[i].getByteData()).buffer.asUint8List());

        final StreamSubscription<StorageTaskEvent> streamSubscription =
            uploadTask.events.listen((event) {
          print("EVENT ${event.type}");
        });

        await uploadTask.onComplete;
        streamSubscription.cancel();

        String proofImageUrl = await storageReference.getDownloadURL();

        Firestore.instance
            .collection("tiffen_service_details")
            .document(widget.vendorEmail)
            .updateData({'Proof of Payment Photos': proofImageUrl});
      }
    } catch (e) {
      print(e.message);
    }
  }

  /////////////////////////////////////////////

  Widget payText(String text) {
    return Text(
      text,
      textScaleFactor: 1.2,
      style: TextStyle(
        color: Colors.black87,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget radioButton({
    @required int val,
    @required int grpval,
    @required String title,
  }) {
    return Row(
      children: <Widget>[
        Radio(
          value: val,
          groupValue: grpval,
          onChanged: (val) {
            setState(() {
              selectedPaymentOption = val;
            });
          },
          activeColor: myGreen,
        ),
        payText(title),
      ],
    );
  }

  Widget onlinePayment() {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
              radius: 15.0,
              backgroundColor: Colors.white,
              child: Icon(AntDesign.bank, color: Colors.black,),
            ),
            
            Text(
              "Bank Account Number",
              textScaleFactor: 1.1,
              style: TextStyle(
                color: Colors.black54,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "acc no",
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.black87,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
              radius: 15.0,
              backgroundColor: Colors.white,
              child: Image(image: AssetImage("assets/paytm.png")),
            ),
            Text(
              "paytm Number",
              textScaleFactor: 1.1,
              style: TextStyle(
                color: Colors.black54,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "paytm no",
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.black87,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
              radius: 15.0,
              backgroundColor: Colors.white,
              child: Image(image: AssetImage("assets/phone-pe.png")),
            ),
            Text(
              "Phone pay",
              textScaleFactor: 1.1,
              style: TextStyle(
                color: Colors.black54,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "phone pay no",
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.black87,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
              radius: 15.0,
              backgroundColor: Colors.white,
              child: Image(image: AssetImage("assets/Google-Pay.png")),
            ),
            Text(
              "Google pay",
              textScaleFactor: 1.1,
              style: TextStyle(
                color: Colors.black54,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "google pay no",
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.black87,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Icon(Icons.attach_money, color: myGreen,),
            CircleAvatar(
              radius: 15.0,
              backgroundColor: Colors.white,
              child: Image(image: AssetImage("assets/paytm.png")),
            ),
            Text(
              "UPI id",
              textScaleFactor: 1.1,
              style: TextStyle(
                color: Colors.black54,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "upi id",
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.black87,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.01,
        ),
        textPlusUnderline(
          'Proof of Payment',
          height,
        ),
        greenDivider(width),
        SizedBox(
          height: height * 0.01,
        ),
        RaisedButton(
          onPressed: () {
            loadProofImages();
          },
          child: Text(
            "UPLOAD IMAGE",
            textScaleFactor: 0.8,
            style: TextStyle(
              letterSpacing: 1.3,
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget paymentOption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        payText("Online Payment"),
      ],
    );
  }

  Widget textPlusUnderline(String title, double height) {
    return Padding(
      padding: EdgeInsets.only(
        top: height * 0.02,
      ),
      child: Text(
        title,
        style: TextStyle(
          letterSpacing: 0.3,
          fontWeight: FontWeight.bold,
          fontSize: height * 0.021,
        ),
      ),
    );
  }

  Widget payOption(String label, String option) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          textScaleFactor: 1.1,
          style: TextStyle(
            color: Colors.black54,
            letterSpacing: 1.1,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          option,
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.black87,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget greenDivider(width) => Divider(
        color: myGreen,
        thickness: 2,
        indent: width * 0.01,
        endIndent: width * 0.78,
      );

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 150,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: myGreen,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        )),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          color: Colors.white,
                          iconSize: 30.0,
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          "SUBSCRIPTION PAYMENT",
                          textScaleFactor: 1.5,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        textPlusUnderline(
                          'Subscription Details',
                          height,
                        ),
                        greenDivider(width),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        payOption("Cancellation Policy", "No"),
                        payOption("Total Cost", "₹ " + "199"),
                        payOption("Subscription", "364" + " days"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Start Date",
                              textScaleFactor: 1.1,
                              style: TextStyle(
                                color: Colors.black54,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  DateFormat.yMMMd().format(DateTime.now()),
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        textPlusUnderline(
                          'Payment Options',
                          height,
                        ),
                        greenDivider(width),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        paymentOption(),
                        onlinePayment(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: width * 0.07,
              top: height * 0.01,
            ),
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            alignment: Alignment.center,
            child: proofImages != null
                ? InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> PopUpPayment()));
                    },
                    child: Container(
                      height: height * 0.067,
                      width: width * 0.39,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: myGreen,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'CONFIRM',
                        style: TextStyle(
                          letterSpacing: 0.3,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: height * 0.021,
                        ),
                      ),
                    ),
                  )
                : (proofImages == null
                    ? Text(
                        "Please upload the image.",
                        textScaleFactor: 1,
                        style: TextStyle(
                          letterSpacing: 1.2,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          PopUpPayment();
                        },
                        child: Container(
                          height: height * 0.067,
                          width: width * 0.39,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: myGreen,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'CONFIRdcleM',
                            style: TextStyle(
                              letterSpacing: 0.3,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.021,
                            ),
                          ),
                        ),
                      )),
          ),
        ],
      ),
    );
  }
}
