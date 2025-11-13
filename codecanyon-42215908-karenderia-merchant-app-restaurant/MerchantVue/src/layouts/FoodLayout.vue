<template>
  <q-layout view="hHr lpR fFr">
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
          icon="keyboard_arrow_left"
          color="blue-grey-1"
          text-color="blue-grey-8"
          unelevated
          dense
          @click="$router.back()"
        ></q-btn>
        <q-toolbar-title>
          {{ MenuStore.page_title }}
        </q-toolbar-title>
        <q-space></q-space>

        <q-btn
          round
          icon="eva-menu-outline"
          color="oranges"
          text-color="orange-8"
          unelevated
          dense
          @click="drawer = !drawer"
        ></q-btn>
      </q-toolbar>
    </q-header>

    <q-drawer
      v-model="drawer"
      side="right"
      behavior="mobile"
      no-swipe-open
      no-swipe-close
      no-swipe-backdrop
      width="350"
    >
      <div class="q-pa-md">
        <q-btn
          icon="close"
          color="grey-4"
          flat
          @click="drawer = !drawer"
          padding="0"
        ></q-btn>
      </div>
      <!--padding -->

      <q-card flat class="beautiful-shadowx border-greyx no-border-radius">
        <q-tabs
          v-model="shortcut_nav"
          no-caps
          indicator-color="transparent"
          active-bg-color="grey-1"
          class="custom-tabs"
        >
          <template v-for="items in MenuStore.sideBarmenu" :key="items">
            <q-route-tab :name="items.id" :to="items.path">
              <template v-slot:default>
                <img :src="items.icon" width="30" />
                <div class="text-caption q-mt-sm no-wrap tab-label">
                  {{ items.name }}
                </div>
              </template>
            </q-route-tab>
          </template>
        </q-tabs>
      </q-card>
    </q-drawer>

    <q-page-container>
      <q-scroll-observer @scroll="onScroll" scroll-target="body" />
      <transition
        enter-active-class="animated fadeIn"
        leave-active-class="animated fadeOut"
        appear
        :duration="300"
      >
        <router-view />
      </transition>

      <q-page-scroller
        position="bottom"
        :scroll-offset="150"
        :offset="[18, 18]"
      >
        <q-btn
          fab
          icon="keyboard_arrow_up"
          color="blue-grey-1"
          text-color="blue-grey-8"
          padding="10px"
        />
      </q-page-scroller>
    </q-page-container>
  </q-layout>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import { useMenuStore } from "src/stores/MenuStore";

export default {
  name: "NotopfooterLayout",
  components: {},
  setup() {
    const DataStore = useDataStore();
    const MenuStore = useMenuStore();
    return { DataStore, MenuStore };
  },
  data() {
    return {
      drawer: false,
      isScrolled: false,
      shortcut_nav: null,
    };
  },
  created() {
    this.$q.dark.set(this.DataStore.dark_mode);
  },
  methods: {
    onScroll(info) {
      if (!info) {
        return;
      }
      this.isScrolled = info.position.top > 20;
    },
  },
};
</script>

<style lang="css">
.custom-tabs .q-tabs__content {
  flex-wrap: wrap !important; /* allow wrapping */
}

.custom-tabs .q-tab {
  flex: 0 0 25%; /* 4 per row */
  justify-content: center;
  min-width: 110px;
  margin-bottom: 10px;
}
.tab-label {
  display: block;
  width: 100%; /* take full width of tab */
  text-align: center; /* center text */
  overflow: hidden; /* required for ellipsis */
  white-space: nowrap;
  text-overflow: ellipsis;
}
</style>
