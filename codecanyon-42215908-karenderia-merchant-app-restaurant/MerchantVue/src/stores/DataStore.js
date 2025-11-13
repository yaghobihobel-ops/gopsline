import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";
import jwt_decode from "jwt-decode";

export const useDataStore = defineStore("DataStore", {
  state: () => ({
    device_language: null,
    app_language: "en",
    rtl: false,
    selected_lang_data: [],
    language_data: [],
    loading: false,
    money_config: [],
    realtime_data: null,
    legal_menu: [],
    loading_page: false,
    page_data: [],
    status_list: [],
    dish_list: [],
    language_list: [],
    menu_tab: "menu",
    data_dialog: {
      title: "Delete Confirmation",
      subtitle:
        "Are you sure you want to permanently delete the selected item?",
      cancel: "Cancel",
      confirm: "Delete",
    },
    multi_option: [],
    two_flavor_properties: [],
    promo_type: [],
    item_list: [],
    total_item: 0,
    loading_earning: false,
    earning_summary: [],
    total_order_loading: false,
    total_order_summary: [],
    last_order: [],
    last_order_tab: "all",
    rejection_list: [],
    order_tab: "new_order",
    delayed_min_list: [],
    loading_dashboard: false,
    merchant_dashboard_data: [],
    tab_merchant_dashboard: "transaction_history",
    loading_payout_settings: false,
    payout_settings_data: [],
    payout_provider: [],
    payout_country: [],
    payout_account_type: [],
    payout_currency: [],
    cuisine: [],
    services: [],
    tags: [],
    unit: [],
    featured: [],
    two_flavor_options: [],
    tips: [],
    tip_type: [],
    day_list: [],
    customer_tab: "order_history",
    search_item: "",
    loading_available: false,
    store_available: false,
    registration_settings: [],
    phone_prefix_data: [],
    phone_default_data: [],
    printer_list: [],
    dark_mode: false,
    push_notifications: false,
    local_notification: false,
    keep_awake: false,
    app_version: 0,
    app_version_android: 0,
    app_version_ios: 0,
    osVersion: 0,
    enabled_language: false,
    choose_language: false,
    time_range: [],
    day_week: [],
    booking_status_list: [],
    time_interval: [],
    time_interval_list: [],
    status_list_raw: [],
    status_color: {
      draft: "amber",
      publish: "green",
      pending: "deep-orange",
    },
    status_payment_color: {
      unpaid: "amber",
      paid: "green",
      pending: "deep-orange",
    },
    status_driver_color: {
      active: "green",
      blocked: "red",
      deleted: "red",
      expired: "red-2",
      pending: "amber",
      suspended: "red",
    },
    bank_status_color: {
      pending: "amber",
      approved: "green",
    },
    table_room_list: [],
    table_room_list_raw: [],
    table_list: [],
    booking_status_list_value: [],
    cart_uuid: "",
    cart_transaction_type: "delivery",
    maps_config: [],
    place_data: [],
    salary_type: [],
    employment_type: [],
    commission_type: [],
    customer_status: [],
    //customer_data: [],
    vehicle_attributes: [],
    self_delivery: false,
    push_off: false,
    hide_currency: false,
    bank_status_list: [],
    printer_set: "1",
    printer_auto_close: true,
    printer_paper_width_56: 585,
    printer_paper_width_80: 685,
    settings_data: null,
    storeSettings: null,

    printerList: null,
    printerListMore: false,
    printerListPage: 1,

    dataList: {},
    hasConnections: null,
    page_title: null,
    page_subtitle: null,
    page_delete: false,
    page_delete_actions: false,
    page_chat_data: null,
    fcmSubscribed: false,
  }),

  getters: {
    hasPage() {
      if (Object.keys(this.page_data).length > 0) {
        return true;
      }
      return false;
    },
    hasEarningSummary() {
      if (Object.keys(this.earning_summary).length > 0) {
        return true;
      }
      return false;
    },
    getTimeRange(state) {
      return state.time_range;
    },
    getDayList(state) {
      return state.day_list;
    },
    getDayWeek(state) {
      return state.day_week;
    },
    getBookingStatus(state) {
      return state.booking_status_list;
    },
    getMapsConfig(state) {
      if (!state.loading) {
        return state.maps_config;
      }
      return false;
    },
    hasPlaceData(state) {
      if (Object.keys(state.place_data).length > 0) {
        return true;
      }
      return false;
    },
    getRegistrationSettings(state) {
      return state.registration_settings;
    },
    getPusher(state) {
      return !state.realtime_data ? false : state.realtime_data;
    },
  },

  actions: {
    clearCache() {
      this.$reset();
    },
    cleanData(value) {
      if (this.dataList[value]) {
        this.dataList[value] = null;
      }
    },
    clearPrinterList() {
      this.printerList = null;
      this.printerListMore = false;
      this.printerListPage = 1;
    },
    getAttributes(done) {
      this.loading = true;
      APIinterface.fetchDataPost("getAttributes", "")
        .then((data) => {
          this.language_data = jwt_decode(data.details.language_data);
          this.money_config = data.details.money_config;
          this.realtime_data = jwt_decode(data.details.realtime);
          this.legal_menu = data.details.legal_menu;
          this.language_list = data.details.language_list;
          this.last_order = data.details.last_order;
          this.rejection_list = data.details.rejection_list;

          this.dish_list = data.details.dish_list;
          this.status_list = data.details.status_list;
          this.status_list_raw = data.details.status_list_raw;
          this.booking_status_list = data.details.booking_status_list;
          this.booking_status_list_value =
            data.details.booking_status_list_value;
          this.promo_type = [];
          this.delayed_min_list = [];

          this.bank_status_list = data.details.bank_status_list;

          this.multi_option = data.details.multi_option;
          this.two_flavor_properties = data.details.two_flavor_properties;
          this.promo_type = data.details.promo_type;

          //this.delayed_min_list = data.details.delayed_min_list;
          this.cuisine = data.details.cuisine;
          this.services = data.details.services;
          this.tags = data.details.tags;
          this.unit = data.details.unit;
          this.featured = data.details.featured;

          this.two_flavor_options = data.details.two_flavor_options;
          this.tips = data.details.tips;
          this.tip_type = data.details.tip_type;
          this.day_list = data.details.day_list;
          this.day_week = data.details.day_week;
          this.registration_settings = data.details.registration_settings;

          this.phone_default_data = data.details.phone_default_data;

          this.printer_list = data.details.printer_list;

          this.app_version_android = data.details.app_version_android;
          this.app_version_ios = data.details.app_version_ios;
          this.android_download_url = data.details.android_download_url;
          this.ios_download_url = data.details.ios_download_url;

          this.enabled_language = data.details.enabled_language;
          this.time_range = data.details.time_range;
          this.time_interval = data.details.time_interval;
          this.time_interval_list = data.details.time_interval_list;
          this.salary_type = data.details.salary_type;
          this.employment_type = data.details.employment_type;
          this.commission_type = data.details.commission_type;
          this.customer_status = data.details.customer_status;

          this.maps_config = jwt_decode(data.details.maps_config);

          this.phone_prefix_data = [];
          if (Object.keys(data.details.phone_prefix_data).length > 0) {
            Object.entries(data.details.phone_prefix_data).forEach(
              ([key, items]) => {
                this.phone_prefix_data.push({
                  label: "+" + items.phonecode + " " + items.country_name,
                  value: "+" + items.phonecode,
                  flag: items.flag,
                });
              }
            );
          }

          Object.entries(data.details.delayed_min_list).forEach(
            ([key, items]) => {
              this.delayed_min_list.push({
                label: items.value,
                value: items.id,
              });
            }
          );

          //
        })
        .catch((error) => {
          this.language_data = [];
          this.money_config = [];
          this.realtime_data = null;
          this.legal_menu = [];
          this.status_list = [];
          this.dish_list = [];
          this.language_list = [];
          this.multi_option = [];
          this.two_flavor_properties = [];
          this.last_order = [];
          this.rejection_list = [];
          this.delayed_min_list = [];
          this.two_flavor_options = [];
          this.tips = [];
          this.tip_type = [];
          this.day_list = [];
          this.registration_settings = [];
          this.phone_prefix_data = [];
          this.phone_default_data = [];
          this.booking_status_list_value = [];
        })
        .then((data) => {
          this.loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getPage(done, pageId) {
      if (APIinterface.empty(done)) {
        this.loading_page = true;
      }
      APIinterface.fetchDataPost("getPage", "page_id=" + pageId)
        .then((data) => {
          this.page_data = data.details;
        })
        .catch((error) => {
          this.page_data = [];
        })
        .then((data) => {
          this.loading_page = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getItemList(pageId, ref) {
      this.loading_item = true;
      APIinterface.fetchDataByTokenPost("getItemList", "page=" + pageId)
        .then((data) => {
          this.total_item = data.details.count;
          Object.entries(data.details.data_value).forEach(([key, items]) => {
            this.item_list.push(items);
          });
        })
        .catch((error) => {
          this.item_list = [];
          this.total_item = 0;
        })
        .then((data) => {
          this.loading_item = false;
        });
    },
    getEarningSummary(done) {
      this.loading_earning = true;
      APIinterface.fetchDataByTokenPost("getEarningSummary", "")
        .then((data) => {
          this.earning_summary = data.details;
        })
        .catch((error) => {
          this.earning_summary = [];
        })
        .then((data) => {
          this.loading_earning = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getTotalOrders(done) {
      this.total_order_loading = true;
      APIinterface.fetchDataByTokenPost("getTotalOrders", "")
        .then((data) => {
          this.total_order_summary = data.details;
        })
        .catch((error) => {
          this.total_order_summary = [];
        })
        .then((data) => {
          this.total_order_loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getMerchantDashboard(done) {
      this.loading_dashboard = true;
      APIinterface.fetchDataByTokenPost("getMerchantDashboard", "")
        .then((data) => {
          this.merchant_dashboard_data = data.details;
        })
        .catch((error) => {
          this.merchant_dashboard_data = [];
        })
        .then((data) => {
          this.loading_dashboard = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getPayoutSettings(done) {
      this.loading_payout_settings = true;
      APIinterface.fetchDataByTokenPost("getPayoutSettings", "")
        .then((data) => {
          this.payout_settings_data = data.details;

          this.payout_provider = [];
          Object.entries(data.details.provider).forEach(([key, items]) => {
            this.payout_provider.push({
              label: items.payment_name,
              value: items.payment_code,
            });
          });

          this.payout_country = [];
          Object.entries(data.details.country_list).forEach(([key, items]) => {
            this.payout_country.push({
              label: items,
              value: key,
            });
          });

          this.payout_account_type = [];
          Object.entries(data.details.account_type).forEach(([key, items]) => {
            this.payout_account_type.push({
              label: items,
              value: key,
            });
          });

          this.payout_currency = [];
          Object.entries(data.details.currency_list).forEach(([key, items]) => {
            this.payout_currency.push({
              label: items,
              value: key,
            });
          });

          //
        })
        .catch((error) => {
          this.payout_settings_data = [];
          this.payout_provider = [];
          this.payout_country = [];
          this.account_type = [];
          this.payout_account_type = [];
          this.payout_currency = [];
        })
        .then((data) => {
          this.loading_payout_settings = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    storeAvailable() {
      this.loading_available = true;
      APIinterface.fetchDataByTokenPost("storeSettings")
        .then((data) => {
          this.store_available = data.details.store_available;
          this.self_delivery = data.details.self_delivery;
          this.storeSettings = data.details;
        })
        .catch((error) => {
          this.store_available = false;
          this.self_delivery = false;
        })
        .then((data) => {
          this.loading_available = false;
        });
    },
    setStoreAvailable(available) {
      this.loading_available = true;
      let $available = available == true ? 0 : 1;
      APIinterface.fetchDataByTokenPost(
        "setStoreAvailable",
        "available=" + $available
      )
        .then((data) => {
          this.store_available = data.details.store_available;
        })
        .catch((error) => {
          this.store_available = false;
        })
        .then((data) => {
          this.loading_available = false;
        });
    },
    TableRoomList() {
      APIinterface.fetchDataByTokenPost("searchTableroom")
        .then((data) => {
          this.table_room_list = data.details.data;
          this.table_room_list_raw = data.details.data2;
        })
        .catch((error) => {
          this.table_room_list = [];
          this.table_room_list_raw = [];
        })
        .then((data) => {});
    },
    getTableList() {
      APIinterface.fetchDataByTokenPost("getTableList")
        .then((data) => {
          this.table_list = data.details.data;
        })
        .catch((error) => {
          this.table_list = [];
        })
        .then((data) => {});
    },
  },
});
