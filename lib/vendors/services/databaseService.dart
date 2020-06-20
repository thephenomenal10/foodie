import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> addUserData(userData, userEmail) async{
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

  Future<void> createTiffen(tiffenData, userEmail) async{
    await firestore
        .collection("tiffen_service_details")
        .document(userEmail)
        .setData(tiffenData)
        .catchError((e) {
      print(e.message);
    });
  }

  Future<void> updateTiffenInfo(tiffenData, userEmail) async{
    await firestore
        .collection("tiffen_service_details")
        .document(userEmail)
        .updateData(tiffenData)
        .catchError((e) {
      print(e.message);
    });
  }
}
