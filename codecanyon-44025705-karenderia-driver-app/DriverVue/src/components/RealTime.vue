<template>
  <div style="display: none"></div>
</template>

<script>
import { loadScript } from "vue-plugin-load-script";
import auth from "src/api/auth";
import { useActivityStore } from "stores/ActivityStore";
import APIinterface from "src/api/APIinterface";
import { NativeAudio } from "@capacitor-community/native-audio";
import { LocalNotifications } from "@capacitor/local-notifications";
import config from "src/api/config";

export default {
  name: "RealTime",
  props: ["sound_id"],
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  data() {
    return {
      data: [],
      pusher: undefined,
      channel: undefined,
      user_data: null,
    };
  },
  watch: {
    Activity: {
      immediate: true,
      deep: true,
      handler(newValue, oldValue) {
        if (Object.keys(newValue.realtime_data).length > 0) {
          if (auth.authenticated()) {
            this.data = newValue.realtime_data;
            if (this.data.realtime_app_enabled == 1) {
              this.initProvider();
            }
          }
        }
      },
    },
  },
  mounted() {
    const userData = auth.getUser();
    this.user_data = userData;
    console.log("user_data", this.user_data);

    NativeAudio.preload({
      assetId: this.sound_id,
      assetPath: config.sound,
      audioChannelNum: 1,
      isUrl: false,
    });
  },
  beforeUnmount() {
    if (this.pusher) {
      this.pusher.unsubscribe(this.user_data.driver_uuid);
      this.pusher.disconnect();
    }
    NativeAudio.unload({
      assetId: this.sound_id,
    });
  },
  methods: {
    initProvider() {
      switch (this.data.realtime_provider) {
        case "pusher":
          loadScript("https://js.pusher.com/7.0/pusher.min.js")
            .then(() => {
              this.initPusher();
            })
            .catch(() => {
              console.debug("failed loading realtime script");
            });
          break;
      }
    },
    initPusher() {
      console.log("initPusher");
      if (APIinterface.empty(this.pusher)) {
        const userData = auth.getUser();
        Pusher.logToConsole = false;
        this.pusher = new Pusher(this.data.pusher_key, {
          cluster: this.data.pusher_cluster,
        });
        this.channel = this.pusher.subscribe(userData.driver_uuid);
        this.channel.bind(this.data.event, (data) => {
          NativeAudio.isPlaying({
            assetId: this.sound_id,
          }).then((result) => {
            if (!result.isPlaying) {
              NativeAudio.play({
                assetId: this.sound_id,
              });
            }
          });

          this.playLocalNotification(data);

          this.$emit("afterReceive", data);
        });
      }
    },
    playLocalNotification(data) {
      const randomId = Math.floor(Math.random() * 10000) + 1;
      LocalNotifications.schedule({
        notifications: [
          {
            title: data.message,
            body: "",
            id: randomId,
          },
        ],
      });
    },
  },
};
</script>
