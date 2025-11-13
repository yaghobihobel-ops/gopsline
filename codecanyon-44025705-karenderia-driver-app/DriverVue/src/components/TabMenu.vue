<template>
  <!-- <q-footer bordered class="bg-white text-dark"> -->
  <q-tabs
    v-model="tab"
    dense
    indicator-color="transparent"
    active-color="primary"
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'text-dark': !$q.dark.mode,
    }"
    align="justify"
  >
    <q-route-tab
      name="status"
      icon="las la-check"
      :label="$t('Status')"
      no-caps
      to="/home"
    />
    <q-route-tab
      name="deliveries"
      icon="las la-biking"
      :label="$t('Deliveries')"
      no-caps
      to="/home/deliveries"
      class="routertab_small"
    >
      <template v-if="DriverappStore.getBalance">
        <q-badge color="red" floating>
          {{ DriverappStore.getBalance }}
        </q-badge>
      </template>
    </q-route-tab>
    <q-route-tab
      name="map"
      icon="las la-map-marked"
      :label="$t('Maps')"
      no-caps
      to="/home/maps"
      class="routertab_small"
    />
    <q-route-tab
      name="history"
      icon="las la-history"
      :label="$t('History')"
      no-caps
      to="/home/history"
      class="routertab_small"
    />
    <q-route-tab
      name="wallet"
      icon="las la-wallet"
      :label="$t('Wallet')"
      no-caps
      to="/home/wallet"
      class="routertab_small"
    />
  </q-tabs>
  <!-- </q-footer> -->
</template>

<script>
import { useDriverappStore } from "stores/DriverappStore";
export default {
  name: "TabMenu",
  setup() {
    const DriverappStore = useDriverappStore();
    return { DriverappStore };
  },
  data() {
    return {
      tab: "status",
    };
  },
};
</script>
