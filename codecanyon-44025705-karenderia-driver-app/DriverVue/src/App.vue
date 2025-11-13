<template>
  <router-view />
</template>

<script>
import { FCM } from "@capacitor-community/fcm";
import { PushNotifications } from "@capacitor/push-notifications";
import { defineComponent } from "vue";
import APIinterface from "./api/APIinterface";
import config from "./api/config";
import auth from "./api/auth";
import { DateTime } from "luxon";
import { useActivityStore } from "stores/ActivityStore";
import { Network } from "@capacitor/network";
import { App } from "@capacitor/app";
import { api } from "boot/axios";

export default defineComponent({
  name: "App",
  data() {
    return {
      token: "",
      close_count: 0,
    };
  },
  setup(props) {
    const ActivityStore = useActivityStore();
    return { ActivityStore };
  },
  created() {
    this.close_count = 0;

    console.log("language=>" + this.ActivityStore.app_language);
    if (!APIinterface.empty(this.ActivityStore.app_language)) {
      this.$i18n.locale = this.ActivityStore.app_language;
    }
    if (!APIinterface.empty(this.ActivityStore.rtl)) {
      this.$q.lang.set({ rtl: this.ActivityStore.rtl });
    }
    api.defaults.params = {};
    api.defaults.params["language"] = this.$i18n.locale;

    this.ActivityStore.getSettings();
    this.verifyToken();
    if (this.$q.capacitor) {
      this.initPush();
    }

    App.addListener("backButton", (data) => {
      this.close_count++;
      if (!data.canGoBack) {
        if (this.close_count >= 3) {
          this.closeApp();
        } else {
          APIinterface.showToast(this.$t("Press BACK again to exit"));
          setTimeout(() => {
            this.close_count = 0;
          }, 1000);
        }
      }
    });

    App.addListener("appStateChange", (data) => {
      if (data.isActive && this.$q.platform.is.ios && this.$q.capacitor) {
        PushNotifications.removeAllDeliveredNotifications().then((result) => {
          // do nothing
        });
      }
    });

    if (this.$q.capacitor) {
      this.checkNetwork();
      Network.addListener("networkStatusChange", (status) => {
        if (status.connected === false) {
          APIinterface.showToast("No internet connection");
          this.$router.push("/errornetwork");
        }
      });
    }
  },
  methods: {
    closeApp() {
      App.exitApp();
    },
    async checkNetwork() {
      const status = await Network.getStatus();
      if (status.connected === false) {
        this.$router.push("/errornetwork");
      }
    },
    verifyToken() {
      auth
        .authenticate()
        .then((data) => {
          //
        })
        .catch((error) => {
          auth.logout();
          //this.$router.push("/user/login");
        })
        .then((data) => {});
    },
    getSettings() {
      APIinterface.fetchDataByToken("getSettings", "")
        .then((result) => {
          APIinterface.setStorage(
            "driver_maps_config",
            result.details.maps_config
          );
          APIinterface.setStorage(
            "phone_settings",
            result.details.phone_settings
          );
          APIinterface.setStorage("lang_data", result.details.lang_data);
          APIinterface.setStorage("server_time", result.details.date_now);

          let serverTime = APIinterface.getStorage("server_time");
          const specifyOffset = DateTime.fromISO(serverTime);
        })
        .catch((error) => {
          console.debug(error);
        })
        .then((data) => {
          //
        });
    },
    initPush() {
      //if (this.$q.platform.is.ios) {
      PushNotifications.checkPermissions().then((result) => {
        console.log(JSON.stringify(result));
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
      // } else {
      //   PushNotifications.requestPermissions().then((result) => {
      //     if (result.receive === "granted") {
      //       PushNotifications.register();
      //     } else {
      //       APIinterface.notify(
      //         "negative",
      //         "Error on push permission",
      //         "warning",
      //         this.$q
      //       );
      //     }
      //   });
      // }

      FCM.setAutoInit({ enabled: true }).then(() => {
        //
      });

      FCM.isAutoInitEnabled().then((r) => {
        // alert('Auto init is ' + (r.enabled ? 'enabled' : 'disabled'))
      });

      FCM.subscribeTo({ topic: config.topic })
        .then((r) => {
          //
        })
        .catch((error) => {
          APIinterface.notify(
            "red-5",
            "Error subscribing topics" + JSON.stringify(error),
            "warning",
            this.$q
          );
        });

      PushNotifications.addListener("registration", (Token) => {
        if (this.$q.platform.is.android) {
          this.token = Token.value;
          APIinterface.setSession("device_token", this.token);
        } else {
          FCM.getToken()
            .then((r) => {
              this.token = r.token;
              APIinterface.setSession("device_token", this.token);
            })
            .catch((error) => {
              APIinterface.notify("red-5", error, "error_outline", this.$q);
            });
        }
      });

      PushNotifications.addListener("registrationError", (error) => {
        APIinterface.notify(
          "red-5",
          "Error on registration" + JSON.stringify(error),
          "warning",
          this.$q
        );
      });

      PushNotifications.createChannel({
        description: "KMRS driver app channel",
        id: config.channel,
        importance: 5,
        lights: true,
        name: "kmrs channel",
        sound: config.sound,
        vibration: true,
        visibility: 1,
      })
        .then(() => {
          // alert('push channel created: ')
        })
        .catch((error) => {
          // APIinterface.notify(
          //   "red-5",
          //   "Error on registration" + JSON.stringify(error),
          //   "warning",
          //   this.$q
          // );
        });

      PushNotifications.addListener(
        "pushNotificationReceived",
        (notification) => {
          APIinterface.notify(
            "green-5",
            notification?.title,
            "check_circle",
            this.$q
          );
        }
      );

      //
    },
  },
});
</script>
