import { boot } from "quasar/wrappers";
import auth from "src/api/auth";
import { useDataStore } from "stores/DataStore";
import { useUserStore } from "stores/UserStore";
import Pusher from "pusher-js";
import { NativeAudio } from "@capacitor-community/native-audio";
import config from "src/api/config";
import { LocalNotifications } from "@capacitor/local-notifications";
import { useOrderStore } from "src/stores/OrderStore";

let pusherInstance = null;
let Channel = null;
let assetSoundsId = "notify";
const preloadedAssets = new Set(); // Track preloaded assets

export default boot(async ({ app, router, store }) => {
  try {
    await NativeAudio.preload({
      assetPath: config.sound,
      assetId: "notify",
    });

    await NativeAudio.preload({
      assetPath: "chat.mp3",
      assetId: "chat",
    });
    // END Audio
  } catch (err) {
    console.error("NativeAudio preload error:", err);
  }

  if (app.config.globalProperties.$q.platform.is.capacitor) {
    await LocalNotifications.requestPermissions();
  }

  router.beforeEach((to, from, next) => {
    const DataStore = useDataStore();
    const userStore = useUserStore();
    const OrderStore = useOrderStore();
    const isLogin = auth.authenticated();
    const pusherSettings = DataStore.getPusher;

    let puserEnabled = pusherSettings?.realtime_app_enabled ?? false;
    puserEnabled = puserEnabled == 1 ? true : false;

    if (isLogin && pusherSettings && !pusherInstance) {
      if (!puserEnabled) {
        OrderStore.startPollingFallback();
        next();
        return;
      }

      Pusher.logToConsole = false;
      pusherInstance = new Pusher(pusherSettings.pusher_key, {
        cluster: pusherSettings.pusher_cluster,
      });

      const userData = auth.getUser();
      Channel = pusherInstance.subscribe(userData.merchant_uuid);
      Channel.bind("notification-event", (data) => {
        userStore.pusher_receive_data = data;

        //console.log("notification_type pusher.js=>", data.notification_type);
        let notificationType = data.notification_type
          ? data.notification_type
          : null;

        if (notificationType == "auto_print") {
          return;
        }

        // if (app.config.globalProperties.$q.platform.is.capacitor) {
        //   const randomId = Math.floor(Math.random() * 10000) + 1;
        //   LocalNotifications.schedule({
        //     notifications: [
        //       {
        //         title: data.message,
        //         body: "",
        //         id: randomId,
        //       },
        //     ],
        //   });
        // }

        if (
          typeof userStore.notifications_data !== "object" ||
          userStore.notifications_data === null
        ) {
          userStore.notifications_data = {};
        }

        if (notificationType == "chat-message") {
          NativeAudio.play({ assetId: "chat" });

          const currentCount = parseInt(
            userStore.notifications_data?.chat_count ?? 0
          );

          userStore.notifications_data.chat_count =
            currentCount > 0 ? currentCount + 1 : 1;
        } else {
          NativeAudio.play({ assetId: "notify" });
          const currentCount = parseInt(
            userStore.notifications_data?.alert_count ?? 0
          );
          userStore.notifications_data.alert_count =
            currentCount > 0 ? currentCount + 1 : 1;
        }
      });
      //
    } else if (!isLogin && pusherInstance) {
      pusherInstance.disconnect();
      pusherInstance = null;

      // NativeAudio.unload({
      //   assetId: assetSoundsId,
      // });
    }
    next();
  });
  app.config.globalProperties.$pusher = pusherInstance;
});
