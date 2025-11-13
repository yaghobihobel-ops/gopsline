import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";

export const useDriverappStore = defineStore("driverappstore", {
  state: () => ({
    counter: 0,
    wallet_balance: null,
    total_task: null,
  }),

  getters: {
    doubleCount(state) {
      return state.counter * 2;
    },
    hasBalance(state) {
      if (state.wallet_balance) {
        return true;
      }
      return false;
    },
    getBalance(state) {
      if (state.total_task) {
        return state.total_task;
      }
      return false;
    },
  },

  actions: {
    getRemainingCashBalance() {
      console.log("getRemainingCashBalance");
      APIinterface.fetchDataByTokenPost("getRemainingCashBalance")
        .then((data) => {
          this.wallet_balance = data.details;
        })
        .catch((error) => {
          this.wallet_balance = null;
        })
        .then((data) => {});
    },
    getTotalTask() {
      const date = APIinterface.getDateNow();
      APIinterface.fetchDataByTokenPost("getTotalTask", "date=" + date)
        .then((data) => {
          if (data.details.total_task > 0) {
            this.total_task = data.details.total_task;
          } else {
            this.total_task = null;
          }
        })
        .catch((error) => {
          this.total_task = null;
        })
        .then((data) => {});
    },
    //
  },
});
