<template>
  <q-select
    v-model="selected_data"
    :options="data"
    :label="label"
    multiple
    emit-value
    map-options
    dense
    outlined
    ref="ref_select"
    @update:model-value="toggleOption"
  >
    <template v-slot:option="{ itemProps, opt, selected, toggleOption }">
      <q-item v-bind="itemProps">
        <q-item-section avatar>
          <q-checkbox
            :model-value="selected"
            @update:model-value="toggleOption(opt)"
          ></q-checkbox>
        </q-item-section>
        <q-item-section>
          <q-item-label>
            {{ opt.label }}
          </q-item-label>
        </q-item-section>
      </q-item>
    </template>
    <template v-slot:after-options>
      <div class="q-pa-md">
        <q-btn
          :label="$t('Done')"
          unelevated
          no-caps
          color="primary"
          class="fit"
          @click="lostFocus"
        ></q-btn>
      </div>
    </template>
  </q-select>
</template>

<script>
import { useKitchenStore } from "stores/KitchenStore";

export default {
  name: "FilterSelect",
  props: ["data", "label"],
  data() {
    return {
      selected_data: [],
    };
  },
  setup() {
    const KitchenStore = useKitchenStore();
    return { KitchenStore };
  },
  methods: {
    lostFocus() {
      this.$refs.ref_select.hidePopup();
    },
    toggleOption(value) {
      this.$emit("afterSelect", value);
    },
  },
};
</script>
