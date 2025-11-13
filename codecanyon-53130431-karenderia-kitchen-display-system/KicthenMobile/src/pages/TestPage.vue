<template>
  <q-page padding>
    <h6>Test page</h6>
    <!-- <div>Version {{ SettingStore.app_version }}</div> -->
    <!-- <div>device_token {{ SettingStore.device_token }}</div> -->

    <q-btn label="Play" @click="playAudio" color="primary" no-caps></q-btn>
    <br /><br />
    <q-btn
      label="Get Printer List"
      @click="getPrinterList"
      color="primary"
      no-caps
      :loading="loading"
    ></q-btn>

    <div class="q-pa-md"></div>

    <div class="q-pa-md">is_connected : {{ is_connected }}</div>

    <q-list separator>
      <template v-for="items in printers" :key="items">
        <q-item
          clickable
          v-ripple
          v-if="items.localName"
          @click="
            ConnectPrinter({
              device_id: items.device.deviceId,
              service: items.uuids[0],
              characteristic: items.uuids[1],
            })
          "
        >
          <q-item-section>
            <q-item-label> {{ items.localName }} </q-item-label>
            <q-item-label> {{ items.device.deviceId }} </q-item-label>
            <q-item-label> {{ items.uuids[0] }} </q-item-label>
            <q-item-label> {{ items.uuids[1] }} </q-item-label>
          </q-item-section>
        </q-item>
      </template>
    </q-list>

    <br />
    <q-btn
      label="testEncoder"
      @click="testEncoder"
      color="primary"
      no-caps
    ></q-btn>
    <br />
    <!-- <pre>{{ printers }}</pre> -->
    <!-- <pre>{{ services }}</pre> -->
    <!-- <pre>{{ commands }}</pre>  -->
    <pre>{{ characteristic_list }}</pre>
  </q-page>
</template>

<script>
import { FCM } from "@capacitor-community/fcm";
import { PushNotifications } from "@capacitor/push-notifications";
import { Network } from "@capacitor/network";
import { App } from "@capacitor/app";
import APIinterface from "src/api/APIinterface";
import config from "src/api/config";
import { useSettingStore } from "stores/SettingStore";
//import { NativeAudio } from "@capacitor-community/native-audio";
import ColorSelection from "src/components/ColorSelection.vue";
import { NativeAudio } from "@bondulich/native-audio";
import { BleClient, numberToUUID } from "@capacitor-community/bluetooth-le";
import ThermalPrinterEncoder from "thermal-printer-encoder";

const sound_id = "notify1";
const HEART_RATE_SERVICE = numberToUUID(0x180d);

