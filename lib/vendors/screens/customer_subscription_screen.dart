import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/screens/MyAppBar.dart';
import 'package:foodieapp/vendors/widgets/customer_orders.dart';

class CustomerSubscriptionsScreen extends StatelessWidget {
  final String id;
  final String customerName;
  final String customerPhone;
  final String vendorEmail;
  CustomerSubscriptionsScreen(
    this.id,
    this.customerName,
    this.customerPhone,
    this.vendorEmail,
  );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: MyAppBar(),
        preferredSize: Size.fromHeight(60.0),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            height: 0.07 * height,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Customer name :',
                  style: TextStyle(
                    fontSize: height * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    '$customerName',
                    style: TextStyle(
                      fontSize: height * 0.03,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: CustomerOrders(id, vendorEmail,customerPhone),
            ),
          ),
        ],
      ),
    );
  }
}
