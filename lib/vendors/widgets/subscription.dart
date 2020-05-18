import 'package:flutter/material.dart';

class Subscription extends StatefulWidget {
  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  int selectedSubscription = 0;

  void setSelected(int val) {
    setState(() {
      selectedSubscription = val;
    });
  }

  Widget text(String title, double size, FontWeight weight) {
    return Text(
      title,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
      ),
    );
  }

  Widget radioButtonTile({
    @required int val,
    @required int grpval,
    @required Function function,
    @required String title,
    @required String subtitle,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: 5,
        right: 5,
        top: 5,
      ),
      trailing: Radio(
        value: val,
        groupValue: grpval,
        onChanged: (val) => function(val),
        activeColor: Theme.of(context).primaryColor,
      ),
      title: text(
        title,
        22,
        FontWeight.bold,
      ),
      subtitle: text(
        subtitle,
        13,
        FontWeight.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            text('Subscription type:', 20, FontWeight.w500),
            radioButtonTile(
              val: 0,
              grpval: selectedSubscription,
              function: setSelected,
              title: '3-Days Subscription',
              subtitle: 'Rs 49/meal',
            ),
            radioButtonTile(
              val: 1,
              grpval: selectedSubscription,
              function: setSelected,
              title: '7-Days Subscription',
              subtitle: 'Rs 49/meal',
            ),
            radioButtonTile(
              val: 2,
              grpval: selectedSubscription,
              function: setSelected,
              title: '14-Days Subscription',
              subtitle: 'Rs 49/meal',
            ),
            radioButtonTile(
              val: 3,
              grpval: selectedSubscription,
              function: setSelected,
              title: '28-Days Subscription',
              subtitle: 'Rs 49/meal | 2 Mealbox Free',
            ),
          ],
        ),
      ),
    );
  }
}
