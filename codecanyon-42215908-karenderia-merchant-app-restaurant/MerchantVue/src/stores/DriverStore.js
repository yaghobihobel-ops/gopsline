import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";

export const useDriverStore = defineStore("DriverStore", {
  state: () => ({
    loading: false,
    data: null,
    active_task: [],
    has_data: false,
    zone_list: [],
    group_list: [],
    is_refresh: false,
    vehicle_attributes: [],
    driver_list: [],
    schedule_data: [],
    promo_attributes_data: [],
    loading_balance: false,
    balance_data: [],
    payment_list: [],
  }),

  getters: {
    getDrivers(state) {
      return state.data;
    },
    hasDrivers(state) {
      return state.has_data;
    },
    hasDriverData(state) {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    getActiveTask(state) {
      return state.active_task;
    },
    getLoading(state) {
      return state.loading;
    },
    getZone(state) {
      return state.zone_list;
    },
    getGroup(state) {
      return state.group_list;
    },
    getVehicleAttributes(state) {
      return state.vehicle_attributes;
    },
    getDriverList(state) {
      return state.driver_list;
    },
    getScheduleAttributes(state) {
      return state.schedule_data;
    },
    getPromoAttributes(state) {
      return state.promo_attributes_data;
    },
    getMerchantBalance(state) {
      return state.balance_data;
    },
    getPaymentProviderByMerchant(state) {
      return state.payment_list;
    },
  },

  actions: {
    getAvailableDriver(filter, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getAvailableDriver", filter)
        .then((data) => {
          this.has_data = true;
          this.data = data.details.data;
          this.active_task = data.details.active_task;
        })
        .catch((error) => {
          //this.has_data = false;
          this.data = [];
          this.active_task = [];
        })
        .then((data) => {
          this.loading = false;
          this.is_refresh = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    getZoneList() {
      APIinterface.fetchDataByTokenPost("getZoneList")
        .then((data) => {
          this.zone_list = data.details;
        })
        .catch((error) => {
          //
        })
        .then((data) => {});
    },
    getGroupList() {
      APIinterface.fetchDataByTokenPost("getGroupList")
        .then((data) => {
          this.group_list = data.details;
        })
        .catch((error) => {
          //
        })
        .then((data) => {});
    },
    VehicleAttributes() {
      APIinterface.fetchDataByTokenPost("VehicleAttributes")
        .then((data) => {
          this.vehicle_attributes = data.details;
        })
        .catch((error) => {
          this.vehicle_attributes = [];
        })
        .then((data) => {});
    },
    DriverList() {
      APIinterface.fetchDataByTokenPost("SelectDriverList")
        .then((data) => {
          this.driver_list = data.details;
        })
        .catch((error) => {
          this.driver_list = [];
        })
        .then((data) => {});
    },
    ScheduleAttributes(employment_type) {
      APIinterface.fetchDataByTokenPost(
        "ScheduleAttributes",
        "employment_type=" + employment_type
      )
        .then((data) => {
          this.schedule_data = data.details;
        })
        .catch((error) => {
          this.schedule_data = [];
        })
        .then((data) => {});
    },
    PromoAttributes() {
      APIinterface.fetchDataByTokenPost("PromoAttributes")
        .then((data) => {
          this.promo_attributes_data = data.details;
        })
        .catch((error) => {
          this.promo_attributes_data = [];
        })
        .then((data) => {});
    },
    MerchantBalance() {
      this.loading_balance = true;
      APIinterface.fetchDataByTokenPost("getMerchantBalance")
        .then((data) => {
          this.balance_data = data.details;
        })
        .catch((error) => {
          //
        })
        .then((data) => {
          this.loading_balance = false;
        });
    },
    PaymentProviderByMerchant() {
      APIinterface.fetchDataByTokenPost("PaymentProviderByMerchant")
        .then((data) => {
          this.payment_list = data.details;
        })
        .catch((error) => {
          //
        })
        .then((data) => {});
    },
  },
});
