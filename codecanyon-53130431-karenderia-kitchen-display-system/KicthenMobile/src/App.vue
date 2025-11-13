<template>
  <router-view />
</template>

<script>
import { defineComponent } from "vue";
import { useKitchenStore } from "stores/KitchenStore";
import { useSettingStore } from "stores/SettingStore";
import APIinterface from "./api/APIinterface";
import { api } from "boot/axios";
import { FCM } from "@capacitor-community/fcm";
import { PushNotifications } from "@capacitor/push-notifications";
import { Network } from "@capacitor/network";
import { App } from "@capacitor/app";
import config from "src/api/config";
import { Toast } from "@capacitor/toast";

export default defineComponent({
  name: "App",
  data() {
    return {
      close_count: 0,
    };
  },
  setup() {
    const KitchenStore = useKitchenStore();
    const SettingStore = useSettingStore();
    return { KitchenStore, SettingStore };
  },
  created() {
    this.close_count = 0;

    if (this.$q.capacitor) {
      this.initPush();
      this.getAppVersion();
      this.checkNetwork();

      App.addListener("backButton", (data) => {
        this.close_count++;
        if (!data.canGoBack) {
          if (this.close_count >= 2) {
            App.exitApp();
          } else {
            Toast.show({
              text: this.$t("Press BACK again to exit"),
            });
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
    }

    //
  },
  async mounted() {
    this.$q.dark.set(this.SettingStore.dark_theme);

    if (!APIinterface.empty(this.SettingStore.app_language)) {
      this.$i18n.locale = this.SettingStore.app_language;
    }

    this.$q.lang.set({ rtl: this.SettingStore.rtl });

    api.defaults.params = {};
    api.defaults.params["language"] = this.$i18n.locale;

    await this.KitchenStore.getSettings();

    if (this.KitchenStore.settings_data) {
      this.initTransitionTimes();
    } else {
      this.$watch(
        () => this.KitchenStore.$state.settings_data,
        (newData, oldData) => {
          this.initTransitionTimes();
        }
      );
    }
  },
  methods: {
    initTransitionTimes() {
      if (APIinterface.empty(this.SettingStore.app_language)) {
        this.SettingStore.app_language =
          this.KitchenStore.settings_data.default_lang;
      }

      if (Object.keys(this.SettingStore.transition_times).length > 0) {
      } else {
        if (Object.keys(this.KitchenStore.getTransactionList).length > 0) {
          Object.entries(this.KitchenStore.getTransactionList).forEach(
            ([key, items]) => {
              let default_data = {
                value: items.value,
                caution: "00:05:00",
                last: "00:08:00",
              };
              this.SettingStore.transition_times.push(default_data);
              this.SettingStore.color_status[items.value] = this.KitchenStore
                .color_status[items.value]
                ? this.KitchenStore.color_status[items.value]
                : "#8ad975";

              this.SettingStore.split_order_type[items.value] = "top";
            }
          );
        }
      }
    },
    closeApp() {
      App.exitApp();
    },
    async getAppVersion() {
      let result = await App.getInfo();
      if (result) {
        this.SettingStore.app_version = result.version;
      }
    },
    async checkNetwork() {
      const status = await Network.getStatus();
      if (status.connected === false) {
        this.$router.push("/errornetwork");
      }
      Network.addListener("networkStatusChange", (status) => {
        if (status.connected === false) {
          APIinterface.notify(
            this.$q,
            "",
            this.$t("No internet connection"),
            "myerror",
            "highlight_off",
            "bottom"
          );
          this.$router.push("/errornetwork");
        }
      });
    },
    initPush() {
      try {
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

        FCM.subscribeTo({ topic: config.topic })
          .then((r) => {
            //alert("subscribeTo Ok");
          })
          .catch((error) => {
            alert("Error subscribing topics" + JSON.stringify(error));
          });

        PushNotifications.addListener("registration", (Token) => {
          if (this.$q.platform.is.android) {
            this.SettingStore.device_token = Token.value;
            console.log("DEVICE TOKEN", Token.value);
          } else {
            FCM.getToken()
              .then((r) => {
                this.SettingStore.device_token = r.token;
                alert(r.token);
              })
              .catch((error) => {
                alert("Failed FCM getToken" + JSON.stringify(error));
              });
          }
        });

        PushNotifications.addListener("registrationError", (error) => {
          APIinterface.notify(
            this.$q,
            "",
            "Error on registration" + JSON.stringify(error),
            "myerror",
            "highlight_off",
            "bottom"
          );
        });
      } catch (err) {
        console.log("err.message", err.message);
      }

      PushNotifications.createChannel({
        description: "KMRS mobile app channel",
        id: config.channel,
        importance: 5,
        lights: true,
        name: "kmrs channel",
        sound: config.sound,
        vibration: true,
        visibility: 1,
      })
        .then(() => {
          //alert("push channel created: ");
        })
        .catch((error) => {
          //alert("Error on registration" + JSON.stringify(error));
        });

      PushNotifications.addListener(
        "pushNotificationReceived",
        (notification) => {
          //alert("Push received: " + JSON.stringify(notification));
        }
      );

      //
    },
    //
  },
});
</script>
