import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/screens/pos_screen.dart';
import 'package:intl/intl.dart';

Widget _getOptionButton({
  String title,
  IconData icon,
  Function onPressed,
  bool selected = false,
  BuildContext context,
}) {
  return ListTile(
    leading: Icon(
      icon,
      color: Theme.of(context).primaryColor,
    ),
    title: Text(
      title,
      style: TextStyle(
        color: selected ? Theme.of(context).primaryColor : Colors.black,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    ),
    trailing: IconButton(
      icon: selected
          ? Icon(
              Icons.keyboard_arrow_up,
              color: Theme.of(context).primaryColor,
            )
          : Icon(Icons.keyboard_arrow_down),
      onPressed: onPressed,
    ),
  );
}

Widget _columnOfOrdersWidgets(String path, String email,String phone) {
  return StreamBuilder(
    stream: Firestore.instance.collection(path).getDocuments().asStream(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container();
      }
      final List<DocumentSnapshot> docs = snapshot.data.documents;
      if (docs.length == 0) {
        return Column(
          children: <Widget>[
            SizedBox(
              child: Image.asset(
                "assets/empty_sub.png",
                fit: BoxFit.contain,
              ),
            ),
            Container(
              height: 30,
              alignment: Alignment.center,
              child: Text(
                'No Orders!',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        itemCount: docs.length,
        itemBuilder: (context, index) {
          if (docs[index].data['vendorEmail'] == email) {
            final double totalMeals =
                docs[index].data['totalCost'] / docs[index].data['mealCost'];
            return Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 2.0,
                  )
                ],
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 3,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(child: Text('SUBSCRIPTION:')),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            '${DateFormat('MMM d, yyyy').format(docs[index].data['startDate'].toDate())}\t' +
                                'to' +
                                '\t${DateFormat('MMM d, yyyy').format(docs[index].data['endDate'].toDate())}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => POSScreen(
                            phone: phone,
                            mealCost: docs[index].data['mealCost'],
                            mealType: docs[index].data['foodType'],
                            skippedMeals: docs[index].data['skips'],
                            totalMeals: totalMeals.toInt(),
                            address: docs[index].data['customerAddress'],
                            customerLatitude:
                                docs[index].data['customerCoordinates'][0],
                            customerLongitude:
                                docs[index].data['customerCoordinates'][1],
                            mealDescription:
                                docs[index].data['mealDescription'],
                            name: docs[index].data['customerName'],
                            orderSuggestion: docs[index].data['orderNotes'],
                            paymentMode: docs[index].data['paymentMode'],
                            proofOfPayment: docs[index].data['proofOfPayment'],
                            subscriptionDays:
                                docs[index].data['subscriptionDays'],
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.subscriptions,
                      size: 15,
                    ),
                    label: Text(
                      'Order details',
                      style: TextStyle(fontSize: 15),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
        physics: ScrollPhysics(
          parent: NeverScrollableScrollPhysics(),
        ),
      );
    },
  );
}

class CustomerOrders extends StatefulWidget {
  final id;
  final email;
  final phone;

  CustomerOrders(this.id, this.email, this.phone);

  @override
  _CustomerOrdersState createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AcceptedList(widget.id, widget.email, widget.phone),
            PendingList(widget.id, widget.email, widget.phone),
            CancelledList(widget.id, widget.email, widget.phone),
            RejectedList(widget.id, widget.email, widget.phone),
          ],
        ),
      ),
    );
  }
}

class AcceptedList extends StatefulWidget {
  final id;
  final email;
  final phone;
  AcceptedList(this.id, this.email, this.phone);
  @override
  _AcceptedListState createState() => _AcceptedListState();
}

class _AcceptedListState extends State<AcceptedList> {
  bool _selectAccept = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _getOptionButton(
          title: 'Accepted',
          icon: Icons.done_all,
          selected: _selectAccept,
          context: context,
          onPressed: () {
            setState(() {
              _selectAccept = !_selectAccept;
            });
          },
        ),
        _selectAccept
            ? _columnOfOrdersWidgets(
                'customer_collection/${widget.id}/acceptedOrders',
                widget.email,
                widget.phone,
              )
            : Container(),
      ],
    );
  }
}

class PendingList extends StatefulWidget {
  final id;
  final email;
  final phone;

  PendingList(this.id, this.email, this.phone);
  @override
  _PendingListState createState() => _PendingListState();
}

class _PendingListState extends State<PendingList> {
  bool _selectPending = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _getOptionButton(
          title: 'Pending',
          icon: Icons.history,
          selected: _selectPending,
          context: context,
          onPressed: () {
            setState(() {
              _selectPending = !_selectPending;
            });
          },
        ),
        _selectPending
            ? _columnOfOrdersWidgets(
                'customer_collection/${widget.id}/pendingOrders',
                widget.email,
                widget.phone,
              )
            : Container(),
      ],
    );
  }
}

class CancelledList extends StatefulWidget {
  final id;
  final email;
  final phone;

  CancelledList(this.id, this.email, this.phone);
  @override
  _CancelledListState createState() => _CancelledListState();
}

class _CancelledListState extends State<CancelledList> {
  bool _selectCancel = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _getOptionButton(
          title: 'Cancelled',
          icon: Icons.cancel,
          selected: _selectCancel,
          context: context,
          onPressed: () {
            setState(() {
              _selectCancel = !_selectCancel;
            });
          },
        ),
        _selectCancel
            ? _columnOfOrdersWidgets(
                'customer_collection/${widget.id}/cancelledOrders',
                widget.email,
                widget.phone,
              )
            : Container(),
      ],
    );
  }
}

class RejectedList extends StatefulWidget {
  final id;
  final email;
  final phone;

  RejectedList(this.id, this.email, this.phone);
  @override
  _RejectedListState createState() => _RejectedListState();
}

class _RejectedListState extends State<RejectedList> {
  bool _selectReject = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _getOptionButton(
          title: 'Rejected',
          icon: Icons.report,
          selected: _selectReject,
          context: context,
          onPressed: () {
            setState(() {
              _selectReject = !_selectReject;
            });
          },
        ),
        _selectReject
            ? _columnOfOrdersWidgets(
                'customer_collection/${widget.id}/rejectedOrders',
                widget.email,
                widget.phone,
              )
            : Container(),
      ],
    );
  }
}
