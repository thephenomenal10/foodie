import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:foodieapp/vendors/screens/updateTiffenInfo.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:foodieapp/vendors/widgets/globalVariable.dart' as global;

class DatabaseService {
  Firestore firestore = Firestore.instance;

  Future<void> updateUserData(userData, userEmail) async {
    await firestore
        .collection("vendor_collection")
        .document("vendors")
        .collection("registered_vendors")
        .document(userEmail)
        .updateData(userData)
        .catchError((e) {
      print(e.message);
    });
  }

  Future<void> addUserData(userData, userEmail) async {
    await firestore
        .collection("vendor_collection")
        .document("vendors")
        .collection("registered_vendors")
        .document(userEmail)
        .setData(userData)
        .catchError((e) {
      print(e.message);
    });
  }

  Future<void> createTiffen(tiffenData, userEmail) async {
    await firestore
        .collection("tiffen_service_details")
        .document(userEmail)
        .setData(tiffenData)
        .catchError((e) {
      print(e.message);
    });
  }

  Future<void> updateTiffenInfo(tiffenData, userEmail) async {
    await firestore
        .collection("tiffen_service_details")
        .document(userEmail)
        .updateData(tiffenData)
        .catchError((e) {
      print(e.message);
    });
  }

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
}
