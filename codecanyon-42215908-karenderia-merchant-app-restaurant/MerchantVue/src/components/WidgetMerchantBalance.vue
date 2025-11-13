<template>
  <template v-if="DriverStore.loading_balance">
    <q-circular-progress indeterminate rounded size="20px" color="primary" />
  </template>
  <template v-else>
    {{ DriverStore.getMerchantBalance.balance }}
  </template>
</template>

<script>
import { useDriverStore } from "stores/DriverStore";

export default {
  name: "WidgetMerchantBalance",
  setup() {
    const DriverStore = useDriverStore();
    return { DriverStore };
  },
  mounted() {
    this.getBalance();
  },
  methods: {
    getBalance() {
      this.DriverStore.MerchantBalance();
    },
  },
};
</script>
