import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";
import jwtDecode from "jwt-decode";
import { Settings, DateTime } from "luxon";

export const useActivityStore = defineStore("activity", {
  state: () => ({
    title: "",
    settings_loading: false,
    maps_config: "",
    phone_settings: "",
    lang_data: "",
    app_language: "en",
    rtl: false,
    server_time: "",
    settings_data: [],
    calendar_data: [],
    zone_data: [],
    zone_loading: false,
    timezone: "",
    break_duration: [],
    realtime_data: [],
    money_config: [],
    cashin_denomination: [],
    legal_menu: [],
    vehicle_maker: [],
    vehicle_type: [],
    dark_mode: false,
    choose_language: false,
    push_off: false,
    push_notifications: false,
    keep_awake: false,
    is_online: null,
  }),

  getters: {
    doubleCount(state) {
      return state.counter * 2;
    },
    getZoneData(state) {
      return state.zone_data;
    },
  },

  persist: false,

  actions: {
    setTitle(data) {
      this.title = data;
    },
    getSettings() {
      this.settings_loading = true;
      APIinterface.fetchData("getSettings", "")
        .then((data) => {
          this.maps_config = jwtDecode(data.details.maps_config);
          this.phone_settings = jwtDecode(data.details.phone_settings);
          this.lang_data = jwtDecode(data.details.lang_data);
          this.server_time = data.details.server_time;
          this.settings_data = data.details.data;
          this.calendar_data = data.details.calendar_data;
          this.timezone = data.details.timezone;
          this.break_duration = data.details.break_duration;
          this.realtime_data = jwtDecode(data.details.realtime_data);
          this.money_config = data.details.money_config;
          this.cashin_denomination = data.details.cashin_denomination;
          this.legal_menu = data.details.legal_menu;
          this.vehicle_maker = data.details.vehicle_maker;
          this.vehicle_type = data.details.vehicle_type;

          Settings.defaultZone = data.details.timezone;
          APIinterface.setStorage("timezone", data.details.timezone);
        })
        .catch((error) => {
          this.legal_menu = [];
        })
        .then((data) => {
          this.settings_loading = false;
        });
    },
    getZone() {
      this.zone_loading = true;
      APIinterface.fetchDataByTokenPost("getZone", "")
        .then((data) => {
          this.zone_data = data.details.data;
        })
        .catch((error) => {
          this.zone_data = [];
        })
        .then((data) => {
          this.zone_loading = false;
        });
    },
    getZoneList() {
      this.zone_loading = true;
      APIinterface.fetchDataByTokenPost("getZoneList", "")
        .then((data) => {
          this.zone_data = data.details.data;
        })
        .catch((error) => {
          this.zone_data = [];
        })
        .then((data) => {
          this.zone_loading = false;
        });
    },
    getOnlineStatus(done) {
      APIinterface.fetchDataByTokenPost("getOnlineStatus", "")
        .then((data) => {
          this.is_online = data.details.is_online;
        })
        .catch((error) => {
          this.is_online = false;
        })
        .then((data) => {
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
  },
});
