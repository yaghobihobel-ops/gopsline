import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useDataPersisted } from "stores/DataPersisted";
import { useAccessStore } from "src/stores/AccessStore";
import { NativeAudio } from "@capacitor-community/native-audio";
import { Notify } from "quasar";
import { i18n } from "boot/i18n";

export const useOrderStore = defineStore("OrderStore", {
  state: () => ({
    order_uuid: "",
    payload: [
      "merchant_info",
      "items",
      "summary",
      "order_info",
      "progress",
      "refund_transaction",
      "status_allowed_cancelled",
      "pdf_link",
      "delivery_timeline",
      "order_delivery_status",
      "allowed_to_review",
      "credit_card",
    ],
    order_info: [],
    merchant: [],
    order_items: [],
    order_summary: [],
    order_count: [],
    site_data: [],

    interval: null,
    is_ringing: false,
    new_order_count: 0,

    lastOrders: {
      tab: null,
      data: [],
    },

    orderListFeed: {
      tab: null,
      data: [],
      current_page: 0,
      hasMore: false,
    },

    ordertypeColor: {
      delivery: {
        bg: "cyan-1",
        text: "cyan-9",
      },
      pickup: {
        bg: "light-green-1",
        text: "light-green-9",
      },
      dinein: {
        bg: "yellow-1",
        text: "yellow-8",
      },
      takeout: {
        bg: "lime-1",
        text: "lime-9",
      },
    },

    paymentStatusColor: {
      paid: {
        bg: "purple-1",
        text: "purple-8",
      },
      unpaid: {
        bg: "blue-grey-1",
        text: "blue-grey-8",
      },
    },

    itemStatus: {
      draft: {
        bg: "red-2",
        text: "red-10",
      },
      pending: {
        bg: "blue-1",
        text: "blue-9",
      },
      publish: {
        bg: "teal-1",
        text: "teal-10",
      },
    },

    statusColor: {
      new: {
        bg: "blue-1",
        text: "blue-9",
      },
      rejected: {
        bg: "red-1",
        text: "red-10",
      },
      ready_for_pickup: {
        bg: "amber-2",
        text: "amber-10",
      },
      delivery_on_its_way: {
        bg: "indigo-1",
        text: "indigo-9",
      },
      delivered: {
        bg: "green-1",
        text: "green-9",
      },
      cancelled: {
        bg: "grey-3",
        text: "grey-9",
      },
      delayed: {
        bg: "orange-1",
        text: "orange-10",
      },
      delivery_failed: {
        bg: "red-2",
        text: "red-10",
      },
      accepted: {
        bg: "teal-1",
        text: "teal-10",
      },
      complete: {
        bg: "yellow-2",
        text: "yellow-10",
      },
    },

    statusBookingColor: {
      pending: {
        bg: "blue-1",
        text: "blue-9",
      },
      no_show: {
        bg: "red-1",
        text: "red-10",
      },
      waitlist: {
        bg: "amber-2",
        text: "amber-10",
      },
      confirmed: {
        bg: "green-1",
        text: "green-9",
      },
      cancelled: {
        bg: "red-2",
        text: "red-9",
      },
      delayed: {
        bg: "orange-1",
        text: "orange-10",
      },
      denied: {
        bg: "red-2",
        text: "red-10",
      },
      finished: {
        bg: "teal-1",
        text: "teal-10",
      },
      complete: {
        bg: "yellow-2",
        text: "yellow-10",
      },
    },

    suggestedStatus: {
      pending: {
        bg: "blue-1",
        text: "blue-9",
      },
      approved: {
        bg: "teal-1",
        text: "teal-10",
      },
    },

    pollTimer: null,
    pollNewOrder: false,

    tableTimer: null,
    tableID: false,
    tableInterval: null,
    tableIsRinging: false,
    TableCount: 0,

    //
  }),

  getters: {
    CountOrder(state) {
      if (Object.keys(state.order_count).length > 0) {
        return state.order_count;
      }
      return false;
    },
  },

  actions: {
    clearCache() {
      this.$reset();
    },

    clearSavedOrderList() {
      this.lastOrders = null;
      this.orderListFeed = null;
    },

    updateOrderCount(count) {
      this.new_order_count = count;
      if (count > 0) {
        this.startRinging();
      } else {
        this.stopRinging();
      }
    },

    startRinging() {
      if (this.interval || this.new_order_count === 0) return;

      let interval = this.getAlertInterval();
      console.log("interval", interval);
      if (!interval) {
        console.log("here end");
        return;
      }

      this.is_ringing = true;
      this.playSound();
      this.interval = setInterval(() => {
        console.log("Play audio");
        this.playSound();
      }, interval);
    },

    playSound(message) {
      NativeAudio.play({ assetId: "notify" });
      Notify.create({
        type: "warning",
        message: message
          ? i18n.global.t(message)
          : i18n.global.t("New order received!"),
        timeout: 2000,
        position: "top-right",
        icon: "notifications_active",
        classes: "mynotification",
      });
    },

    playAlert(message) {
      if (!message) {
        return;
      }
      NativeAudio.play({ assetId: "notify" });
      Notify.create({
        type: "warning",
        message: message,
        timeout: 2000,
        position: "top-right",
        icon: "notifications_active",
        classes: "mynotification",
      });
    },

    stopRinging() {
      if (this.interval) {
        clearInterval(this.interval);
        this.interval = null;
      }
      this.is_ringing = false;
    },

    async orderDetails(orderUUID) {
      const DataPersisted = useDataPersisted();

      let promise = new Promise((resolve, reject) => {
        APIinterface.fetchDataByToken("orderDetails", {
          order_uuid: orderUUID,
          hide_currency: DataPersisted.hide_currency ? 1 : 0,
          payload: this.payload,
        })
          .then((data) => {
            this.order_info = data.details.data.order.order_info;
            this.merchant = data.details.data.merchant;
            this.order_items = data.details.data.items;
            this.order_summary = data.details.data.summary;
            this.site_data = data.details.data.site_data;
            resolve(data.details?.data);
          })
          .catch((error) => {
            reject(error);
          });
      });
      return await promise;
    },
    foundCountOrder(data) {
      if (!APIinterface.empty(this.order_count[data])) {
        return this.order_count[data];
      }
      return false;
    },
    getCountOrder() {
      APIinterface.fetchDataByToken("getCountOrder")
        .then((data) => {
          this.order_count = data.details;
        })
        .catch((error) => {
          this.order_count = [];
        });
    },

    async getCountNewOrder() {
      try {
        const response = await APIinterface.fetchGet("getCountNewOrder");
        this.order_count = response.details.tabs_total_order;
        this.updateOrderCount(this.order_count?.new_order);
      } catch (error) {
        this.order_count = [];
        this.updateOrderCount(0);
      }
    },

    startPollingFallback() {
      console.log("startPollingFallback");
      if (this.pollTimer) return;
      this.pollTimer = setInterval(async () => {
        try {
          const response = await APIinterface.fetchGet("fetchPolling");
          const results_order = response.details.results_order;
          const results_reservation = response.details.results_reservation;
          console.log("results_order", results_order);
          console.log("results_reservation", results_reservation);

          const new_orders = results_order?.new_orders ?? 0;
          const orderId = results_order?.order_id ?? null;

          this.updateOrderCount(new_orders);
          this.pollNewOrder = orderId;

          const reservation_uuid =
            results_reservation?.reservation_uuid ?? null;
          const new_booking = results_reservation?.new_booking ?? 0;

          this.updateTableCount(new_booking);
          this.tableID = reservation_uuid;
        } catch (error) {
          this.order_count = [];
          this.pollNewOrder = false;
          this.updateOrderCount(0);

          this.tableID = false;
          this.updateTableCount(0);
        }
      }, 15000);
    },

    stopPollingFallback() {
      if (this.pollTimer) {
        clearInterval(this.pollTimer);
        this.pollTimer = null;
      }
    },

    changeColor(data) {
      let $color = "mygrey";
      switch (data) {
        case "btn-green":
          $color = "secondary";
          break;
        case "btn-yellow":
          $color = "yellow-9";
          break;
        case "btn-black":
          $color = "disabled";
          break;
      }
      return $color;
    },
    changeTextColor(data) {
      let $color = "white";
      switch (data) {
        case "btn-green":
          $color = "white";
          break;
        case "btn-yellow":
          $color = "white";
          break;
        case "btn-black":
          $color = "disabled";
          break;
      }
      return $color;
    },

    getAlertInterval() {
      const DataStore = useDataStore();
      const AccessStore = useAccessStore();

      const admin_alert =
        DataStore?.settings_data?.enable_new_order_alert ?? false;

      let admin_interval = parseInt(
        DataStore?.settings_data?.new_order_alert_interval
      );

      let merchant_alert =
        AccessStore?.app_settings?.enable_new_order_alert ?? null;

      let merchant_interval =
        AccessStore?.app_settings?.new_order_alert_interval ?? null;

      let alertEnabled = false;
      if (merchant_alert === "not_define") {
        alertEnabled = admin_alert;
      } else {
        alertEnabled = merchant_alert ?? admin_alert;
      }

      if (!alertEnabled) {
        return null; // means alert disabled
      }

      let interval = merchant_interval > 0 ? merchant_interval : admin_interval;

      if (isNaN(interval) || interval <= 0) {
        interval = 20; // fallback
      }

      return interval * 1000;
    },

    stopAllFallback() {
      this.stopPollingFallback();
      this.stopRinging();
      this.stopTableRinging();
    },

    async fetchReservationcount() {
      try {
        const response = await APIinterface.fetchGet("fetchreservationcount");
        console.log("fetchReservationcount", response);
        const new_booking = response.details.new_booking;
        this.updateTableCount(new_booking);
      } catch (error) {
        this.updateTableCount(0);
      }
    },

    updateTableCount(count) {
      console.log("updateTableCount", count);
      this.TableCount = count;
      if (count > 0) {
        this.startTableRinging();
      } else {
        this.stopTableRinging();
      }
    },

    startTableRinging() {
      if (this.tableInterval || this.TableCount === 0) return;

      console.log("startTableRinging");

      const DataStore = useDataStore();
      DataStore.cleanData("booking_data");

      let interval = this.getAlertInterval();
      console.log("interval", interval);
      if (!interval) {
        console.log("here end");
        return;
      }

      this.is_ringing = true;
      this.playSound("New Resevation received!");
      this.tableInterval = setInterval(() => {
        this.playSound("New Resevation received!");
      }, interval);
    },

    stopTableRinging() {
      if (this.tableInterval) {
        clearInterval(this.tableInterval);
        this.tableInterval = null;
      }
    },

    //
  },
});
