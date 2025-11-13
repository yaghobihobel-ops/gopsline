<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-grey-1 text-dark': !$q.dark.mode,
      }"
      class="q-pr-md q-pl-md"
    >
      <div
        class="radius8 bg-whitex q-pa-sm"
        :class="{
          'bg-grey600 text-white': $q.dark.mode,
          'bg-white': !$q.dark.mode,
        }"
      >
        <div class="row q-gutter-sm items-center">
          <div class="col">
            <div class="text-subtitle1">{{ $t("Payout account") }}</div>
            <template v-if="loading2">
              <q-circular-progress
                indeterminate
                rounded
                size="20px"
                color="primary"
              />
            </template>
            <div v-else class="text-caption text-grey">
              {{ data_payout.account }}
            </div>
          </div>
          <div class="col-3">
            <div class="text-caption text-grey line-normal">
              {{ $t("Available Balance") }}
            </div>
            <div class="text-subtitle1">
              <WidgetMerchantBalance ref="merchant"></WidgetMerchantBalance>
            </div>
          </div>
        </div>
      </div>

      <q-space class="q-pa-sm"></q-space>
      <q-btn
        color="green"
        :label="$t('Set Acccount')"
        unelevated
        no-caps
        class="fit"
        size="lg"
        @click="showSetAccount"
      >
      </q-btn>

      <q-space class="q-pa-sm"></q-space>

      <q-infinite-scroll ref="nscroll" @load="List">
        <template v-slot:default>
          <q-list
            separator
            class="bg-whitex"
            :class="{
              'bg-grey600 text-white': $q.dark.mode,
              'bg-white': !$q.dark.mode,
            }"
          >
            <template v-for="items in data" :key="items">
              <template v-for="item in items" :key="item">
                <q-item>
                  <q-item-section>
                    <q-item-label caption
                      >{{ item.transaction_date }}

                      <q-badge
                        :class="
                          DataStore.status_payment_color[item.status_raw]
                            ? DataStore.status_payment_color[item.status_raw]
                            : 'amber'
                        "
                        >{{ item.status }}</q-badge
                      >
                    </q-item-label>
                    <q-item-label>{{
                      item.transaction_description
                    }}</q-item-label>
                  </q-item-section>
                  <q-item-section side>
                    <q-item-label
                      class="text-right"
                      :class="{
                        'text-green': transactionClass(item.transaction_type),
                        'text-red': !transactionClass(item.transaction_type),
                      }"
                    >
                      {{ transactionSign(item.transaction_type) }}
                      {{ item.transaction_amount }}
                    </q-item-label>
                  </q-item-section>
                </q-item>
              </template>
            </template>
          </q-list>
        </template>
        <template v-slot:loading>
          <TableSkeleton v-if="page <= 0" :rows="10"></TableSkeleton>
          <TableSkeleton v-else-if="data.length > 1" :rows="1"></TableSkeleton>
        </template>
      </q-infinite-scroll>

      <template v-if="!hasData && !loading">
        <div
          class="full-width text-center flex flex-center"
          style="min-height: calc(40vh)"
        >
          <p class="text-grey q-ma-none">{{ $t("No available data") }}</p>
        </div>
      </template>

      <SetAccount
        ref="set_account"
        @after-setaccount="afterSetaccount"
      ></SetAccount>

      <q-page-scroller
        position="bottom-right"
        :scroll-offset="150"
        :offset="[18, 18]"
      >
        <q-btn
          fab
          icon="keyboard_arrow_up"
          :color="$q.dark.mode ? 'grey600' : 'mygrey'"
          :text-color="$q.dark.mode ? 'grey300' : 'dark'"
          dense
          padding="3px"
        />
      </q-page-scroller>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "WithdrawalTransaction",
  components: {
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
    WidgetMerchantBalance: defineAsyncComponent(() =>
      import("components/WidgetMerchantBalance.vue")
    ),
    SetAccount: defineAsyncComponent(() => import("components/SetAccount.vue")),
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  created() {
    this.DataStore.getPayoutSettings();
    this.getPayoutAccount();
  },
  data() {
    return {
      loading: false,
      loading2: false,
      data: [],
      page: 0,
      status: [],
      is_refresh: undefined,
      handle: undefined,
      data_payout: [],
    };
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    getPayoutAccount() {
      this.loading2 = true;
      APIinterface.fetchDataByTokenPost("getPayoutAccount")
        .then((data) => {
          this.data_payout = data.details;
        })
        .catch((error) => {
          this.data_payout = [];
        })
        .then((data) => {
          this.loading2 = false;
        });
    },
    transactionClass(data) {
      switch (data) {
        case "credit":
          return true;
          break;
        default:
          return false;
          break;
      }
    },
    transactionSign(data) {
      let $sign = "";
      switch (data) {
        case "credit":
          $sign = "+";
          break;
        default:
          $sign = "-";
          break;
      }
      return $sign;
    },
    refresh(done) {
      this.resetPagination();
      this.$refs.merchant.getBalance();
      this.getPayoutAccount();
      this.is_refresh = done;
    },
    List(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("withdrawalsHistory", "&page=" + index)
        .then((data) => {
          if (data.code == 1) {
            this.page = index;
            this.data.push(data.details.data);
          } else if (data.code == 3) {
            this.data_done = true;
            if (!APIinterface.empty(this.$refs.nscroll)) {
              this.$refs.nscroll.stop();
            }
          }
        })
        .catch((error) => {
          this.data_done = true;
          if (!APIinterface.empty(this.$refs.nscroll)) {
            this.$refs.nscroll.stop();
          }
        })
        .then((data) => {
          done();
          this.loading = false;
          if (!APIinterface.empty(this.is_refresh)) {
            this.is_refresh();
          }
        });
    },
    resetPagination() {
      this.page = 0;
      this.data = [];
      this.$refs.nscroll.reset();
      this.$refs.nscroll.resume();
      this.$refs.nscroll.trigger();
    },
    showSetAccount() {
      this.$refs.set_account.dialog = true;
    },
    afterSetaccount() {
      this.getPayoutAccount();
    },
  },
};
</script>
