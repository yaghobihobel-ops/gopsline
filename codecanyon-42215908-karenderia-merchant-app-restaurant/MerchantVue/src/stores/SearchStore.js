import { defineStore } from "pinia";

export const useSearchStore = defineStore("search", {
  state: () => ({
    counter: 0,
    data: [],
    status: [],
    is_submit: false,
  }),

  persist: false,

  getters: {
    hasData(state) {
      if (Object.keys(state.data).length > 0) {
        return true;
      }
      return false;
    },
  },

  actions: {
    clearData() {
      this.data = [];
      this.status = [];
      this.is_submit = false;
    },
  },
});
