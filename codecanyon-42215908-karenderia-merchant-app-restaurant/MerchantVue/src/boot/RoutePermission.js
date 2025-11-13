import { boot } from "quasar/wrappers";
import { useAccessStore } from "stores/AccessStore";

export default boot(({ router, store }) => {
  const AccessStore = useAccessStore();

  router.beforeEach((to, from, next) => {
    //console.log(to.meta);
    if (to.meta.checkPermission) {
      if (AccessStore.hasAccess(to.meta.permissionName)) {
        next();
      } else {
        next({ path: "/access-denied" });
      }
    } else {
      next();
    }
  });
});
