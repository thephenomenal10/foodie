import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/widgets/meal_select.dart';
import 'package:foodieapp/vendors/widgets/subscription.dart';

class CheckoutSubscribe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(200, 70),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: Text(
                        'CHECKOUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    MealSelect(),
                    SizedBox(
                      height: 10,
                    ),
                    Subscription(),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      title: Text(
                        'Order Notes:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        '\"Any suggestions, we will pass it on.....\"',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 3,
                  right: 3,
                  bottom: 5,
                ),
                child: FloatingActionButton.extended(
                  label: Text(
                    'PAYMENT',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {},
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
