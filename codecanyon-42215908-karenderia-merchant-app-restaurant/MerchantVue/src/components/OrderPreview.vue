<template>
  <q-dialog v-model="dialog" position="bottom" @show="whenShow">
    <q-card class="rounded-borders-top">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title class="text-dark text-weight-bold">
          {{ $t("Order") }}
          <span class="text-primary">#{{ data.order_id_raw }}</span>
        </q-toolbar-title>
        <q-space></q-space>
        <q-btn
          @click="showPrinter"
          color="white"
          square
          unelevated
          text-color="grey"
          icon="las la-print"
          dense
          no-caps
          size="sm"
          class="border-grey radius8 q-mr-md"
        />
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

      <div class="q-pl-md q-pr-md q-mb-sm">
        <div class="text-right">
          <q-btn
            flat
            :color="$q.dark.mode ? 'secondary' : 'blue'"
            no-caps
            :label="$t('View full order details')"
            dense
            size="md"
            :to="{
              path: '/orderview',
              query: { order_uuid: data.order_uuid },
            }"
          />
        </div>

        <q-list
          class="radius8"
          :class="{
            'bg-grey600 text-grey300': $q.dark.mode,
            'bg-lightprimary text-black': !$q.dark.mode,
          }"
        >
          <q-item v-for="items in data.items" :key="items">
            <q-item-section avatar>
              <q-img
                :src="items_details[items.item_id].photo"
                lazy
                fit="cover"
                style="height: 70px; width: 70px"
                class="radius8"
                spinner-color="secondary"
                spinner-size="sm"
                placeholder-src="placeholder.png"
              />
            </q-item-section>
            <q-item-section>
              <q-item-label>
                <div class="font13 text-weight-bold no-margin line-normal">
                  <span v-html="items_details[items.item_id].item_name"></span>
                </div>
                <div class="text-grey font11 line-normal">
                  {{ items.qty }} x

                  <template v-if="items.discount > 0">
                    <span class="text-strike">
                      <NumberFormat :amount="1 * items.price"></NumberFormat>
                      <!-- {{ items.price }} -->
                    </span>
                    <NumberFormat
                      :amount="items.price - items.discount"
                    ></NumberFormat>
                  </template>
                  <template v-else>
                    <NumberFormat :amount="1 * items.price"></NumberFormat>
                  </template>
                </div>
                <div class="font14 text-weight-bold">
                  <NumberFormat
                    :amount="items.qty * items.price"
                  ></NumberFormat>
                </div>
              </q-item-label>
            </q-item-section>
          </q-item>
        </q-list>

        <q-space class="q-pa-sm"></q-space>
        <div
          class="row items-center justify-between q-pl-xl q-pt-sm border-grey-top text-weight-bold"
        >
          <div>{{ $t("Total") }}</div>
          <div>
            {{ data.total }}
          </div>
        </div>
        <q-space class="q-pa-xs"></q-space>
        <!-- =>{{ hasMoreButtons(settings_tabs, data.status_raw) }} -->
        <div
          class="q-gutter-sm"
          :class="{
            row: !hasMoreButtons(settings_tabs, data.status_raw),
            column: hasMoreButtons(settings_tabs, data.status_raw),
          }"
        >
          <template v-if="settings_tabs[data.status_raw]">
            <template
              v-if="settings_tabs[data.status_raw].group_name == 'order_ready'"
            >
              <template
                v-if="
                  order_group_buttons[settings_tabs[data.status_raw].group_name]
                "
              >
                <template
                  v-if="
                    order_group_buttons[
                      settings_tabs[data.status_raw].group_name
                    ][data.order_type]
                  "
                >
                  <template
                    v-for="button in order_group_buttons[
                      settings_tabs[data.status_raw].group_name
                    ][data.order_type]"
                    :key="button"
                  >
                    <div class="col">
                      <template v-if="order_buttons[button]">
                        <q-btn
                          v-if="
                            data.status_raw.toLowerCase().trim() !=
                            order_buttons[button].button_name
                              .toLowerCase()
                              .trim()
                          "
                          size="lg"
                          unelevated
                          :color="changeColor(order_buttons[button].class_name)"
                          :text-color="
                            changeTextColor(order_buttons[button].class_name)
                          "
                          no-caps
                          :label="order_buttons[button].button_name"
                          class="radius8 fit line-1"
                          @click="doActions(order_buttons[button])"
                        ></q-btn>
                      </template>
                    </div>
                  </template>
                </template>
              </template>
            </template>
            <template v-else>
              <template
                v-if="
                  order_group_buttons[settings_tabs[data.status_raw].group_name]
                "
              >
                <template
                  v-for="button in order_group_buttons[
                    settings_tabs[data.status_raw].group_name
                  ].none"
                  :key="button"
                >
                  <div class="col">
                    <template v-if="order_buttons[button]">
                      <q-btn
                        v-if="
                          data.status_raw.toLowerCase().trim() !=
                          order_buttons[button].button_name.toLowerCase().trim()
                        "
                        size="lg"
                        unelevated
                        no-caps
                        :label="order_buttons[button].button_name"
                        class="radius8 fit line-1"
                        @click="doActions(order_buttons[button])"
                        :color="changeColor(order_buttons[button].class_name)"
                        :text-color="
                          changeTextColor(order_buttons[button].class_name)
                        "
                      ></q-btn>
                    </template>
                  </div>
                </template>
              </template>
            </template>
          </template>
        </div>

        <!-- // -->
      </div>
    </q-card>
  </q-dialog>
  <RejectionList
    ref="rejection"
    @after-addreason="afterAddreason"
  ></RejectionList>
  <PrinterList
    ref="printer"
    @after-selectprinter="afterSelectprinter"
  ></PrinterList>

  <PrintPreviewCanvas
    ref="print_preview"
    :printer_details="printer_details"
    :order_info="OrderStore.order_info"
    :merchant="OrderStore.merchant"
    :order_items="OrderStore.order_items"
    :order_summary="OrderStore.order_summary"
    :site_data="OrderStore.site_data"
  ></PrintPreviewCanvas>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useOrderStore } from "stores/OrderStore";
