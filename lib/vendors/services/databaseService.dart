import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService {


  Firestore firestore = Firestore.instance;

  Future<void> addUserData(userData, userEmail) {

      firestore.collection("vendor_collection").document("vendors").collection("registered_vendors").document(userEmail).setData(userData)
      .catchError((e) {
        print(e.message);
      }); 
  }


  Future<void> createTiffen(tiffenData, userEmail) {

    firestore.collection("tiffen_service_details").document(userEmail).setData(tiffenData)
    .catchError((e) {
      print(e.message);
    });
  }
}