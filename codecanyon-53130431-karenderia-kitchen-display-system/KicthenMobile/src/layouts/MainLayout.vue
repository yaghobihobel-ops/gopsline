<template>
  <q-layout view="lHh lpR lFf">
    <q-drawer
      show-if-above
      v-model="KitchenStore.drawer"
      side="left"
      :width="200"
      :breakpoint="1000"
      :mini="!KitchenStore.drawer || KitchenStore.miniState"
      @click.capture="drawerClick"
    >
      <q-scroll-area class="fit" :horizontal-thumb-style="{ opacity: 0 }">
        <div class="column" style="height: calc(100vh)">
          <div class="col">
            <q-list padding class="q-gutter-y-md q-mt-md">
              <q-item clickable v-ripple to="/current">
                <q-item-section avatar>
                  <q-icon name="eva-book-open-outline">
                    <q-badge
                      v-if="KitchenStore.getCurrentCount > 0"
                      color="red"
                      floating
                      rounded
                      style="top: -8px; right: -5px"
                    >
                      {{ KitchenStore.getCurrentCount }}
                    </q-badge>
                  </q-icon>
                </q-item-section>
                <q-item-section> {{ $t("Current") }} </q-item-section>
              </q-item>
              <q-item clickable v-ripple to="/scheduled">
                <q-item-section avatar>
                  <q-icon name="eva-clock-outline">
                    <q-badge
                      v-if="KitchenStore.getScheduleCount > 0"
                      color="red"
                      floating
                      rounded
                      style="top: -8px; right: -5px"
                    >
                      {{ KitchenStore.getScheduleCount }}
                    </q-badge>
                  </q-icon>
                </q-item-section>
                <q-item-section> {{ $t("Scheduled") }} </q-item-section>
              </q-item>
              <q-item clickable v-ripple to="/history">
                <q-item-section avatar>
                  <q-icon name="eva-checkmark-circle-2-outline" />
                </q-item-section>
                <q-item-section> {{ $t("History") }} </q-item-section>
              </q-item>
            </q-list>
          </div>
          <div class="col-3">
            <q-list padding>
              <q-item clickable v-ripple @click="ConfirmLogout">
                <q-item-section avatar>
                  <q-icon name="eva-log-out-outline" />
                </q-item-section>
                <q-item-section> {{ $t("Logout") }} </q-item-section>
              </q-item>
            </q-list>
          </div>
        </div>
      </q-scroll-area>
    </q-drawer>

    <q-page-container
      :class="{
        'bg-white': $q.screen.lt.md,
        'bg-custom-grey': !$q.screen.lt.md,
        'bg-grey600': $q.dark.mode,
      }"
    >
      <!-- bg-custom-grey -->
      <RealtimeComponents ref="ref_realtime"></RealtimeComponents>
      <router-view />
    </q-page-container>

    <q-page-scroller position="bottom" :scroll-offset="150" :offset="[18, 18]">
      <q-btn
        fab
        icon="eva-arrow-upward-outline"
        color="primary"
        text-color="secondary"
        unelevated
        :padding="$q.screen.gt.xs ? '10px' : '5px'"
      />
    </q-page-scroller>

    <template v-if="$q.screen.lt.md">
      <q-page-sticky
        position="bottom-right"
        :offset="[18, 18]"
        style="z-index: 99"
      >
        <q-btn
          @click="ConfirmLogout"
          fab
          icon="eva-log-out-outline"
          color="negative"
          :padding="$q.screen.gt.sm ? '15px' : '10px'"
        />
      </q-page-sticky>
    </template>

    <FilterModal ref="ref_filter_modal"></FilterModal>
  </q-layout>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useKitchenStore } from "stores/KitchenStore";
import { useIdentityStore } from "stores/IdentityStore";
import { useSettingStore } from "stores/SettingStore";
import APIinterface from "src/api/APIinterface";

export default {
  components: {
    FilterModal: defineAsyncComponent(() =>
      import("components/FilterModal.vue")
    ),
    RealtimeComponents: defineAsyncComponent(() =>
      import("components/RealtimeComponents.vue")
    ),
  },
  data() {
    return {
      is_search: false,
    };
  },
  setup() {
    const KitchenStore = useKitchenStore();
    const IdentityStore = useIdentityStore();
    const SettingStore = useSettingStore();
    return { KitchenStore, IdentityStore, SettingStore };
  },
  mounted() {
    //console.log("Current route name:", this.$route.name);
    this.KitchenStore.miniState = true;
  },
  methods: {
    drawerClick(e) {
      if (this.KitchenStore.miniState) {
        this.KitchenStore.miniState = false;
        e.stopPropagation();
      }
    },
    ConfirmLogout() {
      APIinterface.confirm(
        this.$q,
        "Sign Out",
        "Do you want to logout?",
        "Yes",
        "Cancel",
        this.$t
      )
        .then((data) => {
          this.logout();
        })
        .catch((error) => {
          console.log("error", error);
        })
        .then((data) => {});
    },
    logout() {
      this.IdentityStore.logout();
      this.$router.replace("/login");
    },
  },
};
</script>
