import 'package:flutter/material.dart';

class POSScreen extends StatelessWidget {
  final String mealType = 'Veg';
  final int skippedMeals = 10;
  final int totalMeals = 10;
  final double mealCost = 49;

  Widget titleText(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Widget valueText(String value){
    return Text(
      value,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('POS'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Meal Type:'),
                valueText(mealType),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Total skipped meals:'),
                valueText('$skippedMeals'),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Total meals:'),
                valueText('$totalMeals'),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                titleText('Total price:'),
                valueText('${totalMeals * mealCost}'),
              ],
            ),
            SizedBox(height: 10,),
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
    );
  }
}
