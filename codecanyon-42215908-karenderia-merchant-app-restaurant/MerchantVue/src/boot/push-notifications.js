import { boot } from "quasar/wrappers";
import auth from "src/api/auth";
import { useDataStore } from "stores/DataStore";
import config from "src/api/config";
import { useUserStore } from "stores/UserStore";

// "async" is optional;
// more info on params: https://v2.quasar.dev/quasar-cli/boot-files
export default boot(async ({ app, router, store }) => {
  //console.log("Initializing push notifications...", config.topic);

  router.beforeEach((to, from, next) => {
    const DataStore = useDataStore();
    const userStore = useUserStore();
    userStore.show_subscribe_push = null;
    const isLogin = auth.authenticated();
    const Count = userStore.show_subscribe_push_count;
    let isCapacitor = app.config.globalProperties.$q.platform.is.capacitor;

    if (typeof isCapacitor === "undefined") {
      console.log("isCapacitor is undefined");
      isCapacitor = null;
    }
    // console.log("push_notifications", DataStore.push_notifications);
    // console.log("push_off", DataStore.push_off);
    // console.log("Count", Count);
    //console.log("isCapacitor", isCapacitor);

    if (
      isLogin &&
      !DataStore.push_notifications &&
      !DataStore.push_off &&
      isCapacitor
    ) {
      if (Count <= 0) {
        console.log("SUBSCRIBE TO TOPICS");
        userStore.show_subscribe_push = {
          show: true,
        };
      }
    }
    next();
  });
});
