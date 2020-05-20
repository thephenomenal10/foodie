import 'package:flutter/material.dart';

class MealSelect extends StatefulWidget {
  @override
  _MealSelectState createState() => _MealSelectState();
}

class _MealSelectState extends State<MealSelect> {
  int selectedMeal = 0;
  int selectedTime = 0;

  void setSelectedMeal(int val) {
    setState(() {
      selectedMeal = val;
    });
  }

  void setSelectedTime(int val) {
    setState(() {
      selectedTime = val;
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

  Widget radioButton({
    @required int val,
    @required int grpval,
    @required Function function,
    @required String title,
    @required double size,
    @required FontWeight weight,
  }) {
    return Row(
      children: <Widget>[
        Radio(
          value: val,
          groupValue: grpval,
          onChanged: (val) => function(val),
          activeColor: Theme.of(context).primaryColor,
        ),
        text(
          title,
          size,
          weight,
        ),
      ],
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
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          text('Meal Type:', 18, FontWeight.w500),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                radioButton(
                  val: 0,
                  grpval: selectedMeal,
                  function: setSelectedMeal,
                  title: 'Veg',
                  size: 20,
                  weight: FontWeight.bold,
                ),
                radioButton(
                  val: 1,
                  grpval: selectedMeal,
                  function: setSelectedMeal,
                  title: 'Non-Veg',
                  size: 20,
                  weight: FontWeight.bold,
                ),
              ],
            ),
          ),
          text('Meal Time:', 18, FontWeight.w500),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                radioButton(
                  val: 0,
                  grpval: selectedTime,
                  function: setSelectedTime,
                  title: 'Breakfast',
                  size: 20,
                  weight: FontWeight.bold,
                ),
                radioButton(
                  val: 1,
                  grpval: selectedTime,
                  function: setSelectedTime,
                  title: 'Lunch',
                  size: 20,
                  weight: FontWeight.bold,
                ),
                radioButton(
                  val: 2,
                  grpval: selectedTime,
                  function: setSelectedTime,
                  title: 'Dinne',
                  size: 20,
                  weight: FontWeight.bold,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
