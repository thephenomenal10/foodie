import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';

import 'MyAppBar.dart';

class PaymentSumm extends StatefulWidget {
  @override
  _PaymentSummState createState() => _PaymentSummState();
}

class _PaymentSummState extends State<PaymentSumm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: MyAppBar(),
            preferredSize: Size.fromHeight(60.0),
        ),
        body: new ListView(
            children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 20.0, top: 20.0),
                    child: new Text(
                        "Payment Summary",
                        style: new TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 25.0),
                    ),
                ),
                Divider(
                    thickness: 2.0,
                    indent: 20.0,
                    endIndent: 20.0,
                    color: Colors.grey.shade300,
                ),
                Container(
                  child: Column(
                      children: <Widget>[
                          Container(
                              child: DataTable(
                                  columns: [
                                      DataColumn(
                                          label: new Text("Product",style: new TextStyle(color: secondaryColor, fontSize: 20.0, fontWeight: FontWeight.w400),)
                                      ),
                                      DataColumn(
                                          label: new Text("Item",style: new TextStyle(color: secondaryColor, fontSize: 20.0, fontWeight: FontWeight.w400),)
                                      ),
                                      DataColumn(
                                          label: new Text("Price",style: new TextStyle(color: secondaryColor, fontSize: 20.0, fontWeight: FontWeight.w400),)
                                      ),
                                      DataColumn(
                                          label: new Text("Total",style: new TextStyle(color: secondaryColor, fontSize: 20.0, fontWeight: FontWeight.w400),)
                                      )
,                                  ],
                                   rows: [
                                       DataRow(
                                           cells: <DataCell>[
                                               DataCell( Text("Rice")),
                                               DataCell( Text("2")),
                                               DataCell( Text("50")),
                                               DataCell( Text("100"))
                                           ]
                                       ),
                                       DataRow(
                                           cells: <DataCell>[
                                               DataCell( Text("Daal")),
                                               DataCell( Text("2")),
                                               DataCell( Text("50")),
                                               DataCell( Text("100"))
                                           ]
                                       ),
                                       DataRow(
                                           cells: <DataCell>[
                                               DataCell( Text("Fry Rice")),
                                               DataCell( Text("2")),
                                               DataCell( Text("100")),
                                               DataCell( Text("200"))
                                           ]
                                       ),
                                       DataRow(
                                           cells: <DataCell>[
                                               DataCell( Text("Rayata")),
                                               DataCell( Text("1")),
                                               DataCell( Text("30")),
                                               DataCell( Text("30"))
                                           ]
                                       ),
                                       DataRow(
                                           cells: <DataCell>[
                                               DataCell( Text("")),
                                               DataCell( Text("")),
                                               DataCell( Text("Subtototal")),
                                               DataCell( Text("460",style: new TextStyle(color: secondaryColor, fontSize: 20.0, fontWeight: FontWeight.w500),))
                                           ]
                                       )
                                   ]
                              ),
                          ),
                          SizedBox(height: 20.0,),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                      RaisedButton(
                                          color: primaryColor,
                                          onPressed: () {
                                              Navigator.push(
                                                  context, MaterialPageRoute(
                                                  builder: (context) => PaymentSumm())
                                              );
                                          },
                                          child: new Text("POS"),
                                      ),
                                  ],
                              ),
                          )
                      ],
                  ),
                )
            ],
        ),
    );
  }
}
