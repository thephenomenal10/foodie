import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/bottomNavigationBar.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/widgets/dialogBox.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProofOfPayment extends StatefulWidget {
  final String vendorEmail;

  const ProofOfPayment({Key key, this.vendorEmail}) : super(key: key);
  @override
  _ProofOfPaymentState createState() => _ProofOfPaymentState();
}

class _ProofOfPaymentState extends State<ProofOfPayment> {
  List<Asset> proofImages = List<Asset>();
  List<String> proofImageUrls = <String>[];
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

        String imageUrl = await storageReference.getDownloadURL();

        proofImageUrls.add(imageUrl.toString());
        Firestore.instance
            .collection("tiffen_service_details")
            .document(widget.vendorEmail)
            .updateData({'Proof of Payment Photos': proofImageUrls});
      }
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 4.3,
            ),
            Container(
              child: new Text(
                "Please upload Proof of Payment",
                style: new TextStyle(color: myGreen, fontSize: 25),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width / 1.6,
              child: RaisedButton(
                onPressed: () async {
                  await loadProofImages().whenComplete(() async {
                    await uploadProofImages().whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavigationScreen()));
                      DialogBox().information(
                          context, "Success", "Your have Login successfully");
                    });
                  });
                },
                child: Text(
                  'Upload',
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
