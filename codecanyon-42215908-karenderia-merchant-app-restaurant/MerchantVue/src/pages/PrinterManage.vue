<template>
  <q-page class="q-pa-md bg-white text-dark">
    <canvas
      class="receiptCanvas border hidden"
      ref="receiptCanvas"
      height="100"
    ></canvas>

    <template v-if="loading_get">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>

    <q-form v-else @submit="onSubmit">
      <q-select
        outlined
        v-model="printer_model"
        :label="$t('Printer Model')"
        color="grey-5"
        stack-label
        behavior="menu"
        transition-show="fade"
        transition-hide="fade"
        :options="DataStore.printer_list"
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        emit-value
        map-options
      />

      <template v-if="printer_model == 'feieyun'">
        <q-input
          v-model="printer_name"
          :label="$t('Name')"
          outlined
          stack-label
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />
        <q-input
          v-model="printer_user"
          :label="$t('USER')"
          outlined
          stack-label
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />
        <q-input
          v-model="printer_ukey"
          :label="$t('UKEY')"
          outlined
          stack-label
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />
        <q-input
          v-model="printer_sn"
          :label="$t('SN')"
          outlined
          stack-label
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />
        <q-input
          v-model="printer_key"
          label="KEY"
          outlined
          stack-label
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />
      </template>
      <template v-else>
        <q-input
          v-model="printer_device_name"
          :label="$t('Search printer')"
          outlined
          stack-label
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
          readonly
        >
          <template v-slot:append>
            <q-icon
              name="search"
              color="dark"
              class="cursor-pointer"
              @click="searchBT"
            />
          </template>
        </q-input>
      </template>

      <template v-if="printer_model != 'feieyun'">
        <q-input
          v-model="printer_name"
          :label="$t('Name')"
          outlined
          stack-label
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />
        <q-select
          outlined
          v-model="service_id"
          :label="$t('Service ID')"
          color="grey-5"
          stack-label
          behavior="menu"
          transition-show="fade"
          transition-hide="fade"
          :options="services_list"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
          emit-value
          map-options
        />
        <q-select
          outlined
          v-model="characteristics"
          :label="$t('Characteristics')"
          color="grey-5"
          stack-label
          behavior="menu"
          transition-show="fade"
          transition-hide="fade"
          :options="characteristics_list"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
          emit-value
          map-options
        />
      </template>

      <q-select
        outlined
        v-model="paper_width"
        :label="$t('Paper width')"
        color="grey-5"
        stack-label
        behavior="menu"
        transition-show="fade"
        transition-hide="fade"
        :options="paper_type"
        :rules="[
          (val) =>
            (val !== null && val !== undefined && val !== '' && val !== 0) ||
            $t('This field is required'),
        ]"
        emit-value
        map-options
      />

      <q-list>
        <q-item tag="label" v-ripple class="border-grey rounded-corner">
          <q-item-section>
            <q-item-label>{{ $t("Set as default printer") }}</q-item-label>
          </q-item-section>
          <q-item-section avatar>
            <q-toggle color="primary" v-model="auto_print" />
          </q-item-section>
        </q-item>
      </q-list>

      <q-space class="q-pa-md"></q-space>

      <q-footer
        class="row beautiful-shadow q-pa-md q-gutter-x-sm bg-white text-dark"
      >
        <q-btn
          v-if="hasPrinter2"
          no-caps
          unelevated
          color="disabled"
          text-color="disabled"
          class="radius10 col"
          size="lg"
          @click="PrintTest"
          icon="las la-print"
        >
          <div class="text-weight-bold text-subtitle2">
            {{ $t("Print Test") }}
          </div>
        </q-btn>
        <q-btn
          type="submit"
          color="amber-6"
          text-color="disabled"
          unelevated
          class="radius10 col"
          size="lg"
          no-caps
          :loading="loading"
          :disable="!hasPrinter"
        >
          <div class="text-weight-bold text-subtitle2">
            {{ !isEdit ? this.$t("Save Printer") : this.$t("Update") }}
          </div>
        </q-btn>
      </q-footer>
    </q-form>

    <BTprinterList
      ref="btprinter_list"
      @after-selectprinter="afterSelectprinter"
    ></BTprinterList>

    <ConfirmDialog
      ref="confirm_dialog"
      :data="DataStore.data_dialog"
      @after-confirm="afterConfirm"
    ></ConfirmDialog>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useUserStore } from "stores/UserStore";
import { useDataPersisted } from "src/stores/DataPersisted";
import AppBluetooth from "src/api/AppBluetooth";
import PrintTemplate from "src/api/PrintTemplate";
import { Device } from "@capacitor/device";
import { useGlobalStore } from "stores/GlobalStore";
import CBTPrinter from "src/api/CBTPrinter";
import ThermalPrinterFormatter from "src/api/ThermalPrinterFormatter";
import { useOrderStore } from "stores/OrderStore";

