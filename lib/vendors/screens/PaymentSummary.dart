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
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height*0.75,
                  margin: EdgeInsets.all(20.0),
                  child: Image(
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      );
                    },
                    image: NetworkImage(
                      widget.paymentProof,
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
