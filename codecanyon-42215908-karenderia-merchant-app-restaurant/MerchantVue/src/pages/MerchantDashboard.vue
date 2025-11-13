<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-header
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
    >
      <q-toolbar>
        <q-btn
          @click="$router.back()"
          flat
          round
          dense
          icon="las la-angle-left"
          :color="$q.dark.mode ? 'white' : 'dark'"
        />
        <q-toolbar-title class="text-weight-bold">{{
          $t("Merchant")
        }}</q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page class="q-pa-md">
      <template v-if="DataStore.loading_dashboard">
        <q-skeleton height="75px" square class="radius8" />
        <div class="row justify-center q-gutter-sm q-mb-sm font12">
          <div><q-skeleton type="text" style="width: 50px" /></div>
          <div><q-skeleton type="text" style="width: 50px" /></div>
        </div>
      </template>

      <template v-else>
        <div
          class="text-dark q-pa-sm radius8"
          :class="{
            'bg-grey600 text-white': $q.dark.mode,
            'bg-orange-1 text-dark': !$q.dark.mode,
          }"
        >
          <div class="row items-center">
            <div class="col">
              <div class="font12">{{ $t("Earnings") }}</div>
              <div class="font11">
                {{ $t("Your sales, cash in and referral earnings") }}
              </div>
              <div class="text-weight-bold">
                {{ DataStore.merchant_dashboard_data.balance }}
              </div>
            </div>
            <q-btn
              no-caps
              unelevated
              flat
              size="sm"
              :color="$q.dark.mode ? 'grey300' : 'blue'"
              class="items-center q-pa-none"
              :label="$t('Request Payout')"
              @click="showRequestPayout"
            >
            </q-btn>
          </div>
        </div>
        <div
          class="row justify-center q-gutter-sm q-mb-sm font12"
          :class="{
            'text-grey300': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
        >
          <div>
            <span class="text-weight-bold">{{
              DataStore.merchant_dashboard_data.total_food_orders
            }}</span>
            {{ $t("food orders") }}
          </div>
          <div>|</div>
          <div>
            <span class="text-weight-bold">{{
              DataStore.merchant_dashboard_data.total_payments
            }}</span>
            {{ $t("Payments") }}
          </div>
        </div>
      </template>

      <q-space class="q-pa-sm"></q-space>

      <template v-if="DataStore.loading_dashboard">
        <div class="row items-center q-gutter-sm justify-centerx">
          <div v-for="items in 5" :key="items" class="col-3 text-center">
            <q-skeleton type="QAvatar" />
          </div>
        </div>
      </template>

      <div v-else class="row items-center q-gutter-sm justify-centerx">
        <div class="col-3 text-center">
          <q-btn
            outline
            round
            color="orange-1"
            text-color="orange"
            icon="las la-warehouse"
            to="/restaurant/information"
          />
          <div
            class="font11"
            :class="{
              'text-grey300': $q.dark.mode,
              'text-dark': !$q.dark.mode,
            }"
          >
            {{ $t("Information") }}
          </div>
        </div>
        <div class="col-3 text-center">
          <q-btn
            outline
            round
            color="orange-1"
            text-color="orange"
            icon="las la-map-marker"
            to="/restaurant/address"
          />
          <div
            class="font11"
            :class="{
              'text-grey300': $q.dark.mode,
              'text-dark': !$q.dark.mode,
            }"
          >
            {{ $t("Address") }}
          </div>
        </div>
        <div class="col-3 text-center">
          <q-btn
            outline
            round
            color="orange-1"
            text-color="orange"
            icon="las la-cog"
            to="/restaurant/settings"
          />
          <div
            class="font11"
            :class="{
              'text-grey300': $q.dark.mode,
              'text-dark': !$q.dark.mode,
            }"
          >
            {{ $t("Settings") }}
          </div>
        </div>
        <div class="col-3 text-center">
          <q-btn
            outline
            round
            color="orange-1"
            text-color="orange"
            icon="las la-clock"
            to="/restaurant/store-hours"
          />
          <div
            class="font11"
            :class="{
              'text-grey300': $q.dark.mode,
              'text-dark': !$q.dark.mode,
            }"
          >
            {{ $t("Store Hours") }}
          </div>
        </div>
        <div class="col-3 text-center">
          <q-btn
            outline
            round
            color="orange-1"
            text-color="orange"
            icon="las la-university"
            @click="showSetAccount"
          />
          <div
            class="font11"
            :class="{
              'text-grey300': $q.dark.mode,
              'text-dark': !$q.dark.mode,
            }"
          >
            {{ $t("Set Payout") }}
          </div>
        </div>
      </div>

      <q-space class="q-pa-sm"></q-space>

      <q-tabs
        v-model="tab"
        dense
        no-caps
        active-color="primary"
        :indicator-color="$q.dark.mode ? 'mydark' : 'white'"
        align="justify"
        narrow-indicator
        shrink
        switch-indicator="false"
        class="text-grey"
      >
        <q-tab
          v-for="items in tab_menu"
          :key="items"
          :name="items.value"
          no-caps
          class="no-wrap q-pa-none"
        >
          <q-btn
            :label="items.label"
            unelevated
            no-caps
            :color="
              tab == items.value
                ? 'primary'
                : $q.dark.mode
                ? 'grey600'
                : 'mygrey'
            "
            :text-color="
              tab == items.value ? 'white' : $q.dark.mode ? 'grey300' : 'dark'
            "
            class="radius28 q-mr-sm"
          ></q-btn>
        </q-tab>
      </q-tabs>

      <q-space class="q-pa-xs"></q-space>

      <q-tab-panels
        v-model="tab"
        animated
        transition-prev="fade"
        transition-next="fade"
      >
        <template v-for="items in tab_menu" :key="items">
          <q-tab-panel :name="items.value" class="q-pa-none">
            <template v-if="items.value == 'transaction_history'">
              <!-- TRANSACTION HISTORY -->
              <TransactionHistory
                ref="transaction_history"
              ></TransactionHistory>
              <!-- TRANSACTION HISTORY -->
            </template>
            <template v-else>
              <!-- PAYOUT HISTORY -->
              <PayoutHistory ref="payout_history"></PayoutHistory>
              <!-- PAYOUT HISTORY -->
            </template>
          </q-tab-panel>
        </template>
      </q-tab-panels>

      <SetAccount
        ref="set_account"
        @after-setaccount="afterSetaccount"
      ></SetAccount>
      <RequestPayout
        ref="request_payout"
        @after-payout="afterPayout"
      ></RequestPayout>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";

