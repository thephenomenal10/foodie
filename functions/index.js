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
          .collection("vendor_collection/vendors/registered_vendors")
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

exports.vendorSubscriptionNotification = functions.firestore
  .document("tiffen_service_details/{newVendor}")
  .onUpdate(async (change, context) => {
    const after = change.after.data();
    if (after["Proof of Payment Photos"] !== null) {
      const registeredTokens = [
        ...(
          await admin
            .firestore()
            .collection("vendor_collection/vendors/registered_vendors")
            .doc(after.Email)
            .get()
        ).data().fcmTokens,
      ];
      try {
        return admin.messaging().sendToDevice(registeredTokens, {
          notification: {
            title: "Thank you for subscribing to us.",
            body: "we will notify you soon...\nHave a nice Day\t☺",
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
        });
      } catch (error) {
        return error;
      }
    }
    return;
  });
