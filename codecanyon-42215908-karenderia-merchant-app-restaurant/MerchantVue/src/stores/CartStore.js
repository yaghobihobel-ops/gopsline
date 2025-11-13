import { defineStore } from "pinia";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export const useCartStore = defineStore("cartstore", {
  state: () => ({
    cart_drawer: false,
    cart_loading: true,
    items_count: 0,
    cart_items: [],
    cart_summary: [],
    cart_total: [],
    error: [],
    cart_subtotal: [],
    cart_uuid: "",
    refresh_done: undefined,
    trans_loading: true,
    trans_data: [],
    deliverytimes_loading: false,
    deliverytimes_data: [],
    delivery_date_list: [],
    delivery_time_list: [],
    delivery_date: "",
    delivery_time: "",
    whento_deliver: "",
    checkout_address_loading: false,
    checkout_address: [],
    order_loading: false,
    order_data: [],
    loading_storeopen: false,
    data_storeopen: [],
    storeopen_error: "",
    similar_loading: false,
    similar_data: [],
    menu_loading: false,
    data_category: [],
    data_items: [],
    items_not_available: [],
    category_not_available: [],
    cartcount_loading: false,
    cartcount_data: [],
    payload: [
      "items",
      "merchant_info",
      "service_fee",
      "delivery_fee",
      "packaging",
      "tax",
      "tips",
      "checkout",
      "discount",
      "distance_local",
      "summary",
      "total",
      "subtotal",
      "items_count",
      "points",
      "points_discount",
    ],
    pos_loading: false,
    pos_attributes: [],
    customer_id: undefined,
    customer_data: [],
    order_reference: "",
  }),

  getters: {
    hasData(state) {
      if (Object.keys(state.cart_items).length > 0) {
        return true;
      }
      return false;
    },
    getItems(state) {
      return state.cart_items;
    },
    getCartCount(state) {
      return state.items_count;
    },
    getCartTotal(state) {
      return state.cart_total;
    },
    getCartSubTotal(state) {
      if (state.cart_subtotal) {
        return state.cart_subtotal;
      }
    },
    getCartSubTotalValue(state) {
      if (state.cart_subtotal) {
        return state.cart_subtotal.value;
      }
    },
    getSummary(state) {
      return state.cart_summary;
    },
    hasError(state) {
      if (!state.cart_loading) {
        if (Object.keys(state.error).length > 0) {
          return true;
        }
      }
      return false;
    },
    getCartError(state) {
      return state.error;
    },
    getTransactionList(state) {
      let data = [];
      if (!APIinterface.empty(state.pos_attributes)) {
        if (!APIinterface.empty(state.pos_attributes.transaction_list)) {
          if (Object.keys(state.pos_attributes.transaction_list).length > 0) {
            Object.entries(state.pos_attributes.transaction_list).forEach(
              ([key, items]) => {
                data.push({
                  label: items.service_name,
                  value: items.service_code,
                });
              }
            );
          }
        }
      }
      return data;
    },
    getAddresslabel(state) {
      let data = [];
      if (!state.pos_loading) {
        if (Object.keys(state.pos_attributes).length > 0) {
          Object.entries(state.pos_attributes.address_label).forEach(
            ([key, items]) => {
              data.push({
                label: items,
                value: key,
              });
            }
          );
          return data;
        }
      }
      return false;
    },
    getDeliveryOption(state) {
      let data = [];
      if (!state.pos_loading) {
        if (Object.keys(state.pos_attributes).length > 0) {
          Object.entries(state.pos_attributes.delivery_option).forEach(
            ([key, items]) => {
              data.push({
                label: items,
                value: key,
              });
            }
          );
          return data;
        }
      }
      return false;
    },
    getPreferedTime(state) {
      let data = [];
      if (!state.pos_loading) {
        if (Object.keys(state.pos_attributes).length > 0) {
          Object.entries(state.pos_attributes.preferred_time).forEach(
            ([key, items]) => {
              data.push({
                label: items.short_name,
                value: items.value,
              });
            }
          );
          return data;
        }
      }
      return false;
    },
    getOpeningDates(state) {
      let data = [];
      if (!state.pos_loading) {
        if (Object.keys(state.pos_attributes).length > 0) {
          Object.entries(state.pos_attributes.opening_hours.dates).forEach(
            ([key, items]) => {
              data.push({
                label: items.name,
                value: items.value,
              });
            }
          );
          return data;
        }
      }
      return false;
    },
    getOrderStatus(state) {
      if (!state.pos_loading) {
        if (Object.keys(state.pos_attributes).length > 0) {
          return state.pos_attributes.order_status_list;
        }
      }
      return false;
    },
    getPaymentMethod(state) {
      if (!state.pos_loading) {
        if (Object.keys(state.pos_attributes).length > 0) {
          return state.pos_attributes.data;
        }
      }
      return false;
    },
    getRoomList(state) {
      if (!state.pos_loading) {
        if (Object.keys(state.pos_attributes).length > 0) {
          return state.pos_attributes.room_list;
        }
      }
      return false;
    },
    getTableList(state) {
      if (!state.pos_loading) {
        if (Object.keys(state.pos_attributes).length > 0) {
          return state.pos_attributes.table_list;
        }
      }
      return false;
    },
    getOrderReference(state) {
      return state.order_reference;
    },
  },

  actions: {
    getCart(cart_uuid, local_id, payload) {
      this.cart_loading = true;
      let params = {
        cart_uuid: cart_uuid,
        local_id: local_id,
        payload: !APIinterface.empty(payload) ? payload : this.payload,
      };
      APIinterface.fetchDataByTokenPost("getCart", params)
        .then((data) => {
          this.items_count = data.details.items_count;
          this.cart_uuid = data.details.cart_uuid;
          this.cart_items = data.details.data.items;
          this.cart_summary = data.details.data.summary;
          this.cart_total = data.details.data.total;
          this.error = data.details.error;
          this.cart_subtotal = data.details.data.subtotal;
          this.customer_data = data.details.customer_data;
          this.order_reference = data.details.order_reference;
        })
        .catch((error) => {
          this.items_count = 0;
          this.cart_uuid = "";
          this.cart_items = [];
          this.cart_summary = [];
          this.cart_total = [];
          this.error = [];
          this.cart_subtotal = [];
          this.customer_data = [];
          this.order_reference = "";
        })
        .then((data) => {
          this.cart_loading = false;
        });
    },
    posAttributes() {
      this.pos_loading = true;
      APIinterface.fetchDataByTokenPost("posAttributes")
        .then((data) => {
          this.pos_attributes = data.details;
        })
        .catch((error) => {
          this.pos_attributes = [];
        })
        .then((data) => {
          this.pos_loading = false;
        });
    },
    afterSelectcustomer(cart_uuid, client_id) {
      const DataStore = useDataStore();
      APIinterface.fetchDataByTokenPost(
        "cartSetCustomer",
        "client_id=" + client_id + "&cart_uuid=" + cart_uuid
      )
        .then((data) => {
          console.log("CARTUUID", data.details.cart_uuid);
          DataStore.cart_uuid = data.details.cart_uuid;
        })
        .catch((error) => {})
        .then((data) => {});
    },
  },
});
