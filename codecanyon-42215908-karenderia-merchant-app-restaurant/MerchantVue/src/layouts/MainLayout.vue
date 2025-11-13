<template>
  <q-layout view="lHh Lpr lFf">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
        'beautiful-shadow': isScrolled,
      }"
    >
      <q-toolbar class="q-gutter-x-sm">
        <q-btn
          round
          icon="eva-menu-outline"
          color="oranges"
          text-color="orange-8"
          unelevated
          dense
          to="/account-menu"
        ></q-btn>
        <PauseOrder></PauseOrder>

        <q-toolbar-title></q-toolbar-title>

        <ChatNotifications
          sound_id="chat"
          :count="UserStore.getChatCount"
        ></ChatNotifications>
        <NotiButton
          sound_id="notify_mainlayout"
          :count="UserStore.getAlertCount"
          :visible="true"
        ></NotiButton>
        <q-btn
          round
          unelevated
          color="amber-1"
          text-color="amber-8"
          to="/search"
        >
          <img src="/svg/search.svg" width="25" height="25" />
        </q-btn>
      </q-toolbar>
    </q-header>

    <q-footer class="bg-white text-dark footer-shadow top-rounded">
      <TabsMenu></TabsMenu>
    </q-footer>

    <q-page-container
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
    >
      <q-scroll-observer @scroll="onScroll" scroll-target="body" />
      <transition
        enter-active-class="animated fadeIn"
        leave-active-class="animated fadeOut"
        appear
        :duration="300"
      >
        <router-view />
      </transition>
    </q-page-container>

    <PrinterAuto></PrinterAuto>
  </q-layout>
</template>

<script>
import { defineComponent, defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";
import { useUserStore } from "stores/UserStore";
// import { useAccessStore } from "stores/AccessStore";
// import { useGlobalStore } from "stores/GlobalStore";
// import { useCartStore } from "stores/CartStore";
import { FCM } from "@capacitor-community/fcm";
import auth from "src/api/auth";
import { useDataPersisted } from "src/stores/DataPersisted";

export default defineComponent({
  name: "MainLayout",
  components: {
    TabsMenu: defineAsyncComponent(() => import("components/TabsMenu.vue")),
    NotiButton: defineAsyncComponent(() => import("components/NotiButton.vue")),
    PauseOrder: defineAsyncComponent(() => import("components/PauseOrder.vue")),
    ChatNotifications: defineAsyncComponent(() =>
      import("components/ChatNotifications.vue")
    ),
    PrinterAuto: defineAsyncComponent(() =>
      import("components/PrinterAuto.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    const UserStore = useUserStore();
    const DataPersisted = useDataPersisted();
    // const AccessStore = useAccessStore();
    // const GlobalStore = useGlobalStore();
    // const CartStore = useCartStore();
    return { DataStore, UserStore, DataPersisted };
  },
  data() {
    return {
      online: false,
      tab: "home",
      loading: false,
      drawer: false,
      isScrolled: false,
    };
  },
  mounted() {
    this.$q.dark.set(this.DataStore.dark_mode);
    this.checkAppVersion();
  },
  methods: {
    onScroll(info) {
      if (!info) {
        return;
      }
      this.isScrolled = info.position.top > 20;
    },
    checkAppVersion() {
      if (!this.$q.capacitor) {
        return;
      }
      if (
        this.$q.platform.is.android &&
        this.DataStore.app_version_android > 0
      ) {
        if (this.DataStore.app_version_android > this.DataStore.app_version) {
          this.$router.replace("/update-app");
        }
      } else if (
        this.$q.platform.is.ios &&
        this.DataStore.app_version_ios > 0
      ) {
        if (this.DataStore.app_version_ios > this.DataStore.app_version) {
          this.$router.replace("/update-app");
        }
      }
    },
  },
});
</script>
