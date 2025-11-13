import { defineStore } from "pinia";

export const ShiftHistoryStore = defineStore("shifthistory", {
  state: () => ({
    loading: false,
    data: [],
    chat_data: null,
  }),

  getters: {
    doubleCount(state) {
      return state.counter * 2;
    },
  },

  actions: {
    shiftHistory() {},
  },
});
