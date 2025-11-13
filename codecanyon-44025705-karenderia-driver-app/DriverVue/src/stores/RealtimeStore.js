import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";

export const useRealtimeStore = defineStore("realtime", {
  state: () => ({
    data: [],
  }),

  getters: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },

  actions: {
    getRealtime() {
      APIinterface.getRealtime(this.getevent)
        .then((data) => {
          this.data = data.details;
        })
        // eslint-disable-next-line
        .catch((error) => {
          this.data = [];
        })
        .then((data) => {
          //
        });
    },
    hadData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    //
  },
});
