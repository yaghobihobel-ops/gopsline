import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";

export const ReviewOverviewStore = defineStore("reviewOverview", {
  state: () => ({
    summary_loading: false,
    data_summary: [],
  }),

  getters: {
    hasDataSummary() {
      if (Object.keys(this.data_summary).length > 0) {
        return true;
      }
      return false;
    },
  },

  actions: {
    getReviewSummary() {
      this.summary_loading = true;
      APIinterface.fetchDataByTokenPost("getReviewSummary")
        .then((data) => {
          this.data_summary = data.details;
        })
        .catch((error) => {
          this.data_summary = [];
        })
        .then((data) => {
          this.summary_loading = false;
        });
    },
    setPercent(data) {
      if (data > 0) {
        return data / 100;
      }
      return 0;
    },
    clearData() {
      this.data_summary = [];
    },
  },
});
