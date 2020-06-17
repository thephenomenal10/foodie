import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/utils/primaryColor.dart';

import 'MyAppBar.dart';

class PaymentSumm extends StatefulWidget {
  final String paymentProof;

  const PaymentSumm({Key key, this.paymentProof}) : super(key: key);
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
          children: [
            Container(
                margin: EdgeInsets.all(20.0),
                height: MediaQuery.of(context).size.height / 1,
                child: Image(image: NetworkImage(widget.paymentProof))),
          ],
        ));
  }
}
