import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/screens/customer_subscriptions_screen.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';
import 'package:foodieapp/vendors/widgets/ordersData.dart';

class VendorUsersScreen extends StatelessWidget {
  final ordersData = new OrdersData();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Customers'),
      ),
      body: ListView.builder(
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
              ordersData.customerName[ind],
              style: TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: height * 0.03,
              ),
            ),
            subtitle: Text(
              ordersData.customerAddress[ind],
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
                      ordersData.customerName[ind],
                    ),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: height*0.11,
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
        itemCount: ordersData.customerName.length,
      ),
    );
  }
}
