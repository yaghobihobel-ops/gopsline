<template>
  <q-page class="q-pa-md flex flex-center bg-white text-dark">
    <div class="full-width text-center">
      <q-img
        src="location-enabled.png"
        style="height: 150px; max-width: 200px"
        fit="contain"
        class="q-mb-sm"
      />
      <p class="text-body2 text-grey">
        {{
          $t(
            "We need your location enabled to find and connect to bluetooth printers"
          )
        }}.
      </p>
    </div>
    <q-footer
      class="q-pa-md"
      :class="{
        'bg-mydark ': $q.dark.mode,
        'bg-white ': !$q.dark.mode,
      }"
    >
      <q-btn
        type="submit"
        color="primary"
        rounded
        unelevated
        class="full-width"
        size="lg"
        no-caps
        @click="enabledLocation"
      >
        <div class="text-weight-bold text-subtitle2">
          {{ $t("Enabled Location") }}
        </div>
      </q-btn>
    </q-footer>
  </q-page>
</template>

<script>
import AppBluetooth from "src/api/AppBluetooth";
import APIinterface from "src/api/APIinterface";
import AppLocation from "src/api/AppLocation";
import { Device } from "@capacitor/device";

export default {
  name: "LocationEnabled",
  data() {
    return {
      osVersion: 0,
    };
  },
  created() {
    if (this.$q.capacitor) {
      this.getDevice();
    }
  },
  methods: {
    async getDevice() {
      const info = await Device.getInfo();
      console.log(JSON.stringify(info));
      this.osVersion = info.osVersion;
    },
    enabledLocation() {
      if (this.osVersion >= 12) {
        AppBluetooth.CheckBTConnectPermission()
          .then((data) => {
            //
            AppBluetooth.CheckBTScanPermission()
              .then((data) => {
                this.$router.go(-1);
              })
              .catch((error) => {
                if (!APIinterface.empty(error.message)) {
                  APIinterface.ShowAlert(
                    error.message,
                    this.$q.capacitor,
                    this.$q
                  );
                } else {
                  APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
                }
              })
              .then((data) => {
                //
              });

            //
          })
          .catch((error) => {
            if (!APIinterface.empty(error.message)) {
              APIinterface.ShowAlert(error.message, this.$q.capacitor, this.$q);
            } else {
              APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
            }
          })
          .then((data) => {
            //
          });
      } else {
        AppBluetooth.CheckLocation()
          .then((data) => {
            this.$router.go(-1);
          })
          .catch((error) => {
            if (!APIinterface.empty(error.message)) {
              APIinterface.ShowAlert(error.message, this.$q.capacitor, this.$q);
            } else {
              APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
            }
          })
          .then((data) => {
            //
          });
      }
    },
  },
};
</script>
