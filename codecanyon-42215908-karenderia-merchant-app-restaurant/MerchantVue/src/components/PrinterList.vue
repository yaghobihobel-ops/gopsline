<template>
  <q-dialog
    v-model="dialog"
    position="bottom"
    @before-show="beforeShow"
    @before-hide="beforeHide"
    persistent
  >
    <q-card class="rounded-borders-top">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-darkx text-weight-bold"
          style="overflow: inherit"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
        >
          {{ $t("Printers") }}
        </q-toolbar-title>
        <q-space></q-space>
        <div class="q-gutter-x-sm">
          <q-btn
            unelevated
            round
            dense
            icon="las la-redo-alt"
            color="red-1"
            text-color="red-9"
            flat
            @click="fetchPrinter"
            :disable="loading"
          />
          <q-btn
            @click="dialog = !true"
            icon="las la-times"
            color="grey"
            flat
            round
            dense
            v-close-popup
          />
        </div>
      </q-toolbar>

      <q-card-section style="min-height: 50vh">
        <LoadingData v-if="loading"></LoadingData>
        <NoData
          v-if="!hasItems && !loading"
          :isCenter="false"
          :message="this.$t('No available printers')"
        />
        <q-list v-else separator>
          <template v-for="items in data" :key="items">
            <q-item
              clickable
              v-ripple:purple
              @click="this.$emit('afterSelectprinter', items)"
            >
              <q-item-section>{{ items.printer_name }}</q-item-section>
            </q-item>
          </template>
        </q-list>
        <q-space class="q-pa-lg"></q-space>
        <q-space class="q-pa-xs"></q-space>
      </q-card-section>

      <q-card-actions class="row" v-if="!loading && hasItems">
        <q-btn
          unelevated
          no-caps
          color="disabled"
          text-color="disabled"
          class="radius10 col"
          size="lg"
          v-close-popup
        >
          <div class="text-weight-bold text-subtitle2">
            {{ $t("Cancel") }}
          </div>
        </q-btn>
        <q-btn
          unelevated
          no-caps
          color="amber-6"
          text-color="disabled"
          class="radius10 col"
          size="lg"
          to="/settings/add-printer"
        >
          <div class="text-weight-bold text-subtitle2">
            {{ $t("New Printer") }}
          </div>
        </q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "src/stores/DataStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "PrinterList",
  components: {
    NoData: defineAsyncComponent(() => import("components/NoData.vue")),
    LoadingData: defineAsyncComponent(() =>
      import("components/LoadingData.vue")
    ),
  },
  data() {
    return {
      dialog: false,
      data: [],
      loading: false,
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  computed: {
    hasItems() {
      if (!this.data) {
        return false;
      }
      return this.data.length > 0;
    },
  },
  methods: {
    beforeHide() {
      this.DataStore.dataList.printerAvailable = {
        data: this.data,
      };
    },
    async beforeShow() {
      if (this.DataStore.dataList?.printerAvailable) {
        this.data = this.DataStore.dataList?.printerAvailable.data;
      } else {
        this.fetchPrinter();
      }
    },
    async fetchPrinter() {
      try {
        this.loading = true;
        const response = await APIinterface.fetchDataByTokenPost(
          "PrintersList"
        );
        this.data = response.details.data;
      } catch (error) {
        this.data = [];
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>
