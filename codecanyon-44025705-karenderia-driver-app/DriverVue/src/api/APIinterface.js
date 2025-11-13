import { api } from "boot/axios";
import { LocalStorage, SessionStorage } from "quasar";
import auth from "src/api/auth";
import { DateTime, Settings } from "luxon";
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

  notify2(color, textColor, message, icon, position, $q) {
    $q.notify({
      message,
      color,
      textColor,
      icon,
      position,
      html: true,
      timeout: 3000,
      multiLine: true,
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

  async showToast(message) {
    await Toast.show({
      text: message,
      duration: "long",
    });
  },

  showAlert(title, message, $q) {
    $q.dialog({
      title: '<span class="font16 text-weight-bold">' + title + "</span>",
      message: '<span class="font12 text-weight-light">' + message + "</span>",
      persistent: true,
      html: true,
      ok: {
        unelevated: true,
        outline: true,
        size: "md",
        label: "Ok",
        color: "primary",
        "no-caps": true,
      },
    })
      .onOk(() => {
        // console.log('OK')
      })
      .onCancel(() => {
        // console.log('Cancel')
      })
      .onDismiss(() => {
        // console.log('I am triggered on both OK and Cancel')
      });
  },

  showLoadingBox(message, $q) {
    $q.loading.show({
      message,
      boxClass: "bg-white text-dark",
      spinnerColor: "grey-4",
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

  getTimezone() {
    let $timezone = APIinterface.getStorage("timezone");
    if (!APIinterface.empty($timezone)) {
      return $timezone;
    }
    return false;
  },

  getDateNow() {
    //console.log("getDateNow timezone set=>" + Settings.defaultZoneName);
    const dateNow = DateTime.now().toFormat("yyyy-MM-dd");
    return dateNow;
  },

  getDateTimeNow() {
    //console.log("getDateNow timezone set=>" + Settings.defaultZoneName);
    const dateNow = DateTime.now().toISO();
    return dateNow;
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

  getLineSymbol() {
    const lineSymbol = {
      path: google.maps.SymbolPath.CIRCLE,
      scale: 8,
      strokeColor: "#f44336",
    };
    return lineSymbol;
  },

  async userLogin(data) {
    return api
      .post("/login", data, {
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

  async requestResetPassword(data) {
    return api
      .post("/requestresetPassword", data, {
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

  async resendResetPassword(data) {
    return api
      .post("/resendresetPassword", "uuid=" + data)
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

  async registerUser(data) {
    return api
      .post("/register", data, {
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

  async getLocationCountries() {
    return api
      .post("/getLocationCountries", {})
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

  async getAccountStatus(uuid) {
    return api
      .post("/getAccountStatus", "uuid=" + uuid)
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

  async verifyCode(data) {
    return api
      .post("/verifycode", data, {
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

  async requestCode(data) {
    return api
      .post("/requestcode", data, {
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

  async addLicense(data) {
    return api
      .post("/addlicense", data, {
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

  async addLicensephoto(data) {
    return api
      .post("/addlicensephoto", data, {
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

  async updateLicense(data) {
    return api
      .post("/updatelicense", data, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `token ${auth.getToken()}`,
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

  async getShift(data) {
    return api
      .post("/getshift", data, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `token ${auth.getToken()}`,
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

  async startShift(data) {
    return api
      .post("/startShift", data, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `token ${auth.getToken()}`,
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

  async endShift(data) {
    return api
      .post("/endShift", data, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `token ${auth.getToken()}`,
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

  async orderPreview(data) {
    return api
      .post("/orderpreview", data, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `token ${auth.getToken()}`,
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

  async acceptOrder(data) {
    return api
      .post("/acceptOrder", data, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `token ${auth.getToken()}`,
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

  async declineOrder(data) {
    return api
      .post("/declineorder", data, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `token ${auth.getToken()}`,
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

  async getRealtime(data) {
    return api
      .post("/getRealtime", "getevent=" + data, {
        headers: {
          Authorization: `token ${auth.getToken()}`,
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
        } else {
          throw result.data.msg;
        }
      })
      .catch((error) => {
        throw error;
      });
  },

  async fetchDataByTokenPost2(method, data) {
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
      .post(config.api_payment_url + "/" + method, data, {
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
        } else {
          throw result.data.msg;
        }
      })
      .catch((error) => {
        throw error;
      });
  },

  //
};
export default APIinterface;
