import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";
import { api } from "src/boot/axios";
const API_METHOD = "apikitchen";
import { useIdentityStore } from "stores/IdentityStore";

export const useKitchenStore = defineStore("kitchen", {
  state: () => ({
    drawer: 0,
    miniState: true,
    settings_data: null,
    order_loading: false,
    order_data: null,
    order_data2: null,
    order_count: null,
    timeList: [],
    realtime_data: null,
    notification_loading: false,
    notification_type: "",
    screen_list: [
      {
        label: "Tiled",
        value: "tiled",
      },
      {
        label: "Classic",
        value: "classic",
      },
      {
        label: "Split",
        value: "split",
      },
    ],
    color_status: {
      delivery: "#388e3c",
      pickup: "#b2ebf2",
      dinein: "#ce93d8",
      takeout: "#90caf9",
    },
    order_data_top: null,
    order_data_bottom: null,
    request_code_loading: false,
    printer_loading: false,
    printer_data: null,
    print_header: [
      {
        position: "left",
        type: "font",
        font_type: "bold",
      },
      {
        position: "center",
        type: "text",
        value: "Test Receipt",
      },
      {
        position: "left",
        type: "font",
        font_type: "normal",
      },
      {
        position: "left",
        type: "line_break",
        value: "",
      },
    ],
    print_body: [
      {
        position: "left",
        type: "dotted_line",
        value: "-",
      },
      {
        position: "left_right_text",
        type: "text",
        label: "Cheese burger",
        value: "20.00$",
      },
      {
        position: "left",
        type: "text",
        value: "2 x 10$",
      },
      {
        position: "left",
        type: "dotted_line",
        value: "-",
      },
      {
        position: "left",
        type: "font",
        font_type: "bold",
      },
      {
        position: "left_right_text",
        type: "text",
        label: "Total",
        value: "20.00$",
      },
      {
        position: "left",
        type: "font",
        font_type: "normal",
      },
      {
        position: "left",
        type: "dotted_line",
        value: "-",
      },
    ],
    print_footer: [
      {
        position: "left",
        type: "line_break",
        value: "",
      },
      {
        position: "center",
        type: "text",
        value: "Thank you for your order",
      },
      {
        position: "center",
        type: "text",
        value: "Please visit us again.",
      },
      {
        position: "left",
        type: "line_break_big",
        value: "",
      },
    ],
  }),

  getters: {
    getKitchenStatus(state) {
      return state.settings_data ? state.settings_data.kitchen_status : null;
    },
    hasOrderData(state) {
      return state.order_data ? true : false;
    },
    getOrderData(state) {
      return state.order_data ? state.order_data.data : null;
    },
    getOrderTotal(state) {
      return state.order_data ? state.order_data.count : 0;
    },
    displayOrderTotal(state) {
      return state.order_data ? state.order_data.count_display : "";
    },
    getOrderTotalTop(state) {
      return state.order_data_top ? state.order_data_top.count : 0;
    },
    displayOrderTotalTop(state) {
      return state.order_data_top ? state.order_data_top.count_display : "";
    },
    getOrderDataTop(state) {
      return state.order_data_top ? state.order_data_top.data : null;
    },
    getOrderDataBottom(state) {
      return state.order_data_bottom ? state.order_data_bottom.data : null;
    },
    hasScheduledData(state) {
      return state.order_data2 ? true : false;
    },
    getScheduledData(state) {
      return state.order_data2 ? state.order_data2.data : null;
    },
    getScheduledTotal(state) {
      return state.order_data2 ? state.order_data2.count : 0;
    },
    displayScheduledTotal(state) {
      return state.order_data2 ? state.order_data2.count_display : "";
    },
    getOrderStatusList(state) {
      return state.settings_data
        ? state.settings_data.order_status_list_value
        : null;
    },
    getKitchenStatusList(state) {
      return state.settings_data
        ? state.settings_data.kitchen_status_list
        : null;
    },
    getTransactionList(state) {
      let data = [];
      if (state.settings_data) {
        if (Object.keys(state.settings_data.services).length > 0) {
          Object.entries(state.settings_data.services).forEach(
            ([key, items]) => {
              data.push({
                value: key,
                label: items.service_name,
              });
            }
          );
        }
      }
      return data;
    },
    getTransactionList2(state) {
      let data = {};
      if (state.settings_data) {
        if (Object.keys(state.settings_data.services).length > 0) {
          Object.entries(state.settings_data.services).forEach(
            ([key, items]) => {
              data[key] = items.service_name;
            }
          );
        }
      }
      return data;
    },
    getTransitionTimes(state) {
      let data = [];
      if (state.settings_data) {
        if (Object.keys(state.settings_data.services).length > 0) {
          Object.entries(state.settings_data.services).forEach(
            ([key, items]) => {
              let deliveryTimes = {
                [key]: {
                  label: items.service_name,
                  caution: 10,
                  last: 10,
                },
              };
              data.push(deliveryTimes);
            }
          );
        }
      }
      return data;
    },
    getCurrentCount(state) {
      return state.order_count ? state.order_count.current : 0;
    },
    getScheduleCount(state) {
      return state.order_count ? state.order_count.scheduled : 0;
    },
    getCurrentCountDisplay(state) {
      return state.order_count ? state.order_count.current_display : 0;
    },
    getCurrentCountScheduled(state) {
      return state.order_count ? state.order_count.scheduled_display : 0;
    },
    getNotificationList(state) {
      return state.realtime_data ? state.realtime_data.data : null;
    },
    getNotificationCount(state) {
      return state.realtime_data
        ? Object.keys(state.realtime_data.data).length
        : null;
    },
    isLanguageEnabled(state) {
      return state.settings_data ? state.settings_data.enabled_language : false;
    },
    defaultLanguage(state) {
      return state.settings_data ? state.settings_data.default_lang : [];
    },
    languageList(state) {
      return state.settings_data
        ? state.settings_data.language_list
          ? state.settings_data.language_list.list
          : []
        : [];
    },
    legalMenu(state) {
      return state.settings_data
        ? state.settings_data.legal_menu
          ? state.settings_data.legal_menu
          : []
        : [];
    },
    getPrinterList(state) {
      return state.settings_data ? state.settings_data.printer_list : null;
    },
    getPrinters(state) {
      return state.printer_data ? state.printer_data : null;
    },
  },

  actions: {
    hasOrder() {
      return this.order_data ? true : false;
    },
    hasOrderDataTop() {
      return this.order_data_top ? true : false;
    },
    hasOrderDataBottom() {
      return this.order_data_bottom ? true : false;
    },
    async getSettings() {
      if (!this.settings_data) {
        try {
          this.settings_loading = true;
          const response = await api.get("/" + API_METHOD + "/getSettings");
          if (response.data.code == 1) {
            this.settings_data = response.data.details;
          } else {
            this.settings_data = [];
          }
        } catch (error) {
          console.error("Error fetching data:", error);
        } finally {
          this.settings_loading = false;
        }
      }
    },
    async refreshSettings() {
      try {
        this.settings_loading = true;
        const response = await api.get("/" + API_METHOD + "/getSettings");
        if (response.data.code == 1) {
          this.settings_data = response.data.details;
        } else {
          this.settings_data = [];
        }
      } catch (error) {
        console.error("Error fetching data:", error);
      } finally {
        this.settings_loading = false;
      }
    },
    getOrders(params) {
      if (!this.order_data) {
        this.order_loading = true;
        APIinterface.fetchDataPost("getOrders", {
          filters: params,
        })
          .then((data) => {
            //console.log("data", data);
            this.order_data = data.details;
          })
          .catch((error) => {
            this.order_data = null;
          })
          .then((data) => {
            this.order_loading = false;
          });
      }
    },
    getOrdersTop(params) {
      this.order_loading = true;
      APIinterface.fetchDataPost("getOrders", {
        filters: params,
      })
        .then((data) => {
          this.order_data_top = data.details;
        })
        .catch((error) => {
          this.order_data_top = null;
        })
        .then((data) => {
          this.order_loading = false;
        });
    },
    getOrdersBottom(params) {
      this.order_loading = true;
      APIinterface.fetchDataPost("getOrders", {
        filters: params,
      })
        .then((data) => {
          this.order_data_bottom = data.details;
        })
        .catch((error) => {
          this.order_data_bottom = null;
        })
        .then((data) => {
          this.order_loading = false;
        });
    },
    refreshOrders(done, params) {
      this.order_loading = true;
      APIinterface.fetchDataPost("getOrders", {
        filters: params,
      })
        .then((data) => {
          //console.log("data", data);
          this.order_data = data.details;
        })
        .catch((error) => {
          this.order_data = null;
        })
        .then((data) => {
          if (done) {
            done();
          }
          this.order_loading = false;
        });
    },

    getScheduled(params) {
      if (!this.order_data2) {
        this.order_loading = true;
        APIinterface.fetchDataPost("getOrders", {
          filters: params,
        })
          .then((data) => {
            //console.log("data", data);
            this.order_data2 = data.details;
          })
          .catch((error) => {
            this.order_data2 = null;
          })
          .then((data) => {
            this.order_loading = false;
          });
      }
    },
    refreshScheduled(done, params) {
      this.order_loading = true;
      APIinterface.fetchDataPost("getOrders", {
        filters: params,
      })
        .then((data) => {
          //console.log("data", data);
          this.order_data2 = data.details;
        })
        .catch((error) => {
          this.order_data2 = null;
        })
        .then((data) => {
          if (done) {
            done();
          }
          this.order_loading = false;
        });
    },

    refreshOrdersCount() {
      this.order_count = null;
      this.getOrdersCount();
    },
    getOrdersCount() {
      if (!this.order_count) {
        APIinterface.fetchDataPost("getOrdersCount")
          .then((data) => {
            this.order_count = data.details;
          })
          .catch((error) => {
            this.order_count = null;
          })
          .then((data) => {});
      }
    },

    getNotifications() {
      if (!this.realtime_data) {
        APIinterface.fetchDataPost("getNotifications")
          .then((data) => {
            this.realtime_data = data.details;
          })
          .catch((error) => {
            this.realtime_data = null;
          })
          .then((data) => {});
      }
    },

    clearNotification() {
      this.notification_loading = true;
      APIinterface.fetchDataPost("clearNotification")
        .then((data) => {
          this.realtime_data = null;
        })
        .catch((error) => {})
        .then((data) => {
          this.notification_loading = false;
        });
    },

    setRepeatNotification(params) {
      APIinterface.fetchDataPost("setRepeatNotification", params)
        .then((data) => {})
        .catch((error) => {})
        .then((data) => {});
    },

    saveScheduledTransitionTime(params) {
      APIinterface.fetchDataPost("saveScheduledTransitionTime", params)
        .then((data) => {})
        .catch((error) => {})
        .then((data) => {});
    },

    async requestCode() {
      try {
        const IdentityStore = useIdentityStore();
        const response = await api.get("/" + API_METHOD + "/requestCode", {
          headers: {
            Authorization: `token ${IdentityStore.auth_token}`,
          },
        });
        return response.data;
      } catch (error) {
        console.error("Error fetching data:", error);
      } finally {
      }
    },

    async deleteAccount(code) {
      try {
        const IdentityStore = useIdentityStore();
        const response = await api.get(
          "/" + API_METHOD + "/deleteAccount?code=" + code,
          {
            headers: {
              Authorization: `token ${IdentityStore.auth_token}`,
            },
          }
        );
        return response.data;
      } catch (error) {
        console.error("Error fetching data:", error);
      } finally {
      }
    },

    isDone(status) {
      switch (status) {
        case "completed":
        case "cancelled":
          return true;
          break;

        default:
          return false;
          break;
      }
    },
    isCancel(status) {
      if (status == "cancelled") {
        return true;
      }
      return false;
    },
    getItemStatus(status) {
      let $colors = "";
      switch (status) {
        case "in progress":
          $colors = "orange-5";
          break;

        case "ready":
          $colors = "light-green-3";
          break;

        case "delayed":
          $colors = "red-7";
          break;

        case "cancelled":
          $colors = "red";
          break;

        case "completed":
          $colors = "green";
          break;

        default:
          $colors = "primary";
          break;
      }
      return $colors;
    },
    isAllCompleted(items) {
      console.log("isAllCompleted", items);
    },

    generateMinutes() {
      if (Object.keys(this.timeList).length <= 0) {
        const totalMinutes = 120;
        for (let minutes = 1; minutes <= totalMinutes; minutes++) {
          const hours = Math.floor(minutes / 60);
          const remainderMinutes = minutes % 60;
          const formattedTime = this.formatTime(hours, remainderMinutes, 0);
          this.timeList.push(formattedTime);
        }
      }
    },

    formatTime(hours, minutes, seconds) {
      const formattedHours = hours.toString().padStart(2, "0");
      const formattedMinutes = minutes.toString().padStart(2, "0");
      const formattedSeconds = seconds.toString().padStart(2, "0");
      return `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
    },

    PrinterList() {
      if (!this.printer_data) {
        this.printer_loading = true;
        APIinterface.fetchDataPost("PrinterList")
          .then((data) => {
            console.log("data", data);
            this.printer_data = data.details.data;
          })
          .catch((error) => {
            this.printer_data = null;
          })
          .then((data) => {
            this.printer_loading = false;
          });
      }
    },

    async getTicket(order_reference, printer_id) {
      return await new Promise(async function (resolve, reject) {
        APIinterface.fetchDataGet(
          "getTicket",
          "order_reference=" + order_reference + "&printer_id=" + printer_id
        )
          .then((data) => {
            console.log("data", data);
            resolve(data);
          })
          .catch((error) => {
            resolve(error);
          })
          .then((data) => {});
      });
    },
  },
});
