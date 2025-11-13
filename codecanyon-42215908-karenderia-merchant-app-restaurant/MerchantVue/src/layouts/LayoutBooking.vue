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
        <NotiButton sound_id="notify_booking"></NotiButton>
        <q-btn round color="grey" icon="search" flat @click="searchPage" />
      </q-toolbar>
    </q-header>

    <q-footer bordered class="bg-white text-dark modified-footer">
      <q-tabs
        v-model="tab"
        dense
        indicator-color="transparent"
        active-color="secondary"
        align="justify"
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
          name="settings"
          icon="las la-cog"
          :label="$t('Settings')"
          no-caps
          to="/table/settings"
          class="routertab_small"
        />
        <q-route-tab
          name="list"
          icon="las la-chart-area"
          :label="$t('List')"
          no-caps
          to="/table/menu"
          class="routertab_small"
        />
        <q-route-tab
          name="shifts"
          icon="las la-people-carry"
          :label="$t('Shifts')"
          no-caps
          to="/table/shifts"
          class="routertab_small"
        />
        <q-route-tab
          name="rooms"
          icon="las la-door-closed"
          :label="$t('Rooms')"
          no-caps
          to="/table/rooms"
          class="routertab_small"
        />
        <q-route-tab
          name="tables"
          icon="las la-chair"
          :label="$t('Tables')"
          no-caps
          to="/table/tables"
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

export default defineComponent({
  name: "NoTopLayout",
  components: {
    NotiButton: defineAsyncComponent(() => import("components/NotiButton.vue")),
  },
  setup() {
    const DataStore = useDataStore();
    const SearchStore = useSearchStore();
    return { DataStore, SearchStore };
  },
  data() {
    return {
      online: true,
      tab: "home",
      loading: false,
    };
  },
  created() {
    this.$q.dark.set(this.DataStore.dark_mode);
  },
  methods: {
    searchPage() {
      console.log(this.$route.path);
      switch (this.$route.path) {
        case "/table/menu":
        case "/table/settings":
          this.SearchStore.clearData();
          this.$router.push("/tables/search");
          break;
        case "/table/shifts":
          this.SearchStore.clearData();
          this.$router.push("/tables/search-shift");
          break;

        case "/table/rooms":
          this.SearchStore.clearData();
          this.$router.push("/tables/search-rooms");
          break;

        case "/table/tables":
          this.SearchStore.clearData();
          this.$router.push("/tables/search-tables");
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
