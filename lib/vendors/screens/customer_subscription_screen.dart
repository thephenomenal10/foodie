import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/screens/MyAppBar.dart';
import 'package:foodieapp/vendors/screens/pos_screen.dart';

class CustomerSubscriptionsScreen extends StatelessWidget {
  final String customerName;
  CustomerSubscriptionsScreen(this.customerName);
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: MyAppBar(),
         preferredSize: Size.fromHeight(60.0)
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
                Text(
                  '$customerName',
                  style: TextStyle(
                    fontSize: height * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, ind) => GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => POSScreen(),
                  ),
                ),
                child: Card(
                  elevation: 5,
                  // margin: EdgeInsets.symmetric(
                  //   horizontal: 10,
                  //   vertical: 5,
                  // ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Subscription #${ind + 1}',
                      style: TextStyle(
                        fontSize: height * 0.03,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              itemCount: 7,
            ),
          ),
        ],
      ),
    );
  }
}