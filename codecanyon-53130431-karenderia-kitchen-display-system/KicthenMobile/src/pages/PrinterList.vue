<template>
  <q-header
    reveal
    reveal-offset="10"
    :class="{
      'bg-custom-grey text-dark': !$q.dark.mode,
      'bg-grey600 text-grey300': $q.dark.mode,
    }"
  >
    <q-toolbar style="border-bottom-right-radius: 25px">
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="eva-arrow-ios-back-outline"
      />
      <q-toolbar-title style="font-size: 14px">{{
        $t("Printers")
      }}</q-toolbar-title>
    </q-toolbar>
  </q-header>
  <q-page padding>
    <q-list separator>
      <template v-for="items in KitchenStore.getPrinters" :key="items">
        <q-item
          clickable
          :to="{
            path: 'printer-edit',
            query: { id: items.printer_id },
          }"
        >
          <q-item-section avatar>
            <q-avatar
              color="grey-3"
              text-color="grey"
              icon="eva-printer-outline"
            />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ items.printer_name }}</q-item-label>
            <q-item-label caption>
              {{ items.paper_width }}
            </q-item-label>
          </q-item-section>
          <q-item-section side v-if="items.auto_print">
            <q-item-label caption>{{ $t("Auto Print") }}</q-item-label>
          </q-item-section>
        </q-item>
      </template>
    </q-list>

    <q-page-sticky position="bottom-right" :offset="[18, 18]">
      <q-btn
        to="/settings-mobile/printer-add"
        fab
        color="primary"
        icon="eva-plus-outline"
        no-caps
        padding="10px"
      />
    </q-page-sticky>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useKitchenStore } from "stores/KitchenStore";
import { defineAsyncComponent } from "vue";

export default {
  name: "PrinterList",
  components: {},
  setup() {
    const KitchenStore = useKitchenStore();
    return { KitchenStore };
  },
  mounted() {
    if (!this.KitchenStore.printer_data) {
      this.KitchenStore.PrinterList();
    }
  },
};
</script>
