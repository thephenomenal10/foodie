const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

exports.newOrderNotification = functions.firestore
  .document("test_customer_orders/{order}")
  .onCreate(async (snapshot, context) => {
    var registeredTokens = [
      ...(
        await admin
          .firestore()
          .collection("tiffen_service_details")
          .doc(snapshot.data().vendorEmail)
          .get()
      ).data().fcmTokens,
    ];
    var message = {
      notification: {
        title: "You have a new order , checkout!",
        body: "Customer name : " + snapshot.data().customerName,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };
    try {
      return admin.messaging().sendToDevice(registeredTokens, message);
    } catch (error) {
      return error;
    }
  });
