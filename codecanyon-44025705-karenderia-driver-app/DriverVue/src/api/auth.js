import { api } from "boot/axios";
import { LocalStorage, SessionStorage } from "quasar";
import jwtDecode from "jwt-decode";

const auth = {
  authenticated() {
    if (this.getToken()) {
      return true;
    }
    return false;
  },

  setUser(user) {
    LocalStorage.set("driver_identity", user);
  },

  getUser() {
    if (LocalStorage.has("driver_identity")) {
      const $data = LocalStorage.getItem("driver_identity");
      if (!this.empty($data)) {
        if (Object.keys($data).length > 0) {
          try {
            return jwtDecode($data);
          } catch (err) {
            return false;
          }
        }
      }
    }
    return false;
  },

  setToken(token) {
    LocalStorage.set("driver_token", token);
  },

  getToken() {
    if (LocalStorage.has("driver_token")) {
      const $data = LocalStorage.getItem("driver_token");
      if (!this.empty($data)) {
        return $data;
      }
    }
    return false;
  },

  setDarkmode(data) {
    LocalStorage.set("dark_mode", data);
  },

  getDarkmode() {
    if (LocalStorage.has("dark_mode")) {
      const $data = LocalStorage.getItem("dark_mode");
      if (!this.empty($data)) {
        return $data;
      }
    }
    return false;
  },

  logout() {
    LocalStorage.remove("driver_token");
    LocalStorage.remove("driver_identity");
  },

  empty(data) {
    if (
      typeof data === "undefined" ||
      data === null ||
      data === "" ||
      data === "null" ||
      data === "undefined"
    ) {
      return true;
    }
    return false;
  },

  async authenticate() {
    return api
      .post("/authenticate", "token=" + this.getToken())
      .then((result) => {
        if (result.data.code === 1) {
          return result.data;
        } else {
          throw result.data.msg;
        }
      })
      .catch((error) => {
        throw error;
      });
  },
};
export default auth;
