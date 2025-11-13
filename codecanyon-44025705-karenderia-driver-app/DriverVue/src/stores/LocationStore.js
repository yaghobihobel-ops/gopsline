import { defineStore } from "pinia";

export const useLocationStore = defineStore("location", {
  state: () => ({
    coordinates: [],
    has_watcher: false,
    watchers: [],
  }),

  getters: {
    hasData() {
      if (Object.keys(this.coordinates).length > 0) {
        return true;
      }
      return false;
    },
  },

  actions: {
    hadData() {
      if (Object.keys(this.coordinates).length > 0) {
        return true;
      }
      return false;
    },
  },
});
