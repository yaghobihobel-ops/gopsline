import { boot } from "quasar/wrappers";
import { loadAppSettings } from "src/api/SettingsLoader";
import auth from "src/api/auth";
import { Device } from "@capacitor/device";
import { App } from "@capacitor/app";
import { useDataStore } from "src/stores/DataStore";
import { useAccessStore } from "src/stores/AccessStore";
import { Platform } from "quasar";
import { Network } from "@capacitor/network";
import APIinterface from "src/api/APIinterface";
import { PushNotifications } from "@capacitor/push-notifications";

let close_count = 0;

export default boot(async (app, router) => {
  const DataStore = useDataStore();
  const isLogin = auth.authenticated();
  const AccessStore = useAccessStore();

  try {
    await loadAppSettings();
  } catch (error) {
    console.error("Error loading settings:", error);
  }

  // NETWORK STATUS
  try {
    const network_status = await Network.getStatus();
    if (network_status?.connected) {
      DataStore.hasConnections = true;
    }
  } catch (error) {
    DataStore.hasConnections = false;
  }

  // VERIFY LOGIN STATUS
  if (isLogin) {
    try {
      await auth.authenticate();
    } catch (error) {
      if (DataStore.hasConnections) {
        auth.logout();
      }
    }

    // GET REFRESH ACCESS
    try {
      AccessStore.getRefreshAccess();
    } catch (error) {}
  }

  try {
    const info = await Device.getLanguageCode();
    DataStore.device_language = info.value;
  } catch (error) {}

  // GET DEVICE
  try {
    const info = await Device.getInfo();
    DataStore.osVersion = info.osVersion;
  } catch (error) {
    console.log("error", error);
  }

  if (!Platform.is.capacitor) {
    //
    return;
  }

  try {
    const result = await App.getInfo();
    DataStore.app_version = result.version;
  } catch (error) {
    console.log("error", error);
  }

  // Handle Android back button
  App.addListener("backButton", (data) => {
    close_count++;
    if (!data.canGoBack) {
      if (close_count >= 2) {
        App.exitApp();
      } else {
        APIinterface.showToast("Press BACK again to exit");
        setTimeout(() => {
          close_count = 0;
        }, 1000);
      }
    }
  });

  // Clear iOS delivered notifications when app becomes active
  App.addListener("appStateChange", (data) => {
    if (data.isActive && app.config.globalProperties.$q.platform.is.ios) {
      PushNotifications.removeAllDeliveredNotifications().catch(console.error);
    }
  });

  // Check network status on startup
  Network.getStatus().then((status) => {
    if (!status.connected) {
      router.push("/errornetwork");
    }
  });

  // Listen for network changes
  Network.addListener("networkStatusChange", (status) => {
    if (!status.connected) {
      APIinterface.showToast("No internet connection");
      router.push("/errornetwork");
    }
  });

  //
});
