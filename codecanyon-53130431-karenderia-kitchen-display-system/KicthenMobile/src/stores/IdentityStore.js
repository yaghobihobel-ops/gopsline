import { jwtDecode } from "jwt-decode";
import { defineStore } from "pinia";

export const useIdentityStore = defineStore("identity", {
  state: () => ({
    auth_token: null,
    user_data: null,
  }),

  getters: {
    doubleCount(state) {
      return state.counter * 2;
    },
  },

  persist: true,

  actions: {
    authenticated() {
      if (
        typeof this.auth_token === "undefined" ||
        this.auth_token === null ||
        this.auth_token === "" ||
        this.auth_token === "null" ||
        this.auth_token === "undefined"
      ) {
        return false;
      }
      return true;
    },
    logout() {
      this.auth_token = null;
      this.user_data = null;
    },
    getUserData() {
      try {
        const data = jwtDecode(this.user_data);
        return data;
      } catch (err) {}
    },
  },
});
