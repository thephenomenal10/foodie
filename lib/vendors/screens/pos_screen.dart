import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';

import 'MyAppBar.dart';
import 'PaymentSummary.dart';

class POSScreen extends StatelessWidget {
  final String mealType;
  final int skippedMeals;
  final int totalMeals;
  final double mealCost;

  final String name;
  final String address;
  final int subscriptionDays;
  final String orderId;
  final double customerLatitude, customerLongitude;
  final String paymentMode, orderSuggestion, proofOfPayment, mealDescription;

  const POSScreen({
    Key key,
    this.mealType,
    this.skippedMeals,
    this.totalMeals,
    this.mealCost,
    this.name,
    this.address,
    this.subscriptionDays,
    this.orderId,
    this.customerLatitude,
    this.customerLongitude,
    this.paymentMode,
    this.orderSuggestion,
    this.proofOfPayment,
    this.mealDescription,
  }) : super(key: key);

  Widget titleText(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget valueText(String value) {
    return Text(
      value,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: MyAppBar(),
        preferredSize: Size.fromHeight(60.0),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Customer Name:'),
                valueText(name),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Customer Address:'),
                valueText(address),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Contact:'),
                valueText("243523"),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Meal Type:'),
                valueText(mealType),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Meal Description:'),
                valueText(mealDescription),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Total skipped meals:'),
                valueText('$skippedMeals'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Total meals:'),
                valueText('$totalMeals'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Suggestion:'),
                valueText(orderSuggestion == "" ? "Nothing" : orderSuggestion),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Payment Mode:'),
                valueText(paymentMode),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Total price:'),
                valueText('${totalMeals * mealCost}'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Price of each meal:'),
                valueText('\u20B9$mealCost/meal'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          child: Row(
        children: <Widget>[
          Expanded(
            child: new ListTile(
              title: new Text(
                "Total:",
                style: new TextStyle(
                    color: primaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: valueText(
                '${totalMeals * mealCost}',
              ),
            ),
          ),
          paymentMode != 'Cash On Delivery'
              ? Expanded(
                  child: new MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PaymentSumm(paymentProof: proofOfPayment)));
                    },
                    color: primaryColor,
                    child: new Text(
                      "Payment Proof",
                      style: new TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      )),
    );
  }
}
