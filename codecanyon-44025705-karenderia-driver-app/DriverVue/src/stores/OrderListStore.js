import { defineStore } from "pinia";

export const OrderListStore = defineStore("orderlist", {
  state: () => ({
    list: [],
    data: [],
    active_order: undefined,
    steps: 0,
    merchants: [],
    order_meta: [],
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
    hadData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
});
