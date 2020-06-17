import 'package:flutter/material.dart';
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
          return ListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 3,
            ),
            itemBuilder: (context, ind) => Card(
              elevation: 6.0,
              child: ListTile(
                leading: Image.asset(
                  "assets/my1.png",
                  fit: BoxFit.contain,
                ),
                title: Text(
                  customers[ind]['customerName'],
                  style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: height * 0.03,
                  ),
                ),
                subtitle: Text(
                  customers[ind]['customerAddress'],
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
                          customers[ind]['customerName'],
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
            ),
            itemCount: customers.length,
          );
        },
      ),
    );
  }
}
