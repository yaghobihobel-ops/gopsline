import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";
import { i18n } from "src/boot/i18n";

export const useGlobalStore = defineStore("globalstore", {
  state: () => ({
    top_customer_loading: false,
    top_customer: null,
    sales_loading: false,
    chat_data: null,
    chartOptions: {
      chart: {
        id: "vuechart-example",
      },
      xaxis: {
        categories: [],
      },
    },
    series: [
      {
        name: "series-1",
        data: [],
      },
    ],
    review_loading: false,
    review_data: null,
    sales_summary_loading: false,
    sales_summary: null,
    printer_loading: true,
    printer_data: null,
    merchantMenu: [
      {
        name: "information",
        label: "Information",
        to: "/merchant",
      },
      {
        name: "login",
        label: "Login",
        to: "/merchant/login",
      },
      {
        name: "address",
        label: "Address",
        to: "/merchant/address",
      },
      {
        name: "settings",
        label: "Settings",
        to: "/merchant/settings",
      },
      {
        name: "timezone",
        label: "Time Zone",
        to: "/merchant/timezone",
      },
      {
        name: "opening",
        label: "Opening Hours",
        to: "/merchant/store-hours",
      },
      {
        name: "timezone",
        label: "Time Zone",
        to: "/merchant/zone",
      },
    ],
    TableMenu: [
      {
        name: "list",
        label: "List",
        to: "/table",
      },
      {
        name: "settings",
        label: "Settings",
        to: "/table/settings",
      },
      {
        name: "shifts",
        label: "Shifts",
        to: "/table/shifts",
      },
      {
        name: "rooms",
        label: "Rooms",
        to: "/table/rooms",
      },
      {
        name: "tables",
        label: "Tables",
        to: "/table/tables",
      },
    ],
    PosMenu: [
      {
        name: "create",
        label: "Create Order",
        to: "/pos",
      },
      {
        name: "on-hold",
        label: "Hold Orders",
        to: "/pos/on-hold",
      },
      {
        name: "on-hold",
        label: "Pos Orders",
        to: "/pos/list",
      },
    ],
    //
  }),

  getters: {
    getTopcustomer(state) {
      return !state.top_customer ? false : state.top_customer;
    },
    getSales(state) {
      return !state.chat_data ? false : state.chat_data;
    },
    getReviewData(state) {
      return !state.review_data ? false : state.review_data;
    },
    getEarning(state) {
      return !state.sales_summary ? false : state.sales_summary;
    },
    getEarningSale(state) {
      return !state.sales_summary ? false : state.sales_summary.sales;
    },
    getPrinters(state) {
      return !state.printer_data ? false : state.printer_data;
    },
    getReview(state) {
      return !state.review_data
        ? false
        : !state.review_data.ratings
        ? 0
        : state.review_data.ratings.ratings;
    },
  },

  actions: {
    getTopCustomer(done) {
      this.top_customer_loading = true;
      APIinterface.fetchDataByTokenPost("getTopCustomer", "limit=5")
        .then((data) => {
          this.top_customer = data.details;
        })
        .catch((error) => {
          this.top_customer = null;
        })
        .then((data) => {
          this.top_customer_loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    SalesOverview(done) {
      this.sales_loading = true;
      APIinterface.fetchDataByTokenPost("salesOverview", "months=6")
        .then((data) => {
          this.chat_data = data.details.data;
          const categories = data.details.category;

          this.chartOptions = {
            chart: {
              id: "vuechart-example",
            },
            dataLabels: {
              enabled: false,
            },
            xaxis: {
              categories: categories,
            },
          };

          this.series = [
            {
              name: i18n.global.t("Sale"),
              data: data.details.data,
            },
          ];
        })
        .catch((error) => {})
        .then((data) => {
          this.sales_loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getReviewSummary(done) {
      this.review_loading = true;
      APIinterface.fetchDataByTokenPost("OverviewReview", "limit=5")
        .then((data) => {
          this.review_data = data.details;
        })
        .catch((error) => {
          this.review_data = null;
        })
        .then((data) => {
          this.review_loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getEarningSummary(done) {
      this.sales_summary_loading = true;
      APIinterface.fetchDataByTokenPost("getEarningSummary", "")
        .then((data) => {
          this.sales_summary = data.details;
        })
        .catch((error) => {
          this.sales_summary = null;
        })
        .then((data) => {
          this.sales_summary_loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    clearEarningSummary() {
      this.sales_summary = null;
    },
    printerList(device_uuid) {
      this.printer_loading = true;
      APIinterface.fetchDataByTokenPost(
        "PrintersList",
        "page=" + 0 + "&device_uuid=" + device_uuid
      )
        .then((data) => {
          this.printer_data = data.details.data;
        })
        .catch((error) => {
          this.printer_data = null;
        })
        .then((data) => {
          this.printer_loading = false;
        });
    },
    //
  },
});
