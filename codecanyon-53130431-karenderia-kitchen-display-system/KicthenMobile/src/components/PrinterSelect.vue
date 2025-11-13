<template>
  <q-dialog
    v-model="modal"
    :position="this.$q.screen.lt.sm ? 'bottom' : 'standard'"
    persistent
  >
    <q-card style="min-width: 300px">
      <q-card-section>
        <div class="flex items-center q-gutter-x-sm justify-betweenx">
          <div v-if="KitchenStore.printer_loading">
            <q-circular-progress
              indeterminate
              size="30px"
              :thickness="0.22"
              rounded
              color="primary"
              track-color="grey-3"
            />
          </div>
          <div>
            <div class="text-h6 text-dark">{{ $t("Select Printers") }}</div>
            <div class="text-body2" v-if="KitchenStore.printer_loading">
              {{ $t("Loading") }}....
            </div>
          </div>
          <div v-if="!KitchenStore.printer_loading">
            <q-btn
              no-caps
              unelevated
              flat
              icon="eva-refresh-outline"
              color="blue-15"
              @click="refreshPrinterList"
            ></q-btn>
          </div>
        </div>
      </q-card-section>
      <q-list separator>
        <template v-for="items in KitchenStore.printer_data" :key="items">
          <q-item clickable @click="doPrint(items)">
            <q-item-label>
              {{ items.printer_name }}
            </q-item-label>
          </q-item>
        </template>
      </q-list>
      <q-separator></q-separator>
      <q-card-actions align="right">
        <q-btn
          flat
          :label="$t('Cancel')"
          color="primary"
          no-caps
          v-close-popup
          :size="$q.screen.gt.sm ? 'xl' : 'lg'"
        />
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import { useKitchenStore } from "stores/KitchenStore";
export default {
  name: "PrinterSelect",
  data() {
    return {
      modal: false,
    };
  },
  setup() {
    const KitchenStore = useKitchenStore();
    return { KitchenStore };
  },
  mounted() {
    this.KitchenStore.PrinterList();
  },
  methods: {
    refreshPrinterList() {
      this.KitchenStore.printer_data = null;
      this.KitchenStore.PrinterList();
    },
    doPrint(data) {
      this.modal = false;
      this.$emit("afterChooseprinter", data);
    },
  },
};
</script>
