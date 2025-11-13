import { defineStore } from "pinia";
import jwtDecode from "jwt-decode";
import APIinterface from "src/api/APIinterface";

export const useAccessStore = defineStore("access", {
  state: () => ({
    menu_access: [],
    app_settings: null,
  }),
  persist: true,
  getters: {
    getAccess(state) {
      try {
        return jwtDecode(state.menu_access);
      } catch (err) {
        return false;
      }
    },
  },

  actions: {
    clearCache() {
      this.$reset();
    },

    hasAccess(data) {
      try {
        let menu_access = jwtDecode(this.menu_access);
        if (Object.keys(menu_access).length > 0) {
          if (menu_access.includes(data) === false) {
            return false;
          }
        }
        return true;
      } catch (err) {
        return false;
      }
    },
    getRefreshAccess() {
      this.app_settings = null;
      APIinterface.fetchDataByTokenPost("getRefreshAccess")
        .then((data) => {
          this.menu_access = data.details.menu_access;
          this.app_settings = data.details.app_settings;
        })
        .catch((error) => {
          this.menu_access = [];
        })
        .then((data) => {});
    },
  },
});