export default {
  // name: 'PageName',
  components: {
    SetAccount: defineAsyncComponent(() => import("components/SetAccount.vue")),
    RequestPayout: defineAsyncComponent(() =>
      import("components/RequestPayout.vue")
    ),
    TransactionHistory: defineAsyncComponent(() =>
      import("components/TransactionHistory.vue")
    ),
    PayoutHistory: defineAsyncComponent(() =>
      import("components/PayoutHistory.vue")
    ),
    // ListLoading: defineAsyncComponent(() => import("components/ListLoading.vue")),
    // ListNoData: defineAsyncComponent(() => import("components/ListNoData.vue")),
  },
  data() {
    return {
      loading: false,
      loading2: false,
      transaction_data: [],
      payout_data: [],
      tab: "transaction_history",
      tab_menu: [
        {
          label: this.$t("Transaction History"),
          value: "transaction_history",
        },
        {
          label: this.$t("Payout History"),
          value: "payout",
        },
      ],
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  created() {
    this.tab = this.DataStore.tab_merchant_dashboard;
    if (Object.keys(this.DataStore.merchant_dashboard_data).length <= 0) {
      this.DataStore.getMerchantDashboard();
    }

    if (Object.keys(this.DataStore.payout_settings_data).length <= 0) {
      this.DataStore.getPayoutSettings();
    }
  },
  watch: {
    tab(newval, oldval) {
      this.DataStore.tab_merchant_dashboard = newval;
    },
  },
  computed: {
    hasData() {
      if (!APIinterface.empty(this.transaction_data.data)) {
        if (Object.keys(this.transaction_data.data).length > 0) {
          return true;
        }
      }
      return false;
    },
    hasPayout() {
      if (!APIinterface.empty(this.payout_data.data)) {
        if (Object.keys(this.payout_data.data).length > 0) {
          return true;
        }
      }
      return false;
    },
  },
  methods: {
    refresh(done) {
      this.DataStore.getMerchantDashboard(done);
      console.log(this.tab);
      if (this.tab == "transaction_history") {
        this.$refs.transaction_history[0].getData();
      } else if (this.tab == "payout") {
        this.$refs.payout_history[0].getData();
      }
    },
    showSetAccount() {
      this.$refs.set_account.dialog = true;
    },
    showRequestPayout() {
      this.$refs.request_payout.dialog = true;
    },

    afterPayout() {
      console.log("afterPayout");
      this.refresh();
    },
    afterSetaccount() {
      this.DataStore.getMerchantDashboard();
    },
  },
};
</script>
