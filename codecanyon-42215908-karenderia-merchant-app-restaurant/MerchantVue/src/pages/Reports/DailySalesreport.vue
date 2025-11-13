<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md bg-grey-1">
      <TableSummary
        ref="table_summary"
        :loading="loading_summary"
        :data="data_summary"
        :set_slide="2.5"
      ></TableSummary>

      <q-infinite-scroll ref="nscroll" @load="List">
        <template v-slot:default>
          <q-list
            separator
            class="bg-whitex"
            :class="{
              'bg-grey600 text-white': $q.dark.mode,
              'bg-white': !$q.dark.mode,
            }"
          >
            <template v-for="items in data" :key="items">
              <template v-for="item in items" :key="item">
                <q-item
                  clickable
                  :to="{
                    path: '/orderview',
                    query: { order_uuid: item.order_uuid },
                  }"
                >
                  <q-item-section avatar top>
                    <div class="flex flex-center text-center">
                      <div>
                        <div
                          class="radius8 bg-green-10 text-white q-pa-xs text-center q-pl-sm q-pr-sm"
                        >
                          <div class="font14 text-weight-bold">
                            #{{ item.order_id }}
                          </div>
                        </div>
                      </div>
                    </div>
                  </q-item-section>
                  <q-item-section top>
                    <q-item-label caption class="font12">
                      {{ item.date_created }}
                    </q-item-label>
                    <q-item-label>
                      {{ item.service_name }} - {{ item.payment_name }}
                    </q-item-label>
                    <q-item-label caption>
                      {{ $t("Total Sales") }} : {{ item.sub_total }}
                    </q-item-label>
                    <q-item-label caption>
                      {{ $t("Delivery Fee") }} : {{ item.delivery_fee }}
                    </q-item-label>
                    <q-item-label caption>
                      {{ $t("Tax") }} : {{ item.tax_total }}
                    </q-item-label>
                    <q-item-label caption>
                      {{ $t("Tip") }} : {{ item.courier_tip }}
                    </q-item-label>
                    <q-item-label caption>
                      {{ $t("Total") }} : {{ item.total }}
                    </q-item-label>
                  </q-item-section>
                </q-item>
              </template>
            </template>
          </q-list>
        </template>
        <template v-slot:loading>
          <TableSkeleton v-if="page <= 0" :rows="10"></TableSkeleton>
          <TableSkeleton v-else-if="data.length > 1" :rows="1"></TableSkeleton>
        </template>
      </q-infinite-scroll>

      <template v-if="!hasData && !loading">
        <div
          class="full-width text-center flex flex-center"
          style="min-height: calc(50vh)"
        >
          <p class="text-grey q-ma-none">{{ $t("No available data") }}</p>
        </div>
      </template>

      <q-space class="q-pa-md"></q-space>
      <q-page-sticky position="bottom-right" :offset="[18, 18]">
        <div class="column q-gutter-y-sm">
          <div>
            <q-btn
              icon="o_date_range"
              round
              size="md"
              color="amber-6"
              text-color="disabled"
              unelevated
              @click="this.$refs.filter_date.dialog = true"
            ></q-btn>
          </div>
          <div>
            <q-btn
              icon="las la-print"
              round
              size="md"
              color="blue-grey-1"
              text-color="blue-grey-8"
              unelevated
              @click="showPrinter"
              :disable="!hasData"
            ></q-btn>
          </div>
        </div>
      </q-page-sticky>
    </q-page>
  </q-pull-to-refresh>
  <FilterDates ref="filter_date" @after-filter="afterFilter"></FilterDates>

  <PrinterList
    ref="printer"
    @after-selectprinter="afterSelectprinter"
  ></PrinterList>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import PrintTemplate from "src/api/PrintTemplate";
import AppBluetooth from "src/api/AppBluetooth";

