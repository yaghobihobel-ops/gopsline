<template>
  <q-page padding class="flex flex-center">
    <div class="text-center">
      <q-space class="q-pa-md"></q-space>

      <div class="text-h6 text-weight-bold">
        {{ $t("Enabled Your Location") }}
      </div>
      <div class="font13 text-grey">
        {{ $t("In order to continue we need your location enabled") }}
      </div>

      <q-space class="q-pa-sm"></q-space>
      <div>
        <q-btn
          @click="requestPermission"
          unelevated
          color="primary"
          :label="$t('Enabled Your Location')"
          no-caps
          class="text-weight-bold fit font17"
        />
      </div>
      <q-space class="q-pa-xs"></q-space>
      <div>
        <q-btn
          @click="skipLocation"
          unelevated
          flat
          color="primary"
          :label="$t('Skip For Now')"
          no-caps
          class="text-weight-bold fit font17"
        />
      </div>
    </div>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import AppLocation from "src/api/AppLocation";

export default {
  name: "LocationPermission",
  data() {
    return {
      redirect: "",
    };
  },
  created() {
    this.redirect = !APIinterface.empty(this.$route.query.page)
      ? this.$route.query.page
      : "/home";
  },
  methods: {
    skipLocation() {
      APIinterface.setSession("skip_location", 1);
      this.$router.push("/home");
    },
    requestPermission() {
      if (!this.$q.capacitor) {
        if (navigator.geolocation) {
          APIinterface.showLoadingBox("", this.$q);
          navigator.geolocation.getCurrentPosition(
            (data) => {
              APIinterface.hideLoadingBox(this.$q);
              this.$router.push(this.redirect);
            },
            (error) => {
              APIinterface.hideLoadingBox(this.$q);
              console.debug(error);
              APIinterface.notify(
                "red-5",
                error.message,
                "error_outline",
                this.$q
              );
            }
          );
        }
      } else {
        APIinterface.showLoadingBox("", this.$q);
        AppLocation.checkAccuracy()
          .then((data) => {
            this.$router.push(this.redirect);
          })
          .catch((error) => {
            APIinterface.notify("red-5", error, "error_outline", this.$q);
          })
          .then((data) => {
            APIinterface.hideLoadingBox(this.$q);
          });
      }
    },
    //
  },
};
</script>