import PrintTemplate from "src/api/PrintTemplate";
import AppBluetooth from "src/api/AppBluetooth";
import { useDataStore } from "stores/DataStore";
import { Device } from "@capacitor/device";
import { useDataPersisted } from "stores/DataPersisted";

export default {
  name: "OrderPreview",
  props: [
    "data",
    "items_details",
    "settings_tabs",
    "order_group_buttons",
    "order_buttons",
  ],
  components: {
    NumberFormat: defineAsyncComponent(() =>
      import("components/NumberFormat.vue")
    ),
    RejectionList: defineAsyncComponent(() =>
      import("components/RejectionList.vue")
    ),
    PrinterList: defineAsyncComponent(() =>
      import("components/PrinterList.vue")
    ),
    // PrintPreview: defineAsyncComponent(() =>
    //   import("components/PrintPreview.vue")
    // ),
    PrintPreviewCanvas: defineAsyncComponent(() =>
      import("components/PrintPreviewCanvas.vue")
    ),
  },
  data() {
    return {
      dialog: false,
      modal_rejection: false,
      button_uuid: "",
      method: "",
      commission: "",
      printer_details: [],
      osVersion: 0,
    };
  },
  setup() {
    const OrderStore = useOrderStore();
    const DataStore = useDataStore();
    const DataPersisted = useDataPersisted();
    return { OrderStore, DataStore, DataPersisted };
  },
  mounted() {
    if (this.$q.capacitor) {
      this.getDevice();
    }
  },
  methods: {
    async getDevice() {
      const info = await Device.getInfo();
      this.osVersion = info.osVersion;
    },
    changeColor(data) {
      let $color = "mygrey";
      switch (data) {
        case "btn-green":
          $color = "primary";
          break;
        case "btn-yellow":
          $color = "yellow-9";
          break;
        case "btn-black":
          $color = "mygrey";
          break;
      }
      return $color;
    },
    changeTextColor(data) {
      let $color = "white";
      switch (data) {
        case "btn-green":
          $color = "white";
          break;
        case "btn-yellow":
          $color = "white";
          break;
        case "btn-black":
          $color = "dark";
          break;
      }
      return $color;
    },
    whenShow() {
      if (this.data.is_view == 1) {
        return false;
      }
      APIinterface.fetchDataByToken("setOrderViewed", {
        order_uuid: this.data.order_uuid,
      })
        .then((data) => {
          //
        })
        .catch((error) => {
          //
        })
        .then((data) => {
          //
        });
    },
    hasMoreButtons(tabs, status) {
      if (tabs[status]) {
        if (tabs[status].group_name == "order_ready") {
          if (this.order_group_buttons[tabs[status].group_name]) {
            const $data =
              this.order_group_buttons[tabs[status].group_name][
                this.data.order_type
              ];
            if ($data.length <= 2) {
              return false;
            }
          }
          return true;
        }
      }
      return false;
    },
    doActions(data) {
      console.log(data);
      this.button_uuid = data.uuid;
      if (data.do_actions == "reject_form") {
        this.$refs.rejection.dialog = true;
      } else {
        //this.getOrderSummaryChanges(data);
        this.updateOrderStatus("", "updateOrderStatus");
      }
    },
    afterAddreason(data) {
      this.dialog = false;
      this.updateOrderStatus(data, "updateOrderStatus");
    },
    updateOrderStatus(reason, actions) {
      APIinterface.showLoadingBox("", this.$q);

      APIinterface.fetchDataByToken(actions, {
        order_uuid: this.data.order_uuid,
        reason: reason,
        uuid: this.button_uuid,
      })
        .then((data) => {
          this.dialog = false;
          this.$emit("afterUpdatestatus");
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    getOrderSummaryChanges(data) {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByToken("getOrderSummaryChanges", {
        order_uuid: this.data.order_uuid,
        group_name: data.group_name,
      })
        .then((result) => {
          this.method = result.details.summary_changes.method;
          this.commission = result.details.commission;
          console.log(this.method);
          if (this.method == "less_on_account") {
            this.$q
              .dialog({
                title: this.$t("Accept Order"),
                message: this.commission,
                cancel: {
                  label: "Cancel",
                  "no-caps": true,
                  flat: true,
                },
                persistent: true,
                transitionShow: "none",
                transitionHide: "none",
                ok: {
                  label: this.$t("Less on my account"),
                  "no-caps": true,
                  unelevated: true,
                  class: "radius8",
                },
              })
              .onOk(() => {
                this.updateOrderStatus("", "lessCashOnAccount");
              });
          } else {
            console.log("here");
            this.updateOrderStatus("", "updateOrderStatus");
          }
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    async showPrinter() {
      this.dialog = false;
      if (this.$q.capacitor) {
        if (this.$q.platform.is.ios) {
          this.EnabledBT();
        } else {
          if (this.osVersion >= 12) {
            try {
              await AppBluetooth.CheckBTConnectPermission();
              await AppBluetooth.CheckBTScanPermission();
              this.$refs.printer.dialog = true;
            } catch (error) {
              const errorMessage = error.message || error;
              APIinterface.notify("dark", errorMessage, "error", this.$q);
            }
            return;
          }

          try {
            await AppBluetooth.CheckLocationOnly();
            this.$refs.printer.dialog = true;
          } catch (error) {
            this.$router.push("/settings/location-enabled");
          }
        }
      } else {
        this.$refs.printer.dialog = true;
      }
    },
    EnabledBT() {
      AppBluetooth.Enabled()
        .then((data) => {
          this.$refs.printer.dialog = true;
        })
        .catch((error) => {
          APIinterface.notify("dark", error.message, "error", this.$q);
        })
        .then((data) => {
          //
        });
    },
    afterSelectprinter(data) {
      this.printer_details = data;
      if (data.printer_model == "feieyun") {
        this.FPprint(data);
      } else {
        if (this.$q.capacitor) {
          this.getOrder();
        } else {
          APIinterface.notify(
            "dark",
            this.$t("Bluetooth Printers works only in actual device"),
            "error",
            this.$q
          );
        }
      }
    },
    async getOrder() {
      APIinterface.showLoadingBox(this.$t("Getting order..."), this.$q);
      try {
        let result = await this.OrderStore.orderDetails(this.data.order_uuid);
        this.$refs.printer.dialog = false;
        APIinterface.hideLoadingBox(this.$q);
        this.CheckBT();
      } catch (err) {
        APIinterface.notify("dark", err, "error", this.$q);
        APIinterface.hideLoadingBox(this.$q);
      }
    },
    CheckBT() {
      AppBluetooth.Enabled()
        .then((data) => {
          if (this.DataPersisted.printer_set == 2) {
            this.$refs.print_preview.showDialog(true, false);
          } else {
            this.BondAndConnect();
          }
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          //
        });
    },
    BondAndConnect() {
      this.$refs.printer.dialog = false;

      APIinterface.showLoadingBox(this.$t("Connecting..."), this.$q);

      AppBluetooth.Connect(
        this.printer_details.printer_uuid,
        this.printer_details.printer_model
      )
        .then((result) => {
          this.Print();
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    Print() {
      let tpl = PrintTemplate.ReceiptTemplate(
        this.printer_details.paper_width,
        this.OrderStore.order_info,
        this.OrderStore.merchant,
        this.OrderStore.order_items,
        this.OrderStore.order_summary
      );
      console.log("TEMPLATE ==>");
      console.log(tpl.tpl_all);
      console.log(tpl.tpl_data);

      if (Object.keys(tpl).length > 0) {
        if (this.printer_details.printer_model == "sunmi") {
          this.printData(tpl.tpl_all);
        } else {
          Object.entries(tpl.tpl_data).forEach(([key, items]) => {
            if (!APIinterface.empty(items)) {
              if (key > 0) {
                setTimeout(() => {
                  console.log(items);
                  this.printData(items);
                }, 2000); // 1 sec delay
              } else {
                console.log(items);
                this.printData(items);
              }
            }
          });
        }
      }
    },
    printData(tpl) {
      APIinterface.showLoadingBox(this.$t("Printing..."), this.$q);
      AppBluetooth.Print(
        this.printer_details.printer_uuid,
        tpl,
        this.printer_details.printer_model,
        this.printer_details.service_id,
        this.printer_details.characteristics
      )
        .then((data) => {
          //
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    FPprint(data) {
      this.$refs.printer.dialog = false;
      APIinterface.showLoadingBox(this.$t("Printing..."), this.$q);
      APIinterface.fetchDataByTokenPost(
        "FPprint",
        "printer_id=" + data.printer_id + "&order_uuid=" + this.data.order_uuid
      )
        .then((data) => {
          APIinterface.notify(
            this.$q.dark.mode ? "grey600" : "light-green",
            data.msg,
            "check",
            this.$q
          );
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    //
  },
};
</script>