export default {
  name: "InvoiceList",
  components: {
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
    TableSummary: defineAsyncComponent(() =>
      import("components/TableSummary.vue")
    ),
    FilterDates: defineAsyncComponent(() =>
      import("components/FilterDates.vue")
    ),
    PrinterList: defineAsyncComponent(() =>
      import("components/PrinterList.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Daily Sales Report");
    this.Summary();

    setTimeout(() => {
      this.$refs.nscroll?.trigger();
    }, 200);
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  data() {
    return {
      loading: false,
      data: [],
      page: 0,
      status: [],
      is_refresh: undefined,
      handle: undefined,
      date_start: "",
      date_end: "",
      printer_details: [],
      restaurant_name: "",
      loading_summary: false,
    };
  },
  methods: {
    refresh(done) {
      this.resetPagination();
      this.Summary();
      this.is_refresh = done;
    },
    afterFilter(data) {
      this.date_start = data.date_start;
      this.date_end = data.date_end;
      this.resetPagination();
    },
    List(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "dailyReportSales",
        "&page=" +
          index +
          "&date_start=" +
          this.date_start +
          "&date_end=" +
          this.date_end
      )
        .then((data) => {
          if (data.code == 1) {
            this.page = index;
            this.data.push(data.details.data);
          } else if (data.code == 3) {
            this.data_done = true;
            if (!APIinterface.empty(this.$refs.nscroll)) {
              this.$refs.nscroll.stop();
            }
          }
        })
        .catch((error) => {
          this.data_done = true;
          if (!APIinterface.empty(this.$refs.nscroll)) {
            this.$refs.nscroll.stop();
          }
        })
        .then((data) => {
          done();
          this.loading = false;
          if (!APIinterface.empty(this.is_refresh)) {
            this.is_refresh();
          }
        });
    },
    resetPagination() {
      this.page = 0;
      this.data = [];
      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
    },
    Summary() {
      this.loading_summary = true;
      APIinterface.fetchDataByTokenPost("getDailySummary")
        .then((data) => {
          this.data_summary = data.details.data;
        })
        .catch((error) => {
          //
        })
        .then((data) => {
          this.loading_summary = false;
        });
    },
    showPrinter() {
      if (this.$q.capacitor) {
        if (this.DataStore.osVersion >= 12) {
          AppBluetooth.CheckBTConnectPermissionOnly()
            .then((data) => {
              this.EnabledBT();
            })
            .catch((error) => {
              this.$router.push("/settings/location-enabled");
            })
            .then((data) => {
              //
            });
        } else {
          AppBluetooth.CheckLocationOnly()
            .then((data) => {
              this.$refs.printer.dialog = true;
            })
            .catch((error) => {
              this.$router.push("/settings/location-enabled");
            })
            .then((data) => {
              //
            });
        }
      } else {
        this.$refs.printer.dialog = true;
      }
    },
    afterSelectprinter(data) {
      this.printer_details = data;
      //console.log(data);

      if (data.printer_model == "feieyun") {
        this.FPprint(data);
      } else {
        if (this.$q.capacitor) {
          this.CheckBT();
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
    FPprint(data) {
      this.$refs.printer.dialog = false;
      APIinterface.showLoadingBox(this.$t("Printing..."), this.$q);
      APIinterface.fetchDataByTokenPost(
        "FPprintdailysales",
        "printer_id=" +
          data.printer_id +
          "&date_start=" +
          this.date_start +
          "&date_end=" +
          this.date_end
      )
        .then((data) => {
          APIinterface.notify("green", data.msg, "check", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    CheckBT() {
      AppBluetooth.Enabled()
        .then((data) => {
          this.BondAndConnect();
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
      this.$refs.printer.dialog = false;
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost(
        "GetDailysales",
        "date_start=" + this.date_start + "&date_end=" + this.date_end
      )
        .then((data) => {
          let tpl = PrintTemplate.DailySales(
            this.printer_details.paper_width,
            data.details.restaurant_name,
            data.details.range,
            data.details.data
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

          //
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.$q.loading.hide();
        });
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
  },
};
</script>
