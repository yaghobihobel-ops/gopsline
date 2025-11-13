import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";

export const DeliveryOverviewStore = defineStore("deliveryOverview", {
  state: () => ({
    data: [],
    loading: false,
  }),

  getters: {
    doubleCount(state) {
      return state.counter * 2;
    },
  },

  actions: {
    deliveriesOverview() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("deliveriesOverview")
        .then((data) => {
          this.data = data.details;
        })
        .catch((error) => {
          this.data = [];
        })
        .then((data) => {
          this.loading = false;
        });
    },
    clearData() {
      this.data = [];
    },
  },
});