export default {
  name: "PrinterManage",
  data() {
    return {
      loading: false,
      loading_get: false,
      printer_id: 0,
      printer_name: "",
      printer_bt_name: "",
      printer_uuid: "",
      printer_device_name: "",
      printer_model: "bluetooth",
      paper_width: "58",
      auto_print: false,
      paper_type: [
        {
          label: "58mm",
          value: "58",
        },
        {
          label: "80mm",
          value: "80",
        },
      ],
      printer_user: "",
      printer_ukey: "",
      printer_sn: "",
      printer_key: "",
      osVersion: 0,
      services_list: [],
      service_id: "",
      characteristics_list: [],
      characteristics: "",
      test_data: [],
    };
  },
  setup() {
    const DataStore = useDataStore();
    const UserStore = useUserStore();
    const GlobalStore = useGlobalStore();
    const DataPersisted = useDataPersisted();
    const OrderStore = useOrderStore();
    return { DataStore, UserStore, GlobalStore, DataPersisted, OrderStore };
  },
  components: {
    BTprinterList: defineAsyncComponent(() =>
      import("components/BTprinterList.vue")
    ),
    ConfirmDialog: defineAsyncComponent(() =>
      import("components/ConfirmDialog.vue")
    ),
  },
  created() {
    this.printer_id = this.$route.query.id;
    if (this.printer_id > 0) {
      this.getPrinter();
    }

    if (this.$q.capacitor) {
      this.getDevice();
      //this.initBT();
    }
  },
  computed: {
    hasPrinter() {
      if (this.printer_model == "feieyun") {
        if (!APIinterface.empty(this.printer_sn)) {
          return true;
        }
      } else {
        if (!APIinterface.empty(this.printer_uuid)) {
          return true;
        }
      }
      return false;
    },
    hasPrinter2() {
      if (this.printer_model == "feieyun") {
        if (!APIinterface.empty(this.printer_sn)) {
          if (parseInt(this.printer_id) > 0) {
            return true;
          }
        }
      } else {
        if (!APIinterface.empty(this.printer_uuid)) {
          return true;
        }
      }
      return false;
    },
    isEdit() {
      if (parseInt(this.printer_id) > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    async getDevice() {
      const info = await Device.getInfo();
      this.osVersion = info.osVersion;
      this.initBT();
    },
    initBT() {
      if (this.osVersion >= 12) {
        AppBluetooth.CheckBTScanPermission()
          .then((data) => {
            //
          })
          .catch((error) => {
            APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
          })
          .then((data) => {
            //
          });
      } else {
        AppBluetooth.CheckLocationOnly()
          .then((data) => {
            //
          })
          .catch((error) => {
            this.$router.push("/settings/location-enabled");
          })
          .then((data) => {
            //
          });
      }
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByToken("SavePrinter", {
        printer_id: this.printer_id,
        printer_name: this.printer_name,
        printer_bt_name: this.printer_bt_name,
        printer_uuid: this.printer_uuid,
        printer_model: this.printer_model,
        paper_width: this.paper_width,
        auto_print: this.auto_print,
        paper_width: this.paper_width,
        device_uuid: this.UserStore.device_uuid,
        printer_user: this.printer_user,
        printer_ukey: this.printer_ukey,
        printer_sn: this.printer_sn,
        printer_key: this.printer_key,
        service_id: this.service_id,
        characteristics: this.characteristics,
      })
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
          // this.DataStore.clearCache();
          // this.OrderStore.clearCache();
          this.clearCache();
          this.$router.replace("/settings/printers");
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    clearCache() {
      this.OrderStore.clearCache();
      this.DataStore.cleanData("printer_list");
      this.DataStore.cleanData("order_data");
    },
    getPrinter() {
      this.loading_get = true;
      APIinterface.fetchDataByTokenPost(
        "PrinterDetails",
        "printer_id=" + this.printer_id
      )
        .then((data) => {
          this.printer_name = data.details.printer_name;
          this.printer_bt_name = data.details.printer_bt_name;
          this.printer_model = data.details.printer_model;
          this.paper_width = data.details.paper_width;
          this.auto_print = data.details.auto_print;
          this.printer_uuid = data.details.printer_uuid;
          this.printer_device_name = data.details.printer_name;

          this.printer_user = data.details.printer_user;
          this.printer_ukey = data.details.printer_ukey;
          this.printer_sn = data.details.printer_sn;
          this.printer_key = data.details.printer_key;

          this.service_id = data.details.service_id;
          this.characteristics = data.details.characteristics;
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading_get = false;
        });
    },
    searchBT() {
      if (this.printer_model == "feieyun") {
        //
      } else {
        if (this.$q.capacitor) {
          this.$refs.btprinter_list.dialog = true;
        } else {
          APIinterface.ShowAlert(
            this.$t("Bluetooth printer only works in mobile device"),
            this.$q.capacitor,
            this.$q
          );
        }
      }
    },
    afterSelectprinter(data, services, characteristics) {
      this.printer_device_name = data.name;
      this.printer_name = data.name;
      this.printer_bt_name = data.name;
      this.printer_uuid = data.address;

      this.services_list = [];
      if (Object.keys(services).length > 0) {
        Object.entries(services).forEach(([key, items]) => {
          let length = items.length;
          this.services_list.push({
            label: items,
            value: items,
          });
        });
      }

      this.characteristics_list = [];
      if (Object.keys(characteristics).length > 0) {
        Object.entries(characteristics).forEach(([key, items]) => {
          let length = items.characteristic.length;
          if (items.properties.includes("Write") === true) {
            this.characteristics = items.characteristic;
          }
          if (items.properties.includes("Write") === true) {
            this.service_id = items.service;
          }
          this.characteristics_list.push({
            label: items.characteristic,
            value: items.characteristic,
          });
        });
      }
    },
    confirmDelete() {
      this.$refs.confirm_dialog.dialog = true;
    },
    afterConfirm() {
      this.$refs.confirm_dialog.dialog = false;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        "deletePrinter",
        "printer_id=" + this.printer_id
      )
        .then((data) => {
          this.DataStore.printerList = null;
          this.$router.replace("/settings/printers");
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    PrintTest() {
      AppBluetooth.Enabled()
        .then((data) => {
          if (this.printer_model == "feieyun") {
            this.FPtestprint();
          } else this.Connect();
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          //
        });
    },
    Connect() {
      APIinterface.showLoadingBox("Connecting...", this.$q);
      AppBluetooth.Connect(this.printer_uuid, this.printer_model)
        .then((data) => {
          if (this.DataPersisted.printer_set == 2) {
            this.binaryTestPrint();
          } else {
            this.Print();
          }
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    Print() {
      let tpl = PrintTemplate.SampleTemplate(this.paper_width);
      console.log("TEMPLATE ==>" + this.paper_width);
      console.log(tpl);

      APIinterface.showLoadingBox("Printing...", this.$q);
      AppBluetooth.Print(
        this.printer_uuid,
        tpl,
        this.printer_model,
        this.service_id,
        this.characteristics
      )
        .then((data) => {
          //
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    FPtestprint() {
      APIinterface.showLoadingBox("Printing...", this.$q);
      APIinterface.fetchDataByTokenPost(
        "FPtestprint",
        "printer_id=" + this.printer_id
      )
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    async binaryTestPrint() {
      APIinterface.showLoadingBox(this.$t("Printing..."), this.$q);

      let header = [],
        body = [],
        footer = [];

      header = [
        {
          position: "left",
          type: "line_break",
          value: "",
        },
        {
          position: "left",
          type: "font",
          font_type: "bold",
        },
        {
          position: "center",
          type: "text",
          value: "TEST RECEIPT",
        },
        {
          position: "left",
          type: "line_break",
          value: "",
        },
        {
          position: "left",
          type: "font",
          font_type: "normal",
        },
      ];

      body = [
        {
          position: "left_right_text",
          type: "text",
          label: "1 x burger",
          value: "3.00",
        },
        {
          position: "left_right_text",
          type: "text",
          label: "2 x Chicken",
          value: "23.00",
        },
        {
          position: "left_right_text",
          type: "text",
          label: "5 x Sauce",
          value: "100.00",
        },
      ];

      footer = [
        {
          position: "left",
          type: "dotted_line",
          value: "-",
        },
        {
          position: "left_right_text",
          type: "text",
          label: "TOTAL AMOUNT",
          value: "126.00",
        },
        {
          position: "left_right_text",
          type: "text",
          label: "CASH",
          value: "200.00",
        },
        {
          position: "left_right_text",
          type: "text",
          label: "CHANGE",
          value: "74.00",
        },
        {
          position: "left",
          type: "line_break",
          value: "",
        },
        {
          position: "center",
          type: "text",
          value: "THANK YOU!",
        },
        {
          position: "left",
          type: "line_break",
          value: "",
        },
      ];

      try {
        let results = ThermalPrinterFormatter.Print(
          {
            page_width: this.paper_width,
            print_type: "image",
          },
          header,
          body,
          footer,
          this.$refs.receiptCanvas
        );
        await CBTPrinter.ConnectToPrinter(this.printer_device_name);
        this.loading_print = false;
        await CBTPrinter.printPOSCommand("0A");
        await CBTPrinter.printPOSCommand("1B6100");
        await CBTPrinter.printBase64(results, 0);

        APIinterface.hideLoadingBox(this.$q);
        APIinterface.ShowSuccessful(this.$t("Printing Successful"), this.$q);
      } catch (error) {
        console.log("eror", error);
        APIinterface.hideLoadingBox(this.$q);
        APIinterface.ShowAlert(error.message, this.$q.capacitor, this.$q);
      } finally {
        APIinterface.hideLoadingBox(this.$q);
      }
    },
  },
};
</script>
