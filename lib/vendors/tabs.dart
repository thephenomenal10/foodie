import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/screens/account_screen.dart';
import 'package:foodieapp/vendors/screens/customer_orders_screen.dart';
import 'package:foodieapp/vendors/screens/HomePage.dart';



final tabs = [
  Center(child: Home()),
  Center(child: CustomerOrdersScreen()),
  Center(child: AccountScreen()),
];