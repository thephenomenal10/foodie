import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OrdersData {
  List<String> customerName = [
    "Customer name 1",
    "Customer name 2",
    "Customer name 3",
    "Customer name 4",
    "Customer name 5",
    "Customer name 6",
    "Customer name 7",
  ];

  List<String> customerAddress = [
    "Customer addrees 1",
    "Customer addrees 2",
    "Customer addrees 3",
    "Customer addrees 4",
    "Customer addrees 5",
    "Customer addrees 6",
    "Customer addrees 7",
  ];
  static var newFormat = DateFormat("yy-MM-dd");
  static var date = new DateTime(2020, 05, 25);
  static var lastDate = new DateTime(date.year, date.month, date.day - 2);
  List<String> ordersDate = [
    "${newFormat.format(DateTime.now())}",
    "${newFormat.format(lastDate)}",
    "${newFormat.format(lastDate)}",
    "${newFormat.format(lastDate)}",
    "${newFormat.format(lastDate)}",
    "${newFormat.format(lastDate)}",
    "${newFormat.format(lastDate)}",
  ];
}

class OrdersList {
  final orders;
  final DateTime date;
  OrdersList({this.orders, this.date});

  List<Map<String, dynamic>> getDayOrders() {
    List<Map<String, dynamic>> dayOrders = [];
    orders.forEach((element) {
      final DateTime endDate =
          element.data['endDate'].toDate().add(Duration(days: 1));
      final startDate = element.data['startDate'].toDate();
      if (!endDate.difference(date).isNegative &&
          !date.difference(startDate).isNegative) {
        var paused = false;
        paused =
            element.data['breakfastList'][date.difference(startDate).inDays];
        if (paused == null) {
          paused = false;
        }
        if (!paused) dayOrders.add(element.data);
      }
    });
    return dayOrders;
  }
}

class CustomerOrderDetails {
  static Future<List<Map<String, dynamic>>> getCustomers() async {
    List<Map<String, dynamic>> customers = [];
    List<String> ids = [];
    List<DocumentSnapshot> orderDocs = [];
    final email = (await FirebaseAuth.instance.currentUser()).email;
    orderDocs += [
      ...(await Firestore.instance
              .collection('tiffen_service_details/$email/acceptedOrders')
              .getDocuments())
          .documents
    ];
    orderDocs += [
      ...(await Firestore.instance
              .collection('tiffen_service_details/$email/pendingOrders')
              .getDocuments())
          .documents
    ];
    orderDocs += [
      ...(await Firestore.instance
              .collection('tiffen_service_details/$email/rejectedOrders')
              .getDocuments())
          .documents
    ];
    orderDocs += [
      ...(await Firestore.instance
              .collection('tiffen_service_details/$email/canceledOrders')
              .getDocuments())
          .documents
    ];
    orderDocs.forEach((element) {
      final data = {
        'customerId': element.data['customerId'],
        'customerName': element.data['customerName'],
        'customerAddress': element.data['customerAddress'],
        'vendorEmail': element.data['vendorEmail'],
      };
      if (!ids.contains(element.data['customerId'])) {
        ids.add(element.data['customerId']);
        customers.add(data);
      }
    });
    return customers;
  }
}
