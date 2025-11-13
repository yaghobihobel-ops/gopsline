import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";

export const useSettingStore = defineStore("settings_store", {
  state: () => ({
    loading: false,
    loading2: false,
    store_status: "",
    pause_times: null,
    pause_reasons: null,
    pause_data: null,
  }),

  getters: {
    getPauseTime(state) {
      return state.pause_times ? state.pause_times : null;
    },
    getPauseReason(state) {
      return state.pause_reasons ? state.pause_reasons : null;
    },
    getPauseData(state) {
      return state.pause_data ? state.pause_data : null;
    },
    hasPauseData(state) {
      return state.pause_data ? true : false;
    },
  },

  actions: {
    getOrderingStatus() {
      if (!this.pause_data) {
        this.loading = true;
        APIinterface.fetchDataByTokenPost("getOrderingStatus")
          .then((data) => {
            this.store_status = data.details.store_status;
            this.pause_data = data.details;
          })
          .catch((error) => {
            this.pause_data = null;
          })
          .then((data) => {
            this.loading = false;
          });
      }
    },
    getPauseOptions() {
      if (!this.pause_times) {
        this.loading = true;
        APIinterface.fetchDataByTokenPost("getPauseOptions")
          .then((data) => {
            this.pause_times = data.details.times;
            this.pause_reasons = data.details.pause_reason;
          })
          .catch((error) => {
            this.pause_times = null;
            this.pause_reasons = null;
          })
          .then((data) => {
            this.loading = false;
          });
      }
    },
  },
});
