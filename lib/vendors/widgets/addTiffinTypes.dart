import 'globalVariable.dart' as global;
import 'package:flutter/material.dart';

class AddTiffinTypes extends StatefulWidget {
  @override
  _AddTiffinTypesState createState() => _AddTiffinTypesState();
}

class _AddTiffinTypesState extends State<AddTiffinTypes> {
  final _formKey = GlobalKey<FormState>();
  // List<String> mealDescription = [];
  // List<String> cost = [];
  final mealController = TextEditingController();
  final costController = TextEditingController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    print(global.mealDescription.length);
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 50 * (global.mealDescription.length).toDouble(),
            child: ListView.builder(
              key: ValueKey(index),
              itemCount: global.mealDescription.length,
              itemBuilder: (BuildContext context, int ind) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        initialValue: global.mealDescription[ind],
                        autovalidate: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'provide description';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          global.mealDescription[ind] = value;
                        },
                      ),
                    ),
                    SizedBox(width: width * 0.05),
                    SizedBox(
                      width: width * 0.20,
                      child: TextFormField(
                        initialValue: global.cost[ind],
                        autovalidate: true,
                        decoration: InputDecoration(prefixText: '\u20B9 '),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'provide cost';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          global.cost[ind] = value;
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: mealController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'provide description';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Meal description',
                    hintText: 'Ex: 6 chapati\'s + curd',
                  ),
                ),
              ),
              SizedBox(width: width * 0.05),
              SizedBox(
                width: width * 0.20,
                child: TextFormField(
                  controller: costController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'provide cost';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Cost',
                    hintText: 'Ex: 49',
                    prefixText: '\u20B9 ',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          RaisedButton.icon(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                setState(() {
                  global.mealDescription.add(mealController.text);
                  global.cost.add(costController.text);
                });

                print(global.mealDescription);
                print(global.cost);
                setState(() {
                  mealController.clear();
                  costController.clear();
                });
              }
            },
            icon: Icon(Icons.add),
            label: Text('Add'),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
