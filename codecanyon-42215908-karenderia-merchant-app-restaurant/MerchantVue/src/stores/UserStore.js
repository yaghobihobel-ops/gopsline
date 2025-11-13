import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";

export const useUserStore = defineStore("userStore", {
  state: () => ({
    push_notifications: false,
    //app_language: "",
    dark_mode: false,
    loading: false,
    data: [],
    device_uuid: "",
    data_push_receive: [],
    notifications_data: null,
    pusher_receive_data: null,
    show_subscribe_push: null,
    show_subscribe_push_count: 0,
    device_token: null,
  }),
  persist: false,
  getters: {
    getChatCount(state) {
      return !state.notifications_data
        ? 0
        : state.notifications_data.chat_count;
    },
    getAlertCount(state) {
      return !state.notifications_data
        ? 0
        : state.notifications_data.alert_count;
    },
  },
  actions: {
    clearCache() {
      this.$reset();
    },

    getAutoPrinter() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "getAutoPrinter",
        "device_uuid=" + this.device_uuid
      )
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
    hasPrinter() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    getNotifications() {
      APIinterface.fetchDataByTokenPost("getNotifications")
        .then((data) => {
          this.notifications_data = data.details;
        })
        .catch((error) => {
          this.notifications_data = null;
        })
        .then((data) => {});
    },
    setViewedNotifications(isChat) {
      APIinterface.fetchDataByTokenPost(
        "setViewedNotifications",
        "isChat=" + isChat
      )
        .then((data) => {
          this.notifications_data = null;
        })
        .catch((error) => {})
        .then((data) => {});
    },
    setViewNotification(notification_uuid) {
      APIinterface.fetchDataByTokenPost(
        "setViewNotification",
        "notification_uuid=" + notification_uuid
      )
        .then((data) => {
          let chat_count = this.notifications_data.chat_count
            ? this.notifications_data.chat_count
            : null;
          if (chat_count && chat_count > 0) {
            chat_count = chat_count - 1;
            this.notifications_data.chat_count = chat_count;
          }
        })
        .catch((error) => {})
        .then((data) => {});
    },
  },
});
