<template>
  <div class="row justify-between items-center q-mb-sm">
    <div class="col-4">
      <div class="text-h6">{{ $t("Printers") }}</div>
    </div>
    <div class="col-4 text-right q-gutter-x-md">
      <template v-if="!is_add_printer">
        <q-btn
          round
          color="blue-15"
          icon="eva-refresh-outline"
          no-caps
          @click="refreshList"
        />
      </template>
      <q-btn
        round
        color="primary"
        :icon="is_add_printer ? 'eva-close-outline' : 'eva-plus-outline'"
        no-caps
        @click="is_add_printer = !is_add_printer"
      />
    </div>
  </div>

  <template v-if="is_add_printer">
    <!-- ADD PRINTER FORM -->
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
        <template v-if="hasPrinter">
          <q-item clickable @click="TestPrint">
            <q-item-section class="text-centerx text-body1 text-weight-bold">
              <div class="flex justify-center items-center q-gutter-x-sm">
                <div>
                  <q-icon name="eva-printer-outline" size="md"></q-icon>
                </div>
                <div>{{ $t("Print test") }}</div>
              </div>
            </q-item-section>
          </q-item>
        </template>
        <q-item style="min-height: normal"> </q-item>
      </q-list>

      <div class="q-gutter-y-md">
        <q-btn
          color="primary"
          :label="$t('Save')"
          class="fit radius-10"
          unelevated
          :size="$q.screen.gt.sm ? 'lg' : '15px'"
          type="submit"
          no-caps
          :loading="loading"
        />

        <template v-if="isEdit">
          <q-btn
            color="negative"
            :label="$t('Delete Printer')"
            class="fit radius-10"
            unelevated
            :size="$q.screen.gt.sm ? 'lg' : '15px'"
            no-caps
            @click="confirmDelete()"
        /></template>
      </div>
    </q-form>

    <q-space class="q-pa-md"></q-space>

    <!-- ADD PRINTE FORM -->
  </template>
  <template v-else>
    <!-- DISPLAY PRINTER -->

    <template v-if="KitchenStore.printer_loading">
      <div class="card-form-height-50">
        <q-inner-loading showing color="primary"></q-inner-loading>
      </div>
    </template>

    <q-list separator>
      <template v-for="items in KitchenStore.getPrinters" :key="items">
        <q-item clickable @click="GetPrinter(items)">
          <q-item-section avatar>
            <q-avatar
              color="grey-3"
              text-color="grey"
              icon="eva-printer-outline"
            />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ items.printer_name }}</q-item-label>
            <q-item-label caption>
              {{ items.paper_width }}
            </q-item-label>
          </q-item-section>
          <q-item-section side v-if="items.auto_print">
            <q-item-label caption>{{ $t("Auto Print") }}</q-item-label>
          </q-item-section>
        </q-item>
      </template>
    </q-list>
    <!-- DISPLAY PRINTER -->
  </template>

  <PrinterSearch
    ref="ref_printer"
    @after-selectprinter="afterSelectprinter"
  ></PrinterSearch>

  <PrinterPreview ref="ref_print"> </PrinterPreview>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useKitchenStore } from "stores/KitchenStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "PrinterManage",
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
      is_add_printer: false,
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
      printer_bt_name: "MPT-2",
      paper_width: "58",
      auto_print: false,
      auto_close: false,
      device_id: "",
      service_id: "",
      characteristic: "",
      print_type: "raw",
      printer_user: "",
      printer_ukey: "",
      printer_sn: "",
      printer_key: "",
    };
  },
  watch: {
    is_add_printer(newval, old) {
      console.log("new", newval);
      if (!newval) {
        if (this.printer_id) {
          this.clearField();
        }
      }
    },
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
  mounted() {
    if (!this.KitchenStore.printer_data) {
      this.KitchenStore.PrinterList();
    }
    this.printer_id = null;
  },
  methods: {
    refreshList() {
      this.is_add_printer = false;
      this.KitchenStore.printer_data = null;
      this.printer_id = null;
      this.KitchenStore.PrinterList();
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
      params += "&auto_close=" + (this.auto_close == 1 ? 1 : 0);

      params += "&device_id=" + this.device_id;
      params += "&printer_bt_name=" + this.printer_bt_name;
      params += "&service_id=" + this.service_id;
      params += "&characteristic=" + this.characteristic;
      params += "&print_type=" + this.print_type;
      params += "&printer_id=" + this.printer_id;

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
          this.is_add_printer = false;
          this.KitchenStore.printer_data = null;
          this.KitchenStore.PrinterList();
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
      this.printer_id = null;
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
    GetPrinter(data) {
      this.clearField();
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataGet("GetPrinter", "printer_id=" + data.printer_id)
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
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    async confirmDelete() {
      console.log("confirmDelete");
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
          this.is_add_printer = false;
          this.KitchenStore.printer_data = null;
          this.printer_id = null;
          this.KitchenStore.PrinterList();
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
    //
  },
};
</script>
