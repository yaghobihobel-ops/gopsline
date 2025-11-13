<template>
  <q-page padding class="flex flex-center">
    <img src="icon.png" width="80" />
  </q-page>
</template>

<script>
import auth from "src/api/auth";
import { useDataStore } from "stores/DataStore";
import { useDataPersisted } from "stores/DataPersisted";

export default {
  name: "IntroPage",
  setup(props) {
    const DataStore = useDataStore();
    const DataPersisted = useDataPersisted();
    return { DataStore, DataPersisted };
  },
  mounted() {
    const isLogin = auth.authenticated();
    const enabled_language = this.DataStore.enabled_language;
    const choose_language = this.DataStore.choose_language;
    const device_language = this.DataStore.device_language;
    if (!isLogin) {
      if (enabled_language && !device_language) {
        this.DataPersisted.app_language = device_language;
        this.$router.replace("/select-language");
      } else {
        this.$router.replace("/login");
      }
      return;
    } else {
      this.$router.replace("/dashboard");
    }
  },
};
</script>
