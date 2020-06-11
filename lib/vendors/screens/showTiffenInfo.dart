import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/screens/MyAppBar.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:foodieapp/vendors/widgets/tiffenContainer.dart';
import 'package:foodieapp/vendors/widgets/tiffenInfoWidget.dart';

class ShowTiffenInfo extends StatefulWidget {
  @override
  _ShowTiffenInfoState createState() => _ShowTiffenInfoState();
}

class _ShowTiffenInfoState extends State<ShowTiffenInfo> {
  Firestore firestore = Firestore.instance;

  // String tiffenName, email, ownerName, address, phone, city, cpm;
  // String foodCategory, serviceDays, fssaiLicense, fssaiLicenseNo, paymentMode;
  // String upiId,
  //     bankAcc,
  //     paytmNo,
  //     offerCancellationSub,
  //     breakFast,
  //     lunch,
  //     dinner,
  //     mealDesc,
  //     mealCost,
  //     ifscCode,
  //     tiffenAdd;

  // Future<List<DocumentSnapshot>> doc;
  // Future<void> getTiffenrInfo() async {
  //   // SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // String email = prefs.getString("currentUserEmail");
  //   firestore
  //       .collection("tiffen_service_details")
  //       .document("sahyogsaini.cse@gmail.com")
  //       .get()
  //       .then((DocumentSnapshot ds) {
  //     setState(() {
  //       address = ds['Address'];
  //       tiffenName = ds["Tiffen Name"];
  //       ownerName = ds['OwnerName'];
  //       address = ds['Address'];
  //       phone = ds['Phone'];
  //       city = ds['City'];
  //       cpm = ds['CostPerMeal'];
  //       foodCategory = ds['Food Category'];
  //       serviceDays = ds['Service Days'];
  //       fssaiLicense = ds['FSSAI License'];
  //       fssaiLicenseNo = ds['FSSAI License Number'];
  //       paymentMode = ds['Payment Mode'];
  //       upiId = ds['UPI ID'];
  //       bankAcc = ds['Bank Account No.'];
  //       paytmNo = ds['Paytm Number'];
  //       ifscCode = ds['IFSC code'];
  //       offerCancellationSub = ds['Offer cancellation Subscription'];
  //       breakFast = ds['BreakFast Time'];
  //       lunch = ds['Lunch Time'];
  //       dinner = ds['Dinner Time'];
  //       mealDesc= ds['Meal Description'];
  //       tiffenAdd = ds['Tiffen Service Address'];

  //     });
  //     print(address);
  //   });
  //   print(doc);
  // }

  @override
  void initState() {
    // getTiffenrInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore
          .collection("tiffen_service_details")
          .document("sahyogsaini.cse@gmail.com")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          var doc = snapshot.data;
          return Scaffold(
            appBar: PreferredSize(
                child: MyAppBar(), preferredSize: Size.fromHeight(60.0)),
            body: new ListView(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: new Text(
                    "Tiffene Information",
                    style: new TextStyle(
                        fontSize: 28.0,
                        color: myGreen,
                        fontWeight: FontWeight.w600,)
                  ),
                ),
                Expanded(
                  child: Container(
                    
                    child:  Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            tiffenInfo(
                                context: context,
                                title: "Tiffen Name",
                                data: doc['Tiffen Name']),
                            tiffenInfo(
                                context: context,
                                title: "Owner Name",
                                data: doc['OwnerName']),
                            tiffenInfo(
                                context: context,
                                title: "Address",
                                data: doc['Address']),
                            tiffenInfo(
                                context: context,
                                title: "Phone Number",
                                data: doc['Phone']),
                            tiffenInfo(
                                context: context,
                                title: "City",
                                data: doc['City']),
                            tiffenInfo(
                                context: context,
                                title: "Cost Per Meal",
                                data: 'Rs ${doc['CostPerMeal'].toString()}'),
                            tiffenInfo(
                                context: context,
                                title: "Food Category",
                                data: doc['Food Category']),
                            tiffenInfo(
                                context: context,
                                title: "Service Days",
                                data: doc['Service Days']),
                            tiffenInfo(
                                context: context,
                                title: "FSSAI License",
                                data: doc['FSSAI License']),
                            tiffenInfo(
                                context: context,
                                title: "FSSAI License Number",
                                data: doc['FSSAI License Number']),
                            tiffenInfo(
                                context: context,
                                title: "Payment Mode",
                                data: doc['Payment Mode']),
                            tiffenInfo(
                                context: context,
                                title: "UPI ID",
                                data: doc['UPI ID']),
                            tiffenInfo(
                                context: context,
                                title: "Bank account Number",
                                data: doc['Bank Account No.']),
                            tiffenInfo(
                                context: context,
                                title: "IFSC code",
                                data: doc['IFSC code']),
                            tiffenInfo(
                                context: context,
                                title: "Paytm number",
                                data: doc['Paytm number'].toString()),
                            tiffenInfo(
                                context: context,
                                title: "Offer Cancellation Subscription",
                                data: doc['Offer cancellation Subscription']),
                            tiffenInfo(
                                context: context,
                                title: "Breakfast Time",
                                data: doc['BreakFast Time']),
                            tiffenInfo(
                                context: context,
                                title: "Lunch Time",
                                data: doc['Lunch Time']),
                            tiffenInfo(
                                context: context,
                                title: "Dinner Time",
                                data: doc['Dinner Time']),
                            tiffenInfo(
                                context: context,
                                title: "Meal Description",
                                data: '${doc['Meal Description'].toString()}'),
                            tiffenInfo(
                                context: context,
                                title: "Meal Cost",
                                data: '${doc['Meal Cost'].toString()}'),
                            tiffenInfo(
                                context: context,
                                title: "Tiffen Address",
                                data: doc['Tiffen Service Address']),
                            tiffenInfo(
                                context: context,
                                title: "Rating",
                                data: doc['rating'].toString()),
                            tiffenInfo(
                                context: context,
                                title: "users given Ratings",
                                data: '${doc['no of ratings'].toString()}'),
                          ],
                        ),
                      ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
