import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class LocalNotifications {
  static Future<void> storeFCMToken(String email) async {
    final token = await FirebaseMessaging().getToken();
    print(token);
    var reference = Firestore.instance
        .collection('vendor_collection/vendors/registered_vendors')
        .document(email);
    List<String> fcmTokens = (await reference.get()).data['fcmTokens'] == null
        ? []
        : [...(await reference.get()).data['fcmTokens']];
    if (!fcmTokens.contains(token)) {
      fcmTokens.add(token);
    }
    await reference.updateData({'fcmTokens': fcmTokens});
  }

  static Future<void> _initializeNotiication() async {
    var android = AndroidInitializationSettings('mipmap/ic_launcher');
    var platform = InitializationSettings(android, null);
    flutterLocalNotificationsPlugin.initialize(platform);
  }

  static Future<void> showNotification(Map<String, dynamic> message) async {
    await _initializeNotiication();
    var android = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription');
    var platform = NotificationDetails(android, null);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platform,
    );
  }

  static Future<void> showScheduledNotification() async {
    await cancelAllNotification();
    await _initializeNotiication();
    try {
      final email = (await FirebaseAuth.instance.currentUser()).email;
      final endDate = DateTime.parse(((await Firestore.instance
              .collection('tiffen_service_details')
              .document(email)
              .get())
          .data['SubscriptionEndDate']));
      var android = AndroidNotificationDetails(
          'channelId', 'channelName', 'channelDescription');
      var platform = NotificationDetails(android, null);
      print(DateTime.now().add(Duration(minutes: 3)));
      if (!endDate
          .difference(DateTime.now().add(Duration(days: 1, hours: 6)))
          .isNegative) {
        await flutterLocalNotificationsPlugin.schedule(
          1,
          'your subscription is going to end tomorrow!',
          'please check your subscription',
          endDate.subtract(Duration(days: 1, hours: 6)),
          platform,
        );
      }
      if (!endDate.difference(DateTime.now()).isNegative) {
        await flutterLocalNotificationsPlugin.schedule(
          2,
          'your subscription has been ended!',
          'please renew your subscription',
          endDate,
          platform,
        );
      }
    } catch (error) {
      print(error);
    }
  }

  static Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}