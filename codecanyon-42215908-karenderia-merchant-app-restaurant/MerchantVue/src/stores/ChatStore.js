import { defineStore } from "pinia";

export const useChatStore = defineStore("chat", {
  state: () => ({
    counter: 0,
    data: null,
    last_message_data: {},
  }),

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
