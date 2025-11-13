<template>
  <q-layout view="lHh Lpr lFf">
    <q-footer class="bg-white text-dark shadow-1">
      <q-tabs
        v-model="tab"
        dense
        indicator-color="transparent"
        active-color="primary"
        align="justify"
      >
        <q-route-tab
          name="home"
          icon="eva-home-outline"
          :label="$t('Home')"
          no-caps
          to="/home"
        />
        <q-route-tab
          name="browse"
          icon="o_local_offer"
          :label="$t('Offers')"
          no-caps
          :to="search_mode == '' ? '/home/offers' : '/home/offers-location'"
        />
        <q-route-tab
          name="cart"
          icon="eva-shopping-cart-outline"
          :label="$t('Cart')"
          no-caps
          to="/cart"
        >
          <q-badge v-if="CartStore.hasItem" color="red" floating rounded>
            {{ CartStore.getCartCount }}
          </q-badge>
        </q-route-tab>

        <q-route-tab
          name="orders"
          icon="list_alt"
          :label="$t('Orders')"
          no-caps
          to="/home/orders"
        />

        <q-route-tab
          name="account"
          icon="eva-person-outline"
          :label="$t('Account')"
          no-caps
          to="/account-menu"
        />
      </q-tabs>
    </q-footer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
import { defineComponent } from "vue";
import { useCartStore } from "stores/CartStore";
import { useDataStore } from "stores/DataStore";

export default defineComponent({
  name: "MainLayout",
  setup() {
    const CartStore = useCartStore();
    const DataStore = useDataStore();
    return {
      CartStore,
      DataStore,
    };
  },
  data() {
    return {
      tab: "home",
      search_mode: null,
    };
  },
  async mounted() {
    this.search_mode = this.DataStore.getSearchMode;
    if (!this.CartStore.hasItem) {
      try {
        await this.CartStore.getCart(true, null);
      } catch (error) {}
    }
  },
});
</script>
