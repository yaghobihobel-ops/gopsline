<template>
  <q-input
    v-model="mobile_number"
    mask="##############"
    outlined
    lazy-rules
    color="grey-5"
    :rules="[
      (val) => (val && val.length > 0) || this.$t('This field is required'),
    ]"
  >
    <template v-slot:prepend>
      <q-select
        dense
        v-model="mobile_prefix"
        :options="DataStore.phone_prefix_data"
        @filter="filterFn"
        @update:model-value="selectPrefix"
        behavior="dialog"
        input-debounce="700"
        style="border: none"
        emit-value
        borderless
        class="myq-field"
      >
        <template v-slot:option="{ itemProps, opt }">
          <q-item v-bind="itemProps">
            <q-item-section avatar>
              <q-img :src="opt.flag" style="height: 15px; max-width: 20px" />
            </q-item-section>
            <q-item-section>
              <q-item-label>{{ opt.label }}</q-item-label>
            </q-item-section>
          </q-item>
        </template>
        <template v-slot:no-option>
          <q-item>
            <q-item-section class="text-grey">
              {{ $t("No results") }}
            </q-item-section>
          </q-item>
        </template>
      </q-select>
    </template>
  </q-input>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";
export default {
  name: "MobilePhone",
  props: ["prefix", "phone"],
  data() {
    return {
      mobile_number: "",
      mobile_prefix: "",
    };
  },
  watch: {
    DataStore: {
      immediate: true,
      deep: true,
      handler(newValue, oldValue) {
        if (Object.keys(newValue.phone_default_data).length > 0) {
          this.mobile_prefix = "+" + newValue.phone_default_data.phonecode;
        }
      },
    },
    mobile_number(newval, oldval) {
      this.$emit("afterInput", {
        mobile_prefix: this.mobile_prefix,
        mobile_number: this.mobile_number,
      });
    },
  },
  mounted() {
    if (!APIinterface.empty(this.phone)) {
      this.mobile_number = this.phone;
      this.mobile_prefix = this.prefix;
    }
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  methods: {
    selectPrefix() {
      this.$emit("afterInput", {
        mobile_prefix: this.mobile_prefix,
        mobile_number: this.mobile_number,
      });
    },
  },
};
</script>
