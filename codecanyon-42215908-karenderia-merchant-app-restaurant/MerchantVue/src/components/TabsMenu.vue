<template>
  <q-tabs
    v-model="tab"
    active-color="primary"
    align="justify"
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'text-dark': !$q.dark.mode,
    }"
    class="q-pt-sm q-pb-xs"
    :switch-indicator="true"
    narrow-indicator
  >
    <q-route-tab name="home" no-caps to="/dashboard">
      <template v-slot:default>
        <img
          :src="tab == 'home' ? '/svg/home-solid.svg' : 'svg/home.svg'"
          width="25"
          height="25"
        />
        <span>{{ $t("Home") }}</span>
      </template>
    </q-route-tab>

    <q-route-tab
      v-if="AccessStore.hasAccess('merchant.orders')"
      name="orders"
      no-caps
      to="/orders"
    >
      <template v-slot:default>
        <img
          :src="tab == 'orders' ? '/svg/orders-solid.svg' : 'svg/orders.svg'"
          width="25"
          height="25"
        />
        <span>{{ $t("Orders") }}</span>
      </template>
    </q-route-tab>

    <q-route-tab name="cart" no-caps to="/menu">
      <template v-slot:default>
        <img
          :src="tab == 'cart' ? '/svg/menu-solid.svg' : 'svg/menu.svg'"
          width="25"
          height="25"
        />
        <span>{{ $t("Menu") }}</span>
      </template>
    </q-route-tab>

    <q-route-tab name="wallet" no-caps to="/wallet">
      <template v-slot:default>
        <img
          :src="tab == 'wallet' ? '/svg/wallet3.svg' : 'svg/wallet3-solid.svg'"
          width="25"
          height="25"
        />
        <span>{{ $t("Wallet") }}</span>
      </template>
    </q-route-tab>

    <q-route-tab name="table" no-caps to="/table">
      <template v-slot:default>
        <img
          :src="tab == 'table' ? '/svg/table-solid.svg' : 'svg/table.svg'"
          width="25"
          height="25"
        />
        <span>{{ $t("Table") }}</span>
      </template>
    </q-route-tab>
  </q-tabs>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import { useAccessStore } from "stores/AccessStore";
import auth from "src/api/auth";

export default {
  name: "TabsMenu",
  data() {
    return {
      tab: "home",
      user_data: [],
    };
  },
  created() {
    this.user_data = auth.getUser();
  },
  setup() {
    const DataStore = useDataStore();
    const AccessStore = useAccessStore();
    return { DataStore, AccessStore };
  },
};
</script>
