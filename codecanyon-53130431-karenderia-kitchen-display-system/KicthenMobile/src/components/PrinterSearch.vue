<template>
  <q-dialog
    v-model="modal"
    :maximized="this.$q.screen.lt.sm ? true : false"
    :position="this.$q.screen.lt.sm ? 'bottom' : 'standard'"
    persistent
    @before-show="BeforeShow"
  >
    <q-card style="min-width: 300px">
      <q-card-section>
        <div class="flex items-center q-gutter-x-sm">
          <div v-if="search_loading">
            <q-circular-progress
              indeterminate
              size="30px"
              :thickness="0.22"
              rounded
              color="primary"
              track-color="grey-3"
            />
          </div>
          <div>
            <div class="text-h6 text-dark">{{ $t("Bluetooth printer") }}</div>
            <div class="text-body2" v-if="search_loading">
              {{ $t("Searching") }}....
            </div>
          </div>
        </div>
      </q-card-section>
      <q-card-section
        class="q-pt-none q-pb-none"
        style="min-height: calc(10vh)"
      >
        <template v-if="!search_loading">
          <template v-if="hasList">
            <q-list>
              <template v-for="items in list" :key="items">
                <q-item clickable @click="getCharacteristic(items)">
                  <q-item-section>
                    <q-item-label>{{
                      items.name
                    }}</q-item-label></q-item-section
                  >
                </q-item>
              </template>
            </q-list>
          </template>
          <template v-else>
            <div>
              <p>{{ $t("No printer found") }}</p>
            </div>
          </template>
        </template>
      </q-card-section>
      <q-card-actions align="right">
        <q-btn
          flat
          :label="$t('Cancel')"
          color="primary"
          no-caps
          @click="CancelSearch"
          :size="$q.screen.gt.sm ? 'xl' : 'lg'"
        />
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import AppBluetooth from "src/api/AppBluetooth";
import APIinterface from "src/api/APIinterface";

export default {
  name: "PrinterSearch",
  data() {
    return {
      modal: false,
      search_loading: false,
      list: [],
      printer_bt_name: null,
      device_id: null,
      service_id: null,
      characteristic: null,
      characteristic_list: null,
    };
  },
  setup() {
    return {};
  },
  computed: {
    hasList() {
      if (Object.keys(this.list).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    BeforeShow() {
      this.search_loading = false;
      this.ResetField();
      this.SearchPrinter();
    },
    ResetField() {
      this.list = [];
      this.printer_bt_name = null;
      this.device_id = null;
      this.service_id = null;
      this.characteristic = null;
      this.characteristic_list = null;
    },
    SearchPrinter() {
      this.search_loading = true;
      AppBluetooth.initConnect(this.$q).then((data) => {
        AppBluetooth.Scan()
          .then((data) => {
            this.list = data;
          })
          .catch((error) => {})
          .then((data) => {
            this.search_loading = false;
          });
      });
    },
    CancelSearch() {
      AppBluetooth.StopScan();
      this.modal = false;
    },
    getCharacteristic(data) {
      APIinterface.showLoadingBox("", this.$q);
      this.printer_bt_name = data.name;
      this.device_id = data.device_id;
      this.service_id = data.service_id;
      this.characteristic_list = [];
      AppBluetooth.getCharacteristic(data.device_id)
        .then((data) => {
          this.modal = false;
          this.characteristic = data.default;
          this.characteristic_list = data.list;
          this.$emit("afterSelectprinter", {
            printer_bt_name: this.printer_bt_name,
            device_id: this.device_id,
            service_id: this.service_id,
            characteristic: this.characteristic,
            characteristic_list: this.characteristic_list,
          });
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
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
