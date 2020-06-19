import 'package:flutter/material.dart';

import 'MyAppBar.dart';

class PaymentSumm extends StatefulWidget {
  final String paymentProof;

  PaymentSumm({this.paymentProof});
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
      body: widget.paymentProof != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Proof of Payment',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(20.0),
                    height: MediaQuery.of(context).size.height / 1,
                    child: Image(
                      image: NetworkImage(
                        widget.paymentProof,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
