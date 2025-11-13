import { boot } from "quasar/wrappers";
import { FCM } from "@capacitor-community/fcm";
import { PushNotifications } from "@capacitor/push-notifications";
import { App } from "@capacitor/app";
import config from "src/api/config";
import { Platform } from "quasar";
import { useUserStore } from "stores/UserStore";
import { useOrderStore } from "stores/OrderStore";

export default boot(async ({ app, router, store }) => {
  //
  if (!Platform.is.capacitor) {
    return;
  }

  const $q = app.config.globalProperties.$q;

  const userStore = useUserStore();
  const OrderStore = useOrderStore();

  App.addListener("appStateChange", (data) => {
    if (data.isActive && Platform.is.ios && Platform.is.capacitor) {
      PushNotifications.removeAllDeliveredNotifications().then((result) => {
        // do nothing
      });
    }
  });

  PushNotifications.checkPermissions().then((result) => {
    if (result.receive === "prompt") {
      PushNotifications.requestPermissions().then((result) => {
        if (result.receive === "granted") {
          PushNotifications.register();
        }
      });
    } else if (result.receive === "granted") {
      PushNotifications.register();
    } else if (result.receive === "prompt-with-rationale") {
      PushNotifications.register();
    }
  });

  FCM.setAutoInit({ enabled: true }).then(() => {
    //
  });

  FCM.isAutoInitEnabled().then((r) => {
    // alert('Auto init is ' + (r.enabled ? 'enabled' : 'disabled'))
  });

  PushNotifications.addListener("registration", async (Token) => {
    if (Platform.is.android) {
      userStore.device_token = Token.value;
    } else {
      FCM.getToken()
        .then((r) => {
          userStore.device_token = r.token;
        })
        .catch((error) => {
          console.log("error registration", error);
        });
    }

    try {
      await FCM.subscribeTo({ topic: config.topic });
    } catch (error) {}
  });

  PushNotifications.addListener("registrationError", (error) => {
    console.error("Push registration error: ", error);
  });

  PushNotifications.createChannel({
    description: "KMRS merchant app channel",
    id: config.channel,
    importance: 5,
    lights: true,
    name: "kmrs channel",
    sound: config.sound,
    vibration: true,
    visibility: 1,
  })
    .then(() => {
      //
    })
    .catch((error) => {
      console.log("error creating channel", error);
    });

  PushNotifications.addListener("pushNotificationReceived", (notification) => {
    console.log("PUSH receive", notification);
    OrderStore.playAlert(notification?.title);
  });

  PushNotifications.addListener(
    "pushNotificationActionPerformed",
    (notification) => {
      console.log("Notification action performed", notification);
      // Navigate or perform any logic here
    }
  );

  // end
});
