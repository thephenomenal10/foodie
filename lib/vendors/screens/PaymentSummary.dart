import 'package:flutter/material.dart';

import 'MyAppBar.dart';

class PaymentSumm extends StatefulWidget {
  final order;

  PaymentSumm({this.order});
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
          widget.order['proofOfPayment'] != null
              ? Container(
                  margin: EdgeInsets.all(20.0),
                  height: MediaQuery.of(context).size.height / 1,
                  child: Image(
                    image: NetworkImage(
                      widget.order['proofOfPayment'],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
