<template>
  <q-header
    reveal
    reveal-offset="10"
    :class="{
      'bg-custom-grey text-dark': !$q.dark.mode,
      'bg-grey600 text-grey300': $q.dark.mode,
    }"
  >
    <q-toolbar style="border-bottom-right-radius: 25px">
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="eva-arrow-ios-back-outline"
      />
      <q-toolbar-title style="font-size: 14px">{{
        $t("Add Printer")
      }}</q-toolbar-title>

      <template v-if="isEdit">
        <q-btn
          no-caps
          round
          unelevated
          flat
          icon="eva-trash-2-outline"
          color="red-5"
          @click="confirmDelete()"
        ></q-btn>
      </template>
    </q-toolbar>
  </q-header>
  <q-page v-if="!loading_get" class="q-pa-md">
    <q-form @submit="onSubmit">
      <q-input
        outlined
        v-model="printer_name"
        :label="$t('Name')"
        no-error-icon
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This is required'),
        ]"
      >
      </q-input>

      <q-select
        outlined
        v-model="printer_model"
        :label="$t('Printer Model')"
        stack-label
        behavior="dialog"
        transition-show="fade"
        transition-hide="fade"
        :options="KitchenStore.getPrinterList"
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        emit-value
        map-options
      />

      <template v-if="printer_model == 'feieyun'">
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
          :label="$t('KEY')"
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
          outlined
          v-model="printer_bt_name"
          :label="$t('Bluetooth printer')"
          readonly
          class="q-mb-md"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        >
          <template v-slot:append>
            <q-btn
              :label="$t('Search')"
              no-caps
              color="green"
              @click="showSearchPrinter"
            >
            </q-btn>
          </template>
        </q-input>

        <!-- <div>device_id : {{ device_id }}</div>
        <div>service_id : {{ service_id }}</div>
        <div>characteristic : {{ characteristic }}</div> -->

        <q-select
          outlined
          v-model="print_type"
          :label="$t('Printing Type')"
          stack-label
          behavior="dialog"
          transition-show="fade"
          transition-hide="fade"
          :options="print_type_list"
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
        stack-label
        behavior="dialog"
        transition-show="fade"
        transition-hide="fade"
        :options="paper_type"
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        emit-value
        map-options
      />

      <q-list separator>
        <q-item tag="label" v-ripple>
          <q-item-section>
            <q-item-label>{{ $t("Print automatically") }}</q-item-label>
          </q-item-section>
          <q-item-section avatar>
            <q-toggle color="primary" v-model="auto_print" />
          </q-item-section>
        </q-item>
        <q-item tag="label" v-ripple>
          <q-item-section>
            <q-item-label>{{ $t("Auto close") }}</q-item-label>
            <q-item-label caption>
              {{ $t("close printer connection after printing") }}
            </q-item-label>
          </q-item-section>
          <q-item-section avatar>
            <q-toggle color="primary" v-model="auto_close" />
          </q-item-section>
        </q-item>
        <q-item clickable v-if="hasPrinter">
          <q-item-section
            class="text-centerx text-body1 text-weight-bold"
            @click="TestPrint"
          >
            <div class="flex justify-center items-center q-gutter-x-sm">
              <div>
                <q-icon name="eva-printer-outline" size="md"></q-icon>
              </div>
              <div>{{ $t("Print test") }}</div>
            </div>
          </q-item-section>
        </q-item>
        <q-item style="min-height: normal"> </q-item>
      </q-list>

      <q-footer>
        <q-btn
          color="primary"
          :label="$t('Save')"
          class="fit radius-10"
          unelevated
          :size="$q.screen.gt.sm ? 'xl' : 'lg'"
          type="submit"
          no-caps
          :loading="loading"
        />
      </q-footer>
    </q-form>

    <PrinterSearch
      ref="ref_printer"
      @after-selectprinter="afterSelectprinter"
    ></PrinterSearch>

    <PrinterPreview ref="ref_print"> </PrinterPreview>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useKitchenStore } from "stores/KitchenStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "PrinterAdd",
  components: {
    PrinterSearch: defineAsyncComponent(() =>
      import("components/PrinterSearch.vue")
    ),
    PrinterPreview: defineAsyncComponent(() =>
      import("components/PrinterPreview.vue")
    ),
  },
  setup() {
    const KitchenStore = useKitchenStore();
    return { KitchenStore };
  },
  data() {
    return {
      loading: false,
      loading_get: false,
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
      print_type_list: [
        {
          label: "Esc/Pos",
          value: "raw",
        },
        {
          label: "Image",
          value: "image",
        },
      ],
      printer_id: null,
      printer_name: "",
      printer_model: "bluetooth",
      printer_bt_name: "",
      paper_width: "58",
      auto_print: false,
      device_id: "",
      service_id: "",
      characteristic: "",
      print_type: "raw",
      printer_user: "",
      printer_ukey: "",
      printer_sn: "",
      printer_key: "",
      auto_close: false,
    };
  },
  mounted() {
    this.printer_id = this.$route.query.id;
    if (this.printer_id > 0) {
      this.GetPrinter();
    }
  },
  computed: {
    hasPrinter() {
      if (this.printer_model == "feieyun") {
        if (!APIinterface.empty(this.printer_id)) {
          return true;
        }
      } else {
        if (!APIinterface.empty(this.device_id)) {
          return true;
        }
      }
      return false;
    },
    isEdit() {
      if (this.printer_id) {
        return true;
      }
      return false;
    },
  },
  methods: {
    GetPrinter() {
      this.clearField();
      this.loading_get = true;
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataGet("GetPrinter", "printer_id=" + this.printer_id)
        .then((data) => {
          this.is_add_printer = true;
          this.printer_id = data.printer_id;
          this.printer_model = data.printer_model;
          this.printer_name = data.printer_name;
          this.paper_width = data.paper_width;
          this.auto_print = data.auto_print == 1 ? true : false;
          this.auto_close = data.auto_close == 1 ? true : false;

          switch (this.printer_model) {
            case "bluetooth":
            case "bleutooth":
              this.printer_bt_name = data.printer_bt_name;
              this.device_id = data.device_id;
              this.service_id = data.service_id;
              this.characteristic = data.characteristic;
              this.print_type = data.print_type;
              break;
            case "feieyun":
              this.printer_user = data.printer_user;
              this.printer_ukey = data.printer_ukey;
              this.printer_sn = data.printer_sn;
              this.printer_key = data.printer_key;
              break;
          }
          //
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
          this.$router.replace("/settings-mobile/printers");
        })
        .then((data) => {
          this.loading_get = false;
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    onSubmit() {
      this.loading = true;
      let params = "printer_model=" + this.printer_model;
      params += "&printer_name=" + this.printer_name;
      params += "&printer_user=" + this.printer_user;
      params += "&printer_ukey=" + this.printer_ukey;
      params += "&printer_sn=" + this.printer_sn;
      params += "&printer_key=" + this.printer_key;

      params += "&paper_width=" + this.paper_width;
      params += "&auto_print=" + (this.auto_print == 1 ? 1 : 0);

      params += "&device_id=" + this.device_id;
      params += "&printer_bt_name=" + this.printer_bt_name;
      params += "&service_id=" + this.service_id;
      params += "&characteristic=" + this.characteristic;
      params += "&print_type=" + this.print_type;
      params += "&printer_id=" + this.printer_id;
      params += "&auto_close=" + this.auto_close;

      APIinterface.fetchDataPost("SavePrinter", params)
        .then((data) => {
          APIinterface.notify(
            this.$q,
            this.$t("Printers"),
            data.msg,
            "mysuccess",
            "highlight_off",
            "bottom"
          );
          this.KitchenStore.printer_data = null;
          this.KitchenStore.PrinterList();
          this.$router.replace("/settings-mobile/printers");
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
          this.loading = false;
        });
    },
    clearField() {
      this.printer_name = "";
      this.printer_model = "bluetooth";
      this.paper_width = "58";
      this.auto_print = false;
      this.printer_bt_name = "";
      this.device_id = "";
      this.service_id = "";
      this.characteristic = "";
      this.print_type = "raw";
      this.printer_user = "";
      this.printer_ukey = "";
      this.printer_sn = "";
      this.printer_key = "";
    },
    async confirmDelete() {
      APIinterface.confirm(
        this.$q,
        "Delete Confirmation",
        "Are you sure you want to permanently delete the selected item?",
        "Yes",
        "Cancel",
        this.$t
      )
        .then((data) => {
          this.deletePrinter();
        })
        .catch((error) => {
          console.log("error", error);
        })
        .then((data) => {});
    },
    deletePrinter() {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataGet(
        "DeletePrinter",
        "printer_id=" + this.printer_id
      )
        .then((data) => {
          this.clearField();
          this.KitchenStore.printer_data = null;
          this.KitchenStore.PrinterList();
          this.$router.replace("/settings-mobile/printers");
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
    showSearchPrinter() {
      this.clearField();
      if (this.$q.capacitor) {
        this.$refs.ref_printer.modal = true;
      } else {
        APIinterface.notify(
          this.$q,
          this.$t("Error"),
          this.$t(
            "Bluetooth printing is not supported in the web version. Please use the mobile device."
          ),
          "myerror",
          "highlight_off",
          "bottom"
        );
      }
    },
    afterSelectprinter(data) {
      this.printer_bt_name = data.printer_bt_name;
      this.device_id = data.device_id;
      this.service_id = data.service_id;
      this.characteristic = data.characteristic;
      if (APIinterface.empty(this.printer_name)) {
        this.printer_name = this.printer_bt_name;
      }
    },
    TestPrint() {
      if (this.printer_model == "feieyun") {
        APIinterface.showLoadingBox(this.$t("Printing..."), this.$q);
        APIinterface.fetchDataPost(
          "TestPrintFP",
          "printer_id=" + this.printer_id
        )
          .then((data) => {
            APIinterface.notify(
              this.$q,
              this.$t("Print"),
              data.msg,
              "mysuccess",
              "highlight_off",
              "bottom"
            );
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
      } else {
        let data = {
          data: {
            settings: {
              print_type: this.print_type,
              page_width: this.paper_width,
              printer_bt_name: this.printer_bt_name,
              device_id: this.device_id,
              service_id: this.service_id,
              characteristics: this.characteristic,
              auto_close: this.auto_close,
            },
            header: this.KitchenStore.print_header,
            body: this.KitchenStore.print_body,
            footer: this.KitchenStore.print_footer,
          },
        };
        this.$refs.ref_print.print(data);
      }
    },
  },
  //
};
</script>
