<template>
  <div>
    <!-- <pre>{{ KitchenStore.realtime_data }}</pre> -->
  </div>
  <PrinterPreview ref="ref_print"> </PrinterPreview>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useKitchenStore } from "stores/KitchenStore";
import { useIdentityStore } from "stores/IdentityStore";
import { useSettingStore } from "stores/SettingStore";
import { jwtDecode } from "jwt-decode";
import Pusher from "pusher-js";
import APIinterface from "src/api/APIinterface";
//import { NativeAudio } from "@capacitor-community/native-audio";
import { NativeAudio } from "@bondulich/native-audio";
import config from "src/api/config";

const sound_id = "notify";

export default {
  name: "RealtimeComponents",
  components: {
    PrinterPreview: defineAsyncComponent(() =>
      import("components/PrinterPreview.vue")
    ),
  },
  data() {
    return {
      data: [],
      pusher: null,
      channel: null,
      merchant_uuid: null,
      meta_data: null,
    };
  },
  setup() {
    const KitchenStore = useKitchenStore();
    const IdentityStore = useIdentityStore();
    const SettingStore = useSettingStore();
    return { KitchenStore, IdentityStore, SettingStore };
  },
  mounted() {
    if (this.KitchenStore.settings_data) {
      this.initPusher();
    } else {
      this.$watch(
        () => this.KitchenStore.$state.settings_data,
        (newData, oldData) => {
          this.initPusher();
        }
      );
    }

    //
    NativeAudio.preload({
      assetId: sound_id,
      assetPath: config.sound,
      audioChannelNum: 1,
      isUrl: false,
    });
    //
  },
  beforeUnmount() {
    if (this.pusher && this.merchant_uuid) {
      this.pusher.unsubscribe(this.merchant_uuid);
      this.pusher.disconnect();
    }
    NativeAudio.unload({
      assetId: sound_id,
    });
  },
  methods: {
    initPusher() {
      if (this.IdentityStore.authenticated()) {
        try {
          let user_data = jwtDecode(this.IdentityStore.user_data);
          this.merchant_uuid = user_data.merchant_uuid + "-kitchen";

          let realtime_settings = jwtDecode(
            this.KitchenStore.settings_data.realtime_settings
          );

          if (realtime_settings.realtime_app_enabled == 1) {
            //Pusher.logToConsole = true;
            this.pusher = new Pusher(realtime_settings.pusher_key, {
              cluster: realtime_settings.pusher_cluster,
            });

            this.channel = this.pusher.subscribe(this.merchant_uuid);
            this.channel.bind_global(this.handlePusherEvent);
          }
        } catch (err) {
          console.log("ERROR", err.message);
        }
      }
    },
    handlePusherEvent(eventName, data) {
      //console.log(`Received Pusher event '${eventName}':`, data);
      // console.log("eventName", eventName);
      if (eventName != "pusher:subscription_succeeded") {
        //console.log("notification_type", data.notification_type);

        APIinterface.notify(
          this.$q,
          data.meta_data.title,
          data.message,
          "mysuccess",
          "done",
          "top-right"
        );

        if (!this.SettingStore.mute_sounds) {
          NativeAudio.isPlaying({
            assetId: sound_id,
          }).then((result) => {
            if (!result.isPlaying) {
              NativeAudio.play({
                assetId: sound_id,
              });
            }
          });
        }

        this.KitchenStore.notification_type = data.notification_type;
        if (this.KitchenStore.realtime_data) {
          this.KitchenStore.realtime_data.data.unshift(data);
        } else {
          this.KitchenStore.realtime_data = {
            data: [data],
          };
        }

        // AUTO PRINT
        this.meta_data = data.meta_data;
        console.log("meta_data", this.meta_data);
        if (this.meta_data.new_order) {
          console.log("order_reference", this.meta_data.order_reference);
          console.log("printer_id", this.meta_data.printer_id);
          console.log("printer_model", this.meta_data.printer_model);
          if (this.meta_data.printer_id > 0) {
            console.log("do auto print");
            this.doAutoPrint(
              this.meta_data.order_reference,
              this.meta_data.printer_id,
              this.meta_data.printer_model
            );
          }
        }
        //
      }
    },
    async doAutoPrint(order_reference, printer_id, printer_model) {
      if (printer_model == "feieyun") {
        //APIinterface.showLoadingBox(this.$t("Printing..."), this.$q);
        APIinterface.fetchDataPost(
          "PrintTicketFP",
          "printer_id=" + printer_id + "&order_reference=" + order_reference
        )
          .then((data) => {
            APIinterface.notify(
              this.$q,
              this.$t("Print"),
              data.msg,
              "mysuccess",
              "highlight_off",
              "bottom"
            );
          })
          .catch((error) => {
            APIinterface.notify(
              this.$q,
              this.$t("Error"),
              error,
              "myerror",
              "highlight_off",
              "bottom"
            );
          })
          .then((data) => {
            //APIinterface.hideLoadingBox(this.$q);
          });
      } else {
        //APIinterface.showLoadingBox(this.$t("Getting ticket info..."), this.$q);
        let results = await this.KitchenStore.getTicket(
          order_reference,
          printer_id
        );
        //APIinterface.hideLoadingBox(this.$q);
        let print_data = results.data ? results.data : null;
        if (print_data) {
          this.$refs.ref_print.print(results);
        } else {
          APIinterface.notify(
            this.$q,
            this.$t("Error"),
            results,
            "myerror",
            "highlight_off",
            "bottom"
          );
        }
      }
    },
    //
  },
};
</script>
