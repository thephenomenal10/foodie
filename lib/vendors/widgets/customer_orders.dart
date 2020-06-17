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

Widget _columnOfOrdersWidgets(String path, String email) {
  return StreamBuilder(
    stream: Firestore.instance.collection(path).getDocuments().asStream(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container();
      }
      final List<DocumentSnapshot> docs = snapshot.data.documents;
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
                        Text('SUBSCRIPTION:'),
                        Text(
                          '${DateFormat('MMM d, yyyy').format(docs[index].data['startDate'].toDate())}\t' +
                              'to' +
                              '\t${DateFormat('MMM d, yyyy').format(docs[index].data['endDate'].toDate())}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
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
                            mealCost: docs[index].data['mealCost'],
                            mealType: docs[index].data['foodType'],
                            skippedMeals: docs[index].data['skips'],
                            totalMeals: totalMeals.toInt(),
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

  CustomerOrders(this.id, this.email);

  @override
  _CustomerOrdersState createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  Widget _getOptionButton({
    String title,
    IconData icon,
    Function onPressed,
    bool selected = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AcceptedList(widget.id, widget.email),
            PendingList(widget.id, widget.email),
            CancelledList(widget.id, widget.email),
            RejectedList(widget.id, widget.email),
          ],
        ),
      ),
    );
  }
}

class AcceptedList extends StatefulWidget {
  final id;
  final email;
  AcceptedList(this.id, this.email);
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
              )
            : Container(),
      ],
    );
  }
}

class PendingList extends StatefulWidget {
  final id;
  final email;
  PendingList(this.id, this.email);
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
              )
            : Container(),
      ],
    );
  }
}

class CancelledList extends StatefulWidget {
  final id;
  final email;
  CancelledList(this.id, this.email);
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
                widget.email)
            : Container(),
      ],
    );
  }
}

class RejectedList extends StatefulWidget {
  final id;
  final email;
  RejectedList(this.id, this.email);
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
              )
            : Container(),
      ],
    );
  }
}
