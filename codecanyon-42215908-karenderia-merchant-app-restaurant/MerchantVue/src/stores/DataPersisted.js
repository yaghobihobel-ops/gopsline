import { defineStore } from "pinia";

export const useDataPersisted = defineStore("datapersisted", {
  state: () => ({
    enabled_push: false,
    rtl: false,
    app_language: "en",
    keep_awake: false,
    dark_mode: false,
    choose_language: false,
    printer_set: "image",
    printer_auto_close: true,
    hide_currency: false,
    enabled_auto_print: false,
    auto_printer_id: null,
  }),

  persist: true,
  getters: {
    //
  },

  actions: {
    clearCache() {
      this.$reset();
    },

    enabledPush() {
      this.enabled_push = true;
    },
  },
});
