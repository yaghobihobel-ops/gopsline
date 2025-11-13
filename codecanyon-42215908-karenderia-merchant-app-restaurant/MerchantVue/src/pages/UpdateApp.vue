<template>
  <q-page class="q-pl-md q-pr-md flex flex-center">
    <div class="full-width text-center">
      <q-img
        src="update.png"
        fit="fill"
        spinner-color="primary"
        style="max-width: 150px"
      />
      <q-space class="q-pa-sm"></q-space>
      <!-- {{ DataStore.app_version }} => {{ DataStore.app_version_android }} -->
      <div class="font16 text-weight-bold">
        {{ app_name }} {{ $t("needs an update") }}
      </div>
      <div class="text-grey font12">
        {{ $t("To continue to use the app, download the latest version") }}
      </div>
      <q-space class="q-pa-sm"></q-space>
      <q-btn
        outline
        style="color: dark"
        :label="$t('Update')"
        no-caps
        :href="
          $q.platform.is.android
            ? this.DataStore.android_download_url
            : this.DataStore.ios_download_url
        "
        target="_blank"
      />
    </div>
  </q-page>
</template>

<script>
import { App } from "@capacitor/app";
import { useDataStore } from "stores/DataStore";

export default {
  name: "UpdateApp",
  data() {
    return {
      app_name: "{{}}",
    };
  },
  created() {
    if (this.$q.capacitor) {
      this.getApp();
    }
  },
  computed: {},
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  methods: {
    async getApp() {
      let result = await App.getInfo();
      if (result) {
        this.app_name = result.name;
      }
    },
  },
};
</script>
