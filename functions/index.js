const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

exports.newOrderNotification = functions.firestore
  .document("test_customer_orders/{order}")
  .onCreate(async (snapshot, context) => {
    const registeredTokens = [
      ...(
        await admin
          .firestore()
          .collection("tiffen_service_details")
          .doc(snapshot.data().vendorEmail)
          .get()
      ).data().fcmTokens,
    ];
    const message = {
      notification: {
        title: "You have a new order , checkout!",
        body:
          "Customer name : " +
          snapshot.data().customerName +
          "\nHave a nice Day\t☺",
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };
    try {
      return admin.messaging().sendToDevice(registeredTokens, message);
    } catch (error) {
      return error;
    }
  });
