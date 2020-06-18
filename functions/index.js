const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Message } = require("firebase-functions/lib/providers/pubsub");

admin.initializeApp(functions.config().firebase);

exports.newOrderNotification = functions.firestore
  .document("tiffen_service_details/{vendorEmail}/pendingOrders/{neworder}")
  .onCreate(async (snapshot, context) => {
    const vendorEmail = context.params.vendorEmail;
    const registeredTokens = [
      ...(
        await admin
          .firestore()
          .collection("vendor_collection/vendors/registered_vendors")
          .doc(vendorEmail)
          .get()
      ).data().fcmTokens,
    ];
    const message = {
      notification: {
        title: "You have a new order , checkout!",
        body:
          "Customer name : " +
          snapshot.data().customerName +
          "\nHave a nice Day\t🙂",
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };
    try {
      return admin.messaging().sendToDevice(registeredTokens, message);
    } catch (error) {
      return error;
    }
  });

exports.orderCancelledNotification = functions.firestore
  .document("tiffen_service_details/{vendorEmail}/cancelledOrders/{neworder}")
  .onCreate(async (snapshot, context) => {
    const vendorEmail = context.params.vendorEmail;
    const registeredTokens = [
      ...(
        await admin
          .firestore()
          .collection("vendor_collection/vendors/registered_vendors")
          .doc(vendorEmail)
          .get()
      ).data().fcmTokens,
    ];
    const message = {
      notification: {
        title: "An order has been cancelled!",
        body:
          "Customer name : " +
          snapshot.data().customerName +
          "\nPlease check your orders\t🙂",
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };
    try {
      return admin.messaging().sendToDevice(registeredTokens, message);
    } catch (error) {
      return error;
    }
  });

exports.mealChangeNotification = functions.firestore
  .document("tiffen_service_details/{vendorEmail}/acceptedOrders/{order}")
  .onUpdate(async (change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();
    var titleMessage;
    if (beforeData.pauses + 1 === afterData.pauses) {
      titleMessage = "An order has been paused!";
    } else if (beforeData.skips + 1 === afterData.skips) {
      titleMessage = "An order has been skipped!";
    }
    if (titleMessage !== null) {
      const registeredTokens = [
        ...(
          await admin
            .firestore()
            .collection("vendor_collection/vendors/registered_vendors")
            .doc(change.after.data().vendorEmail)
            .get()
        ).data().fcmTokens,
      ];
      const message = {
        notification: {
          title: titleMessage,
          body:
            "Customer name : " +
            change.after.data().customerName +
            "\nPlease check your orders\t🙂",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      try {
        return admin.messaging().sendToDevice(registeredTokens, message);
      } catch (error) {
        return error;
      }
    }
    return "no change";
  });

exports.vendorSubscriptionNotification = functions.firestore
  .document("tiffen_service_details/{newVendor}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    if (
      before["Proof of Payment Photos"] === null &&
      after["Proof of Payment Photos"] !== null
    ) {
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
            body: "we will notify you soon...\nHave a nice Day\t🙂",
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
        });
      } catch (error) {
        return error;
      }
    }
    return "no change";
  });

exports.vendorSubscriptionRenewalNotification = functions.firestore
  .document("tiffen_service_details/{updatedVendor}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    if (before.SubscriptionEndDate !== after.SubscriptionEndDate) {
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
            title: "Your subscription has been renewed!",
            body: "Thank you for renewal.\nHave a nice Day\t🙂",
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
        });
      } catch (error) {
        return error;
      }
    }
    return "no change";
  });
