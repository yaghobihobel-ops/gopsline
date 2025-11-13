import { api } from "boot/axios";
import { LocalStorage, SessionStorage } from "quasar";
import config from "src/api/config";
import { useIdentityStore } from "stores/IdentityStore";
const API_METHOD = "apikitchen";

const APIinterface = {
  setSession(key, value) {
    try {
      SessionStorage.set(key, value);
    } catch (e) {
      console.debug(e);
    }
  },
  getSession(key) {
    return SessionStorage.getItem(key);
  },

  notify($q, message, caption, color, icon, position) {
    $q.notify({
      message: message,
      caption: caption,
      position: position,
      color: color,
      textColor: "dark",
      icon: icon,
      iconColor: color,
      classes: "primevue_toats",
      html: true,
      timeout: 3000,
      multiLine: false,
      actions: [
        {
          icon: "close",
          color: color,
          round: true,
          handler: () => {
            /* ... */
          },
        },
      ],
    });
  },

  async showToast(message) {
    await Toast.show({
      text: message,
      duration: "long",
    });
  },

  dialog(message, $q) {
    const dialog = $q.dialog({
      message: message,
      progress: true,
      persistent: true,
      ok: false,
      html: true,
    });
    return dialog;
  },

  showLoadingBox(message, $q) {
    $q.loading.show({
      message,
      boxClass: "bg-white text-dark text-body1",
      spinnerColor: "primary",
      spinnerSize: "50",
      html: true,
    });
  },

  hideLoadingBox($q) {
    $q.loading.hide();
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

  inArray(needle, haystack) {
    const length = haystack.length;
    for (let i = 0; i < length; i++) {
      if (haystack[i] === needle) return true;
    }
    return false;
  },

  getDateNow() {
    var currentDate = new Date();
    var formatted_date = new Date().toJSON().slice(0, 10).replace(/-/g, "-");
    return formatted_date;
  },

  async confirm($q, title, message, YesLabel, CanceLabel, t) {
    return new Promise(async function (resolve, reject) {
      $q.dialog({
        title: t(title),
        message: t(message),
        cancel: true,
        persistent: true,
        ok: {
          label: t(YesLabel),
          "no-caps": true,
          flat: true,
        },
        cancel: {
          label: t(CanceLabel),
          "no-caps": true,
          flat: true,
        },
      })
        .onOk(() => {
          console.log(">>>> OK");
          resolve(true);
        })
        .onCancel(() => {
          console.log(">>>> Cancel");
          reject("cancel");
        });
    });
  },

  async fetchData(method, data) {
    return api
      .post("/" + API_METHOD + "/" + method, data)
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

  async fetchDataGet(method, data) {
    let request = data ? method + "/?" + data : method;
    try {
      const IdentityStore = useIdentityStore();
      const result = await api.get("/" + API_METHOD + "/" + request, {
        headers: {
          Authorization: `token ${IdentityStore.auth_token}`,
        },
      });
      if (result.data.code === 1) {
        return result.data.details;
      } else {
        throw result.data.msg;
      }
    } catch (error) {
      throw error;
    }
  },

  async fetchDataPost(method, data) {
    const IdentityStore = useIdentityStore();
    return api
      .post("/" + API_METHOD + "/" + method, data, {
        headers: {
          Authorization: `token ${IdentityStore.auth_token}`,
        },
      })
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
export default APIinterface;
