<template>
  <div class="flex q-mb-sm">
    <div class="col">
      <q-form @submit="onSearchSubmit">
        <q-input
          v-model="q"
          :placeholder="$t('Search reference #')"
          dense
          :bg-color="$q.dark.mode ? 'dark' : 'custom-grey1'"
          autocorrect="off"
          autocapitalize="off"
          autocomplete="off"
          spellcheck="false"
          class="no-border"
          rounded
          outlined
          clearable
          @clear="$emit('clearFilter')"
          :loading="q ? KitchenStore.order_loading : false"
        >
          <template v-slot:prepend>
            <q-icon name="eva-search-outline" />
          </template>
        </q-input>
      </q-form>
    </div>
    <div class="q-pl-sm q-pr-sm">
      <q-btn
        icon="eva-options-2-outline"
        flat
        class="q-pa-none"
        :color="$q.dark.mode ? 'grey300' : 'dark'"
        @click="this.modal = true"
      />
    </div>
  </div>

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

        <FilterSelect
          ref="ref_status"
          :data="KitchenStore.getKitchenStatusList"
          :label="$t('Status')"
          @after-select="afterSelectStatus"
        ></FilterSelect>

        <q-btn
          no-caps
          unelevated
          color="primary"
          class="fit radius-10"
          :label="$t('Apply Filters')"
          @click="applyFilters"
          :size="$q.screen.gt.sm ? '17px' : '15px'"
          :loading="KitchenStore.order_loading"
        >
        </q-btn>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useKitchenStore } from "stores/KitchenStore";
import { useIdentityStore } from "stores/IdentityStore";
import { useSettingStore } from "stores/SettingStore";

export default {
  name: "FilterOrder",
  components: {
    FilterSelect: defineAsyncComponent(() =>
      import("components/FilterSelect.vue")
    ),
  },
  data() {
    return {
      q: "",
      modal: false,
    };
  },
  setup() {
    const KitchenStore = useKitchenStore();
    const IdentityStore = useIdentityStore();
    const SettingStore = useSettingStore();
    return { KitchenStore, IdentityStore, SettingStore };
  },
  methods: {
    afterSelectOrderType(value) {
      this.$emit("afterSeletordertype", value);
    },
    afterSelectStatus(value) {
      this.$emit("afterSelectstatus", value);
    },
    onSearchSubmit() {
      this.modal = false;
      this.$emit("afterSearchsubmit", this.q);
    },
    applyFilters() {
      this.modal = false;
      this.$emit("applyFilters");
    },
  },
};
</script>
