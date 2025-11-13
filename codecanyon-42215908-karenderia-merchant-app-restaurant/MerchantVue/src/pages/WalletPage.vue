<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page>
      <q-header v-if="isScrolled" class="bg-white text-dark beautiful-shadow">
        <q-toolbar class="q-pl-md">
          <q-toolbar-title>{{ $t("Wallet") }}</q-toolbar-title>
          <q-space></q-space>
          <q-btn
            round
            unelevated
            color="blue-grey-1"
            text-color="blue-grey-8"
            icon="o_account_balance"
            @click="this.$refs.set_account.dialog = true"
            dense
          ></q-btn>
        </q-toolbar>
      </q-header>
      <q-scroll-observer @scroll="onScroll" scroll-target="body" />

      <div
        class="relative-position"
        style="
          height: 20vh;
          background: linear-gradient(135deg, #ff724c 70%, #e85e38 30%);
        "
      >
        <div class="absolute-bottom full-width q-pa-md q-pl-lg">
          <div class="flex items-end justify-between">
            <div class="borderx">
              <div class="text-body2 text-white text-weight-medium">
                {{ $t("Total Balance") }}
              </div>
              <div class="text-h5 text-weight-bold text-white">
                <template v-if="loading_balance">
                  <q-spinner-ios size="sm" />
                </template>
                <template v-else>
                  {{ balance?.balance ?? "0.00" }}
                </template>
              </div>
            </div>
            <div>
              <q-btn
                icon="o_account_balance"
                round
                color="blue-grey-1"
                text-color="dark"
                unelevated
                dense
                @click="this.$refs.set_account.dialog = true"
              >
              </q-btn>
            </div>
          </div>
        </div>
      </div>

      <div class="q-pa-md">
        <div class="row q-gutter-x-sm">
          <div class="col">
            <q-btn
              no-caps
              unelevated
              class="radius10 fit"
              color="amber-6"
              text-color="dark"
              padding="12px"
            >
              <q-icon name="navigation" size="1em"></q-icon>
              <div class="q-ml-sm text-weight-medium text-body2">
                {{ $t("Cash In") }}
              </div>
            </q-btn>
          </div>
          <div class="col">
            <q-btn
              no-caps
              unelevated
              class="radius10 fit"
              color="primary"
              text-color="white"
              @click="showRequestPayout"
            >
              <q-icon name="navigation" size="1em" class="rotate-180"></q-icon>
              <div class="q-ml-sm text-weight-medium text-body2">
                {{ $t("Request Payout") }}
              </div>
            </q-btn>
          </div>
        </div>
      </div>

      <div class="bg-grey-1 q-pl-md q-pr-md">
        <q-tabs
          v-model="tab"
          @update:model-value="resetPagination()"
          dense
          active-color="primary"
          active-class="active-tabs"
          indicator-color="primary"
          align="left"
          no-caps
          mobile-arrows
          class="text-disabled q-mb-md q-pt-md"
          :breakpoint="0"
        >
          <q-tab
            name="wallet"
            :label="$t('Transactions')"
            active-class="active-tabs"
            no-caps
          >
          </q-tab>
          <q-tab
            name="withdrawals"
            :label="$t('Withdrawals')"
            active-class="active-tabs"
            no-caps
          >
          </q-tab>
        </q-tabs>

        <q-list>
          <q-virtual-scroll
            class="fit"
            separator
            :items="data"
            :virtual-scroll-item-size="48"
            v-slot="{ item: items }"
          >
            <q-item class="box-shadow0 q-mb-md bg-white">
              <q-item-section avatar top>
                <q-item-label>
                  {{ items.transaction_description }}</q-item-label
                >
                <q-item-label class="text-caption text-grey-5">{{
                  items.transaction_date
                }}</q-item-label>
              </q-item-section>
              <q-item-section></q-item-section>
              <q-item-section side top>
                <q-item-label class="text-weight-bold">{{
                  items.transaction_amount
                }}</q-item-label>
              </q-item-section>
            </q-item>
          </q-virtual-scroll>
        </q-list>
      </div>

      <q-infinite-scroll
        ref="nscroll"
        @load="transactionHistory"
        :offset="250"
        :disable="scroll_disabled"
      >
        <template v-slot:default>
          <NoData
            v-if="!hasItems && !loading"
            :isCenter="false"
            message="No transactions yet."
          />
        </template>
        <template v-slot:loading>
          <LoadingData :page="page"></LoadingData>
        </template>
      </q-infinite-scroll>

      <RequestPayout
        ref="request_payout"
        @after-payout="refreshAll"
      ></RequestPayout>

      <SetAccount
        ref="set_account"
        @after-setaccount="afterSetaccount"
      ></SetAccount>

      <q-space class="q-pa-md"></q-space>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";
import { useDataStore } from "src/stores/DataStore";

export default {
  name: "WalletPage",
  components: {
    RequestPayout: defineAsyncComponent(() =>
      import("components/RequestPayout.vue")
    ),
    SetAccount: defineAsyncComponent(() => import("components/SetAccount.vue")),
    LoadingData: defineAsyncComponent(() =>
      import("components/LoadingData.vue")
    ),
    NoData: defineAsyncComponent(() => import("components/NoData.vue")),
  },
  data() {
    return {
      tab: "wallet",
      isScrolled: false,
      loading_balance: false,
      loading: false,
      balance: null,
      page: 1,
      scroll_disabled: true,
      hasMore: true,
      data: [],
    };
  },
  setup() {
    const DataStore = useDataStore();
    return {
      DataStore,
    };
  },
  computed: {
    hasItems() {
      return this.data.length > 0;
    },
  },
  mounted() {
    if (this.DataStore.dataList?.wallet_data) {
      this.page = this.DataStore.dataList?.wallet_data?.page;
      this.hasMore = this.DataStore.dataList?.wallet_data?.hasMore;
      this.tab = this.DataStore.dataList?.wallet_data?.tab;
      this.data = this.DataStore.dataList?.wallet_data?.data;
      this.balance = this.DataStore.dataList?.wallet_data?.balance;
    } else {
      this.getMerchantBalance();
    }
    this.scroll_disabled = false;
  },
  beforeUnmount() {
    this.DataStore.dataList.wallet_data = {
      tab: this.tab,
      page: this.page,
      hasMore: this.hasMore,
      balance: this.balance,
      data: this.data,
    };
  },
  methods: {
    refresh(done) {
      setTimeout(() => {
        done();
      }, 100);
      this.refreshAll();
    },
    refreshAll() {
      this.resetPagination();
      setTimeout(() => {
        this.getMerchantBalance();
      }, 100);
    },
    showRequestPayout() {
      this.$refs.request_payout.dialog = true;
    },
    afterSetaccount() {
      this.$refs.request_payout.getPayoutAccount();
    },
    async getMerchantBalance() {
      try {
        this.loading_balance = true;
        const response = await APIinterface.fetchGet("getMerchantBalance");
        this.balance = response.details;
      } catch (error) {
        this.balance = null;
      } finally {
        this.loading_balance = false;
      }
    },
    async transactionHistory(index, done) {
      try {
        if (this.loading) {
          return;
        }

        if (!this.hasMore) {
          this.scroll_disabled = true;
          done(true);
          return;
        }
        this.loading = true;

        const params = new URLSearchParams({
          page: this.page,
        }).toString();

        const method =
          this.tab == "wallet" ? "transactionHistory" : "withdrawalsHistory";

        const response = await APIinterface.fetchGet(`${method}?${params}`);
        console.log("response", response);
        this.page++;
        this.data = [...this.data, ...response.details.data];

        if (response.details?.is_last_page) {
          this.hasMore = false;
          this.scroll_disabled = true;
          done(true);
          return;
        }
        done();
      } catch (error) {
        console.log("error", error);
        done(true);
      } finally {
        this.loading = false;
      }
    },
    onScroll(info) {
      if (!info) {
        return;
      }
      this.isScrolled = info.position.top > 20;
    },
    resetPagination() {
      this.page = 1;
      this.data = [];
      this.hasMore = true;
      this.scroll_disabled = false;
      this.$nextTick(() => {
        this.$refs.nscroll?.resume?.();
        this.$refs.nscroll?.trigger?.();
      });
    },
  },
};
</script>
