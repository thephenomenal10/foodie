import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foodieapp/vendors/screens/MyAppBar.dart';
import 'package:foodieapp/vendors/screens/customer_subscription_screen.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:foodieapp/vendors/widgets/ordersData.dart';

class CustomerOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: MyAppBar(),
        preferredSize: Size.fromHeight(60.0),
      ),
      body: FutureBuilder(
        future: CustomerOrderDetails.getCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          }
          final customers = snapshot.data;
          if (customers.length == 0) {
            return Column(
              children: <Widget>[
                SizedBox(
                  child: Image.asset(
                    "assets/empty_sub.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    'No Customers!',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 3,
            ),
            itemBuilder: (context, ind) => StreamBuilder(
              stream: Firestore.instance
                  .collection('customer_collection')
                  .document('${customers[ind]['customerId']}').snapshots(),
              builder: (context, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                }
                return Card(
                  elevation: 6.0,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/my1.png",
                      fit: BoxFit.contain,
                    ),
                    title: Text(
                      streamSnapshot.data['name'],
                      style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: height * 0.03,
                      ),
                    ),
                    subtitle: Text(
                      streamSnapshot.data['address text'],
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: height * 0.025,
                      ),
                    ),
                    trailing: RaisedButton(
                      color: primaryColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerSubscriptionsScreen(
                              customers[ind]['customerId'],
                              streamSnapshot.data['name'],
                              customers[ind]['vendorEmail'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: height * 0.11,
                        width: width * 0.22,
                        child: Text(
                          "Show Subscription",
                          style: TextStyle(fontSize: width * 0.0385),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            itemCount: customers.length,
          );
        },
      ),
    );
  }
}
