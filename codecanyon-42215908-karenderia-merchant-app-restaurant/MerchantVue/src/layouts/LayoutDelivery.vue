<template>
  <q-layout view="lHh Lpr lFf">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
      reveal
      reveal-offset="10"
    >
      <q-toolbar>
        <q-toggle
          v-model="online"
          color="primary"
          :label="$t('Online')"
          @update:model-value="setOnline"
        />
        <q-toolbar-title></q-toolbar-title>

        <NotiButton sound_id="notify_delivery"></NotiButton>
        <q-btn round color="grey" icon="search" flat @click="searchPage" />
      </q-toolbar>
    </q-header>

    <q-footer bordered class="bg-white text-dark modified-footer">
      <q-tabs
        v-model="tab"
        dense
        indicator-color="transparent"
        active-color="secondary"
        :class="{
          'bg-mydark text-white': $q.dark.mode,
          'text-dark': !$q.dark.mode,
        }"
      >
        <q-route-tab
          name="home"
          icon="las la-home"
          :label="$t('Home')"
          no-caps
          to="/dashboard"
          class="routertab_small"
        />
        <q-route-tab
          name="create"
          icon="o_account_balance"
          :label="$t('Cashout')"
          no-caps
          to="/delivery-management/cashout"
          class="routertab_small"
        />
        <q-route-tab
          name="on_hold"
          icon="o_account_balance_wallet"
          :label="$t('Collect')"
          no-caps
          to="/delivery-management/collect-cash"
          class="routertab_small"
        />
        <q-route-tab
          name="driver_list"
          icon="o_people"
          :label="$t('Driver')"
          no-caps
          to="/delivery-management/driver"
          class="routertab_small"
        />
        <q-route-tab
          name="car_list"
          icon="o_drive_eta"
          :label="$t('Car')"
          no-caps
          to="/delivery-management/car"
          class="routertab_small"
        />
        <q-route-tab
          name="groups"
          icon="o_group_add"
          :label="$t('Groups')"
          no-caps
          to="/delivery-management/groups"
          class="routertab_small"
        />
        <q-route-tab
          name="zones"
          icon="o_fmd_good"
          :label="$t('Zones')"
          no-caps
          to="/delivery-management/zones"
          class="routertab_small"
        />
        <q-route-tab
          name="schedule"
          icon="o_schedule"
          :label="$t('Schedule')"
          no-caps
          to="/delivery-management/schedule"
          class="routertab_small"
        />
        <q-route-tab
          name="shifts"
          icon="o_list_alt"
          :label="$t('Shifts')"
          no-caps
          to="/delivery-management/shifts"
          class="routertab_small"
        />
        <q-route-tab
          name="reviews"
          icon="o_star_border"
          :label="$t('Reviews')"
          no-caps
          to="/delivery-management/reviews"
          class="routertab_small"
        />
      </q-tabs>
    </q-footer>

    <q-page-container
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
    >
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
import { defineComponent, defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";
import { useSearchStore } from "stores/SearchStore";
import { useCartStore } from "stores/CartStore";

export default defineComponent({
  name: "LayoutPos",
  components: {
    NotiButton: defineAsyncComponent(() => import("components/NotiButton.vue")),
  },
  setup() {
    const DataStore = useDataStore();
    const SearchStore = useSearchStore();
    const CartStore = useCartStore();
    return { DataStore, SearchStore, CartStore };
  },
  data() {
    return {
      online: true,
      tab: "home",
      loading: false,
      path: "",
    };
  },
  created() {
    this.$q.dark.set(this.DataStore.dark_mode);
    this.path = this.$route.path;
  },
  updated() {
    this.path = this.$route.path;
  },
  methods: {
    searchPage() {
      console.log(this.$route.path);
      switch (this.$route.path) {
        case "/test":
          this.$router.push("/pos-order/search-on-hold");
          break;
        default:
          this.DataStore.search_item = "";
          this.$router.push("/search/food");
          break;
      }
    },
    setOnline() {
      let offline_title = !this.online
        ? "Confirm Going Offline"
        : "Confirm Going Online";

      let offline_message = !this.online
        ? this.$t(
            "Are you sure you want to take your business offline temporarily? This will prevent new orders from coming in. Your current orders will still be processed."
          )
        : this.$t(
            "Are you sure you want to take your business online and start accepting orders again?"
          );

      this.$q
        .dialog({
          title: this.$t(offline_title),
          message: offline_message,
          cancel: true,
          persistent: true,
          ok: {
            color: "dark",
            flat: true,
            "no-caps": true,
            label: this.$t("Confirm"),
          },
          cancel: {
            color: "primary",
            flat: true,
            "no-caps": true,
            label: this.$t("Cancel"),
          },
        })
        .onOk(() => {
          this.DataStore.setStoreAvailable(this.online);
        })
        .onCancel(() => {
          this.online = !this.online;
        })
        .onDismiss(() => {
          //
        });
    },
  },
});
</script>
