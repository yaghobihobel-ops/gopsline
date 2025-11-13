import { defineStore } from "pinia";

export const useSettingStore = defineStore("settings", {
  state: () => ({
    dark_theme: false,
    screen_options: "tiled",
    transition_times: [],
    mute_sounds: false,
    push_notifications: true,
    repeat_notication: false,
    color_ontime: "#8ad975",
    color_caution: "#ffb74d",
    color_late: "#ff5252",
    color_status: {},
    scheduled_order_transition_time: "",
    split_order_type: {},
    app_language: "",
    rtl: false,
    app_version: null,
    device_token: null,
    tab: "display",
  }),

  persist: true,

  getters: {
    doubleCount(state) {
      return state.counter * 2;
    },
  },

  actions: {
    increment() {
      this.counter++;
    },
  },
});
