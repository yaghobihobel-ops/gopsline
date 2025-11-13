<template>
  <q-dialog
    v-model="dialog"
    position="bottom"
    @show="whenShow"
    @hide="stopScan"
    persistent
  >
    <q-card class="rounded-borders-top">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-dark text-weight-bold"
          style="overflow: inherit"
        >
          <q-circular-progress
            v-if="loading"
            indeterminate
            size="20px"
            :thickness="0.22"
            rounded
            color="primary"
            track-color="grey-3"
            class="q-mr-sm"
          />
          {{ $t("Bluetooth Printer") }}
        </q-toolbar-title>
        <q-space></q-space>
        <q-btn
          @click="dialog = !true"
          color="white"
          square
          unelevated
          text-color="grey"
          icon="las la-times"
          dense
          no-caps
          size="sm"
          class="border-grey radius8"
        />
      </q-toolbar>

      <q-list separator>
        <!-- <template v-for="items in new_data" :key="items"> -->
        <template v-for="item in new_data" :key="item">
          <q-item clickable @click="setPrinter(item)">
            <q-item-section>{{ item.name }}</q-item-section>
          </q-item>
        </template>
        <!-- </template> -->
      </q-list>

      <!-- <pre>{{ new_data }}</pre> -->
      <!-- <pre>{{ data }}</pre> -->
      <!-- <pre>{{ device_list }}</pre>
      <pre>{{ new_data }}</pre> -->
      <q-space class="q-pa-xl"></q-space>

      <q-footer class="bg-white border-grey-top q-pa-sm row">
        <div class="col"></div>
        <q-btn
          flat
          :label="$t('Cancel')"
          color="dark"
          @click="stopScan"
          no-caps
          class="col"
        />
      </q-footer>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import AppBluetooth from "src/api/AppBluetooth";

export default {
  name: "BTprinterList",
  data() {
    return {
      dialog: false,
      loading: false,
      data: [],
      new_data: [],
      device_list: [],
      paired_data: [],
    };
  },
  setup() {
    return {};
  },
  watch: {
    paired_data(newval, oldval) {
      console.log("PAIRED DATA=>");
      console.log(JSON.stringify(newval));
      if (Object.keys(newval).length > 0) {
        Object.entries(newval).forEach(([key, items]) => {
          this.new_data.push({
            name: items.name,
            address: items.address,
          });
          this.device_list.push(items.address);
        });
      }
    },
    data(newval, oldval) {
      if (Object.keys(newval).length > 0) {
        Object.entries(newval).forEach(([key, items]) => {
          let $find = this.device_list.includes(items.address);
          if (!$find) {
            this.new_data.push({
              name: items.name,
              address: items.address,
            });
          }
          this.device_list.push(items.address);
        });
      }
    },
  },
  methods: {
    whenShow() {
      this.device_list = [];
      this.data = [];
      this.new_data = [];
      this.initBT();
    },
    setPrinter(data) {
      this.dialog = false;
      this.stopScan();

      APIinterface.showLoadingBox("", this.$q);
      AppBluetooth.GetServices(data.address)
        .then((result) => {
          this.disconnectBT(data.address);
          this.$emit(
            "afterSelectprinter",
            data,
            result.services,
            result.characteristics
          );
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    disconnectBT(deviceAddress) {
      AppBluetooth.Disconnect(deviceAddress)
        .then((result) => {})
        .catch((error) => {})
        .then((data) => {
          //
        });
    },
    initBT() {
      AppBluetooth.Enabled()
        .then((data) => {
          this.retrieveDevice();
          setTimeout(() => {
            this.Scan();
          }, 100); // 1 sec delay
        })
        .catch((error) => {
          APIinterface.notify("dark", error.message, "error", this.$q);
        })
        .then((data) => {
          //
        });
    },
    stopScan() {
      AppBluetooth.StopScan()
        .then((data) => {
          this.dialog = false;
        })
        .catch((error) => {
          this.dialog = false;
        })
        .then((data) => {});
    },
    Scan() {
      this.loading = true;
      AppBluetooth.Scan()
        .then((data) => {
          this.data = data;
        })
        .catch((error) => {
          this.data = [];
          APIinterface.notify("dark", error.message, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    retrieveDevice() {
      AppBluetooth.retrieveDevice()
        .then((data) => {
          this.paired_data = data;
        })
        .catch((error) => {
          this.paired_data = [];
          //APIinterface.notify("dark", error.message, "error", this.$q);
        })
        .then((data) => {});
    },
  },
};
</script>
