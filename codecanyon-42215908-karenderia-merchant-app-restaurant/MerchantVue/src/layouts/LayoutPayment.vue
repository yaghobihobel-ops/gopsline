<template>
  <q-layout view="lHh Lpr lFf">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
      reveal
      reveal-offset="10"
    >
      <q-toolbar>
        <q-toggle
          v-model="online"
          color="primary"
          :label="$t('Online')"
          @update:model-value="setOnline"
        />
        <q-toolbar-title></q-toolbar-title>
        <template v-if="path == '/pos/create'">
          <q-btn
            round
            color="grey"
            icon="search"
            flat
            @click="searchPage"
            class="q-mr-sm"
          />

          <q-circular-progress
            rounded
            :value="61"
            size="18px"
            color="primary"
            indeterminate
            v-if="CartStore.cart_loading"
          />
          <q-btn
            v-else
            dense
            color="purple"
            round
            icon="las la-shopping-cart"
            unelevated
            @click="CartStore.cart_drawer = !CartStore.cart_drawer"
          >
            <template v-if="CartStore.hasData">
              <q-badge color="red" rounded floating>
                {{ CartStore.getCartCount }}
              </q-badge>
            </template>
          </q-btn>
        </template>
        <template v-else>
          <NotiButton sound_id="notify_payment"></NotiButton>
          <q-btn round color="grey" icon="search" flat @click="searchPage" />
        </template>
      </q-toolbar>
    </q-header>

    <!-- :width="220" -->
    <q-drawer
      v-model="CartStore.cart_drawer"
      side="right"
      overlay
      behavior="mobile"
      :width="250"
      dark
    >
      <PosCart ref="cart"></PosCart>
    </q-drawer>

    <q-footer bordered class="bg-white text-dark modified-footer">
      <q-tabs
        v-model="tab"
        dense
        indicator-color="transparent"
        active-color="secondary"
        :class="{
          'bg-mydark text-white': $q.dark.mode,
          'text-dark': !$q.dark.mode,
        }"
      >
        <q-route-tab
          name="home"
          icon="las la-home"
          :label="$t('Home')"
          no-caps
          to="/dashboard"
          class="routertab_small"
        />
        <q-route-tab
          name="payment_list"
          icon="o_payments"
          :label="$t('All Payment')"
          no-caps
          to="/payment/payment_list"
          class="routertab_small"
        />
        <q-route-tab
          name="bank_deposit"
          icon="o_account_balance"
          :label="$t('Bank Deposit')"
          no-caps
          to="/payment/bank_deposit"
          class="routertab_small"
        />
      </q-tabs>
    </q-footer>

    <q-page-container
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
    >
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
import { defineComponent, defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";
import { useSearchStore } from "stores/SearchStore";
import { useCartStore } from "stores/CartStore";

export default defineComponent({
  name: "LayoutPromo",
  components: {
    NotiButton: defineAsyncComponent(() => import("components/NotiButton.vue")),
    PosCart: defineAsyncComponent(() => import("components/PosCart.vue")),
  },
  setup() {
    const DataStore = useDataStore();
    const SearchStore = useSearchStore();
    const CartStore = useCartStore();
    return { DataStore, SearchStore, CartStore };
  },
  data() {
    return {
      online: true,
      tab: "home",
      loading: false,
      path: "",
      id: null,
    };
  },
  mounted() {
    this.id = this.$route.query.id;
  },
  created() {
    this.$q.dark.set(this.DataStore.dark_mode);
    this.path = this.$route.path;
  },
  updated() {
    this.path = this.$route.path;
  },
  methods: {
    searchPage() {
      console.log(this.$route.path);
      switch (this.$route.path) {
        case "/pos/on-hold":
          this.$router.push("/pos-order/search-on-hold");
          break;
        case "/pos/list":
          this.$router.push("/search");
          break;
        default:
          this.DataStore.search_item = "";
          this.$router.push("/search/food");
          break;
      }
    },
    setOnline() {
      let offline_title = !this.online
        ? "Confirm Going Offline"
        : "Confirm Going Online";

      let offline_message = !this.online
        ? this.$t(
            "Are you sure you want to take your business offline temporarily? This will prevent new orders from coming in. Your current orders will still be processed."
          )
        : this.$t(
            "Are you sure you want to take your business online and start accepting orders again?"
          );

      this.$q
        .dialog({
          title: this.$t(offline_title),
          message: offline_message,
          cancel: true,
          persistent: true,
          ok: {
            color: "dark",
            flat: true,
            "no-caps": true,
            label: this.$t("Confirm"),
          },
          cancel: {
            color: "primary",
            flat: true,
            "no-caps": true,
            label: this.$t("Cancel"),
          },
        })
        .onOk(() => {
          this.DataStore.setStoreAvailable(this.online);
        })
        .onCancel(() => {
          this.online = !this.online;
        })
        .onDismiss(() => {
          //
        });
    },
  },
});
</script>
