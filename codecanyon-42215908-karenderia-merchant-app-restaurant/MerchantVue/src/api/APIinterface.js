import { api } from "boot/axios";
import { LocalStorage, SessionStorage } from "quasar";
import auth from "src/api/auth";
import config from "src/api/config";
import { Toast } from "@capacitor/toast";

const APIinterface = {
  setStorage(key, value) {
    try {
      LocalStorage.set(key, value);
    } catch (e) {
      console.debug(e);
    }
  },
  getStorage(key) {
    return LocalStorage.getItem(key);
  },

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

  notify(color, message, icon, $q) {
    $q.notify({
      message,
      color,
      icon,
      position: "bottom",
      html: true,
      timeout: 3000,
      multiLine: false,
    });
  },

  // async showToast(message) {
  //   await Toast.show({
  //     text: message,
  //     duration: "long",
  //   });
  // },

  async showToast(message) {
    let text = "";

    if (Array.isArray(message)) {
      text = message.join("\n"); // or use ', ' if you prefer
    } else {
      text = message;
    }
    await Toast.show({
      text,
      duration: "long",
    });
  },

  ShowAlert(data, isCapacitor, $q, icon) {
    const icons = icon ? icon : "error";
    if (isCapacitor) {
      APIinterface.showToast(data);
    } else {
      APIinterface.notify("dark", data, icons, $q);
    }
  },

  ShowSuccessful(message, $q) {
    $q.notify({
      message: message,
      html: true,
      timeout: 3000,
      position: "top",
      icon: "eva-checkmark-outline",
      iconColor: "green-13",
      classes: "mynotification",
      actions: [
        {
          icon: "eva-close-circle-outline",
          color: "white",
          round: true,
          handler: () => {
            /* ... */
          },
        },
      ],
    });
  },

  notify2(color, textColor, message, icon, position, $q) {
    $q.notify({
      message,
      color,
      textColor,
      icon,
      position,
      html: true,
      timeout: 3000,
      multiLine: false,
      actions: [
        {
          // label: 'Dismiss',
          noCaps: true,
          color: "white",
          handler: () => {
            /* ... */
          },
        },
      ],
    });
  },

  dialog(title, message, labelOk, labelCancel, $q) {
    return new Promise((resolve, reject) => {
      $q.dialog({
        title: title,
        message: message,
        transitionShow: "fade",
        transitionHide: "fade",
        cancel: true,
        ok: {
          size: "md",
          label: labelOk,
          unelevated: true,
          color: "primary",
          "text-color": "white",
          "no-caps": true,
        },
        cancel: {
          size: "md",
          label: labelCancel,
          outline: true,
          color: $q.dark.mode ? "grey600" : "grey",
          "text-color": $q.dark.mode ? "grey300" : "dark",
          "no-caps": true,
        },
      })
        .onOk(() => {
          return resolve(true);
        })
        .onCancel(() => {
          return reject(true);
        })
        .onDismiss(() => {
          return reject(true);
        });
    });
  },

  showLoadingBox(message, $q) {
    $q.loading.show({
      message,
      //boxClass: "bg-white text-dark",
      //spinnerColor: "grey-4",
      boxClass: $q.dark.mode ? "bg-mydark text-white" : "bg-white text-dark",
      spinnerColor: $q.dark.mode ? "bg-bluegrey500" : "grey-4",
      spinnerSize: "30",
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

  getIcon(data) {
    let $icons = [];
    $icons["driver"] = {
      text: "\ue52f",
      fontFamily: "Material Icons",
      color: "#ffffff",
      fontSize: "18px",
    };
    $icons["merchant"] = {
      text: "\uea12",
      fontFamily: "Material Icons",
      color: "#ffffff",
      fontSize: "18px",
    };
    $icons["customer"] = {
      text: "\uea44",
      fontFamily: "Material Icons",
      color: "#ffffff",
      fontSize: "18px",
    };
    return $icons[data];
  },

  async registerDevice(token, deviceUUID, platform) {
    return api
      .post(
        "/registerDevice",
        "token=" +
          token +
          "&device_uiid=" +
          deviceUUID +
          "&platform=" +
          platform,
        {}
      )
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

  async updateDevice(token, deviceUUID, platform) {
    return api
      .post(
        "/updateDevice",
        "token=" +
          token +
          "&device_uiid=" +
          deviceUUID +
          "&platform=" +
          platform,
        {
          headers: {
            Authorization: `token ${auth.getToken()}`,
          },
        }
      )
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

  async fetchData(method, data) {
    return api
      .post("/" + method, data, {
        headers: {
          "Content-Type": "application/json",
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

  async fetchDataPost(method, data) {
    return api
      .post("/" + method, data)
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

  async fetchDataByBearer(method, data) {
    return api
      .post("/" + method, data, {
        headers: {
          "Content-Type": "application/json",
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

  async fetchDataByToken(method, data) {
    return api
      .post("/" + method, data, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `token ${auth.getToken()}`,
        },
      })
      .then((result) => {
        if (result.data.code === 1) {
          return result.data;
        } else if (result.data.code === 3) {
          return result.data;
        } else {
          throw result.data.msg;
        }
      })
      .catch((error) => {
        throw error;
      });
  },

  async fetchDataByTokenPost(method, data) {
    return api
      .post("/" + method, data, {
        headers: {
          Authorization: `token ${auth.getToken()}`,
        },
      })
      .then((result) => {
        if (result.data.code === 1) {
          return result.data;
        } else if (result.data.code === 3) {
          return result.data;
        } else {
          throw result.data.msg;
        }
      })
      .catch((error) => {
        throw error;
      });
  },

  async PaymentPost(method, data) {
    return api
      .post(config.api_base_url + "/interfacesubscription" + method, data, {
        headers: {
          "Content-Type": "application/json",
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

  async fetchGet(method, data) {
    return api
      .get("/" + method, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `token ${auth.getToken()}`,
        },
        params: data, // Attach the data as query parameters
      })
      .then((result) => {
        if (result.data.code === 1) {
          return result.data;
        } else if (result.data.code === 3) {
          return result.data;
        } else {
          throw result.data.msg;
        }
      })
      .catch((error) => {
        throw error;
      });
  },

  async fetchGetRequest(method, data) {
    return api
      .get(`${method}/?${data}`)
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
