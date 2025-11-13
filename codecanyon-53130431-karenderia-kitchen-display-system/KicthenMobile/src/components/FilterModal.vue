<template>
  <q-dialog
    v-model="modal"
    :maximized="this.$q.screen.lt.sm ? true : false"
    :position="this.$q.screen.lt.sm ? 'bottom' : 'standard'"
    persistent
    full-height
    full-width
  >
    <q-card>
      <q-card-section class="row items-center q-pb-none">
        <div class="text-h6">{{ $t("Filters") }}</div>
        <q-space />
        <q-btn icon="close" flat round dense v-close-popup />
      </q-card-section>
      <q-card-section class="q-gutter-y-md">
        <template v-if="SettingStore.screen_options != 'split'">
          <FilterSelect
            ref="ref_order_type"
            :data="KitchenStore.getTransactionList"
            :label="$t('Order Type')"
            @after-select="afterSelectOrderType"
          ></FilterSelect>
        </template>

        <q-btn
          no-caps
          unelevated
          color="primary"
          class="fit radius-10"
          :label="$t('Apply Filters')"
          @click="applyFilters"
          :size="$q.screen.gt.sm ? '17px' : '15px'"
        >
        </q-btn>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
export default {
  name: "FilterModal",
  components: {
    FilterSelect: defineAsyncComponent(() =>
      import("components/FilterSelect.vue")
    ),
  },
  data() {
    return {
      modal: false,
    };
  },
  setup() {
    return {};
  },
};
</script>
