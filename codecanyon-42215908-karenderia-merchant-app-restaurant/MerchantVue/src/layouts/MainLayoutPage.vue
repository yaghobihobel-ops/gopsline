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
          :icon="getIconDirections"
          color="blue-grey-1"
          text-color="blue-grey-8"
          unelevated
          dense
          @click="$router.back()"
        ></q-btn>

        <template v-if="DataStore.page_title">
          <q-toolbar-title>
            {{ $t(DataStore.page_title) }}
          </q-toolbar-title>
        </template>
        <template v-else-if="DataStore.page_chat_data">
          <q-avatar size="30px" v-if="DataStore.page_chat_data?.avatar">
            <q-img :src="DataStore.page_chat_data?.avatar">
              <template v-slot:loading>
                <q-skeleton
                  height="30px"
                  width="30px"
                  square
                  class="bg-grey-2"
                />
              </template>
            </q-img>
          </q-avatar>
          <q-toolbar-title class="q-ml-none">{{
            DataStore.page_chat_data?.name
          }}</q-toolbar-title>
        </template>

        <q-space></q-space>
        <div v-if="DataStore.page_subtitle">{{ DataStore.page_subtitle }}</div>
        <q-btn
          v-if="DataStore.page_delete"
          unelevated
          round
          dense
          icon="las la-trash"
          color="red-1"
          text-color="red-9"
          @click="
            DataStore.page_delete_actions = !DataStore.page_delete_actions
          "
        />
      </q-toolbar>
    </q-header>

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
    </q-page-container>

    <PrinterAuto></PrinterAuto>
  </q-layout>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import { useDataPersisted } from "stores/DataPersisted";
import { defineAsyncComponent } from "vue";

export default {
  name: "NotopfooterLayout",
  components: {
    PrinterAuto: defineAsyncComponent(() =>
      import("components/PrinterAuto.vue")
    ),
  },
  setup() {
    const DataStore = useDataStore();
    const DataPersisted = useDataPersisted();
    return { DataStore, DataPersisted };
  },
  data() {
    return {
      isScrolled: false,
    };
  },
  mounted() {
    this.$q.dark.set(this.DataStore.dark_mode);
  },
  computed: {
    getIconDirections() {
      return this.DataPersisted.rtl
        ? "keyboard_arrow_right"
        : "keyboard_arrow_left";
    },
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
