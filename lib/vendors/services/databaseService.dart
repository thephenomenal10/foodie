import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodieapp/vendors/widgets/globalVariable.dart' as global;


class DatabaseService {


  Firestore firestore = Firestore.instance;

  Future<void> addUserData(userData, userEmail) {

      firestore.collection("vendor_collection").document("vendors").collection("registered_vendors").document(userEmail).updateData(userData)
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



  // Future<dynamic>  getVendorInfo() async{

  //     // SharedPreferences prefs = await SharedPreferences.getInstance();
  //     // String email = prefs.getString("currentUserEmail");

  //    return  await firestore.collection("tiffen_service_details").document("sahyogsaini.cse@gmail.com").get();
  // }
}