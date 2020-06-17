import 'package:cloud_firestore/cloud_firestore.dart';
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

  // static Future<void> showScheduledNotification() async {
  //   await _initializeNotiication();
  //   print('executed now');
  //   var android = AndroidNotificationDetails(
  //       'channelId', 'channelName', 'channelDescription');
  //   var platform = NotificationDetails(android, null);
  //   await flutterLocalNotificationsPlugin.schedule(
  //     0,
  //     'your subscription is going to end tomorrow!',
  //     'please check your subscription',
  //     DateTime.now().add(Duration(seconds: 1)),
  //     platform,
  //   );
  // }
}