export default {
  name: "TestPage",
  data() {
    return {
      close_count: 0,
      printers: [],
      loading: false,
      services: [],
      is_connected: false,
      commands: undefined,
      characteristic_list: [],
    };
  },
  setup() {
    const SettingStore = useSettingStore();
    return { SettingStore };
  },
  mounted() {
    if (this.$q.capacitor) {
      this.initPush();
      this.getAppVersion();
      this.checkNetwork();
    }

    this.close_count = 0;

    App.addListener("backButton", (data) => {
      this.close_count++;
      if (!data.canGoBack) {
        if (this.close_count >= 2) {
          this.closeApp();
        } else {
          APIinterface.notify(
            this.$q,
            this.$t("Press BACK again to exit"),
            error,
            "myerror",
            "highlight_off",
            "bottom"
          );
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

    console.log("config.sound", config.sound);
    console.log("sound_id", sound_id);

    NativeAudio.preload({
      assetId: sound_id,
      assetPath: config.sound,
      audioChannelNum: 1,
      isUrl: false,
    });
  },
  beforeUnmount() {
    NativeAudio.unload({
      assetId: sound_id,
    });
  },
  methods: {
    testEncoder() {
      try {
        let encoder = new ThermalPrinterEncoder({
          language: "esc-pos",
          width: 35,
        });
        let result = encoder
          .initialize()
          .text("The quick brown fox jumps over the lazy dog")
          .newline()
          .encode();
        this.commands = result;
      } catch (err) {
        alert(err.message);
      }
    },
    async getPrinterList() {
      try {
        this.loading = true;
        this.printers = [];
        await BleClient.initialize();

        let is_enabled = await BleClient.isEnabled();
        console.log("is_enabled", is_enabled);

        if (!is_enabled) {
          let enabled = await BleClient.requestEnable();
        }

        await BleClient.requestLEScan({}, (result) => {
          console.log("received new scan result", result);
          this.printers.push(result);
        });

        setTimeout(() => {
          void BleClient.stopLEScan().then(() => {
            console.log("stopped scanning");
            this.loading = false;
          });
        }, 1000);
      } catch (err) {
        alert(err.message);
      }
    },
    startsWith0000(str) {
      return str.startsWith("0000");
    },
    async ConnectPrinter(data) {
      console.log("ConnectPrinter", JSON.stringify(data));
      let device_id = data.device_id;

      this.services = [];
      this.characteristic_list = [];
      this.is_connected = false;

      this.loading = true;
      BleClient.connect(device_id).then(async (results) => {
        this.is_connected = true;
        this.characteristic_list = [];

        this.services = await BleClient.getServices(device_id);
        this.services.forEach((service) => {
          service.characteristics.forEach(async (items) => {
            //console.log("Characteristic UUID:", items.uuid);

            try {
              if (items.properties.write === true) {
                console.log(
                  "Characteristic UUID:",
                  JSON.stringify(items.properties)
                );
                if (this.startsWith0000(items.uuid)) {
                  //this.characteristic_list.push(items.uuid);
                }
                this.characteristic_list.push(items.uuid);
              }
            } catch (err) {}
          });
        });

        let encoder = new ThermalPrinterEncoder({
          language: "esc-pos",
          width: 32,
        });
        // let result = encoder
        //   .initialize()
        //   .text("The quick brown fox jumps over the lazy dog")
        //   .newline()
        //   .encode();
        let result = encoder
          // .table(
          //   [
          //     { width: 20, align: "left" },
          //     { width: 12, align: "right" },
          //   ],
          //   [
          //     ["1x Cheesy Eggdesal Meal (Large)", "1,200.00"],
          //     ["1x Cheese burger", "10,000.00"],
          //     ["Total", (encoder) => encoder.bold().text("250,75").bold()],
          //   ]
          // )
          .newline()
          .align("center")
          .bold()
          .line("McDonald's")
          .bold()
          .line("2810 South Figueroa Street, Los Angeles, CA, USA")
          .line("+12243333333 / mcdo@yahoo.cm")
          .align("left")
          .line("This line is aligned to the left")
          .newline()
          .encode();

        // await BleClient.write(
        //   device_id,
        //   data.service,
        //   "00002af1-0000-1000-8000-00805f9b34fb",
        //   result
        // );

        await BleClient.disconnect(device_id);
        console.log("disconnectd device");
        this.loading = false;
        this.is_connected = false;

        //
      });

      // setTimeout(async () => {
      //   await BleClient.disconnect(device_id);
      //   console.log("disconnectd device");
      //   this.loading = false;
      //   this.is_connected = false;
      // }, 1);
    },
    playAudio() {
      NativeAudio.isPlaying({
        assetId: sound_id,
      }).then((result) => {
        console.log("resutl", result);
        if (!result.isPlaying) {
          NativeAudio.play({
            assetId: sound_id,
          });
        } else {
          NativeAudio.stop({
            assetId: sound_id,
          });
        }
      });
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
            this.$t("No internet connection"),
            error,
            "myerror",
            "highlight_off",
            "bottom"
          );
          this.$router.push("/errornetwork");
        }
      });
    },
    initPush() {
      console.log("initPush");
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
            "Error on registration" + JSON.stringify(error),
            error,
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
  },
};
</script>
