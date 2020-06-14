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
      final DateTime endDate = element.data['endDate'].toDate();
      final startDate = element.data['startDate'].toDate();
      if (!endDate.difference(date).isNegative &&
          !date.difference(startDate).isNegative) {
        dayOrders.add(element.data);
      }
    });
    return dayOrders;
  }
}
