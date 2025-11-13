<template>
  <template v-if="hasDestination">
    <template v-if="size_icon == 'lg'">
      <q-btn
        @click="launchNavigation"
        fab
        color="accent"
        unelevated
        padding="12px"
      >
        <q-icon name="near_me" size="17px" />
      </q-btn>
    </template>
    <template v-else>
      <q-btn
        @click="launchNavigation"
        fab
        color="primary"
        unelevated
        padding="9px"
      >
        <q-icon name="near_me" size="15px" />
      </q-btn>
    </template>
  </template>
</template>

<script>
import { AppLauncher } from "@capacitor/app-launcher";

export default {
  name: "launchNavigation",
  props: ["location", "size_icon"],
  computed: {
    hasDestination() {
      if (Object.keys(this.location).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    launchNavigation() {
      const location = this.location.lat + "," + this.location.lng;
      const destination =
        "https://www.google.com/maps/dir/?api=1&destination=" + location;
      this.openApps("com.google.android.apps.maps", destination);
    },
    async openApps(appId, Url) {
      const data = await AppLauncher.canOpenUrl({ url: appId });
      if (data) {
        const isopen = await AppLauncher.openUrl({
          url: Url,
        });
      } else {
        await AppLauncher.openUrl({ url: "market://details?id=" + appId });
      }
    },
  },
};
</script>
