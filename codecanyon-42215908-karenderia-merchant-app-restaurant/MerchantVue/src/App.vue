<template>
  <router-view />
</template>

<script>
import { defineComponent, defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";
import { FCM } from "@capacitor-community/fcm";
import { PushNotifications } from "@capacitor/push-notifications";
import auth from "./api/auth";
import { App } from "@capacitor/app";
import { Network } from "@capacitor/network";
import APIinterface from "./api/APIinterface";
import { api } from "boot/axios";
import { KeepAwake } from "@capacitor-community/keep-awake";
import { useDataPersisted } from "stores/DataPersisted";

export default defineComponent({
  name: "App",
  data() {
    return {
      token: "",
      close_count: 0,
      osVersion: 0,
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    const DataPersisted = useDataPersisted();
    return { DataStore, DataPersisted };
  },
  mounted() {
    if (!APIinterface.empty(this.DataPersisted.app_language)) {
      this.$i18n.locale = this.DataPersisted.app_language;
    }
    if (this.DataPersisted.rtl) {
      this.$q.lang.set({ rtl: this.DataPersisted.rtl });
    }
    api.defaults.params = {};
    api.defaults.params["language"] = this.$i18n.locale;

    if (this.$q.capacitor) {
      this.setAwake();
    }
  },
  methods: {
    async setAwake() {
      if (this.DataPersisted.keep_awake) {
        await KeepAwake.keepAwake();
      } else {
        await KeepAwake.allowSleep();
      }
    },
  },
});
</script>
