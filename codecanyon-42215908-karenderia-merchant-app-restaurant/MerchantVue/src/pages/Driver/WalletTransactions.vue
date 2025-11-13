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
        <q-toolbar-title class="text-weight-bold">
          {{ $t("Wallet History") }}
        </q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
      class="q-pa-md"
    >
      <template v-if="loading_balance">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>
      <template v-else>
        <div
          class="radius8 bg-grey-1x q-pa-sm"
          :class="{
            'bg-grey600 text-white': $q.dark.mode,
            'bg-grey-1': !$q.dark.mode,
          }"
        >
          <div class="row q-gutter-sm items-center">
            <div class="col">
              <div class="text-subtitle1">{{ $t("Earnings") }}</div>
              <div class="text-caption text-grey">
                {{ $t("Your earnings transaction for all deliveries") }}
              </div>
            </div>
            <div class="col-3">
              <div class="text-caption text-grey line-normal">
                {{ $t("Total Balance") }}
              </div>
              <div class="text-subtitle1">
                <template v-if="hasBalance">
                  {{ balance_data.balance }}
                </template>
                <template v-else>0</template>
              </div>
            </div>
          </div>
        </div>
        <q-space class="q-pa-sm"></q-space>
        <q-btn
          color="green"
          :label="$t('Create a Transaction')"
          unelevated
          no-caps
          class="fit"
          icon-right="arrow_drop_down"
          size="lg"
        >
          <q-menu fit auto-close>
            <q-list>
              <q-item clickable @click="showAdjustmentForm">
                <q-item-section>{{ $t("Adjustment") }}</q-item-section>
              </q-item>
              <q-separator></q-separator>
              <q-item clickable @click="confirmDelete" :disable="!hasData">
                <q-item-section>{{
                  $t("Clear wallet transactions")
                }}</q-item-section>
              </q-item>
            </q-list>
          </q-menu>
        </q-btn>

        <q-space class="q-pa-sm"></q-space>

        <q-infinite-scroll ref="nscroll" @load="List">
          <template v-slot:default>
            <q-list separator>
              <template v-for="items in data" :key="items">
                <q-item v-for="item in items" :key="item">
                  <q-item-section>
                    <q-item-label caption>{{
                      item.transaction_date
                    }}</q-item-label>
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
            </q-list>
          </template>
          <template v-slot:loading>
            <TableSkeleton v-if="page <= 0" :rows="10"></TableSkeleton>
            <TableSkeleton
              v-else-if="data.length > 1"
              :rows="1"
            ></TableSkeleton>
          </template>
        </q-infinite-scroll>

        <template v-if="!hasData && !loading">
          <div
            class="full-width text-center flex flex-center"
            style="min-height: calc(50vh)"
          >
            <p class="text-grey q-ma-none">{{ $t("No available data") }}</p>
          </div>
        </template>

        <DriverWalletAdjustment
          ref="adjustment"
          :id="id"
          @after-adjustment="afterAdjustment"
        ></DriverWalletAdjustment>
      </template>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";

export default {
  name: "WalletTransactions",
  components: {
    DriverWalletAdjustment: defineAsyncComponent(() =>
      import("components/DriverWalletAdjustment.vue")
    ),
    TableSkeleton: defineAsyncComponent(() =>
      import("components/TableSkeleton.vue")
    ),
  },
  data() {
    return {
      loading: false,
      loading_balance: true,
      id: "",
      balance_data: [],
      data: [],
      page: 0,
      is_refresh: undefined,
    };
  },
  computed: {
    hasBalance() {
      if (Object.keys(this.balance_data).length > 0) {
        return true;
      }
      return false;
    },
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  created() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.driverWalletBalance();
    }
  },
  methods: {
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
      this.is_refresh = done;
      this.driverWalletBalance();
      this.resetPagination();
    },
    afterAdjustment() {
      this.driverWalletBalance();
      this.resetPagination();
    },
    List(index, done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "driverWalletTransactions",
        "&page=" + index + "&id=" + this.id
      )
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
    showAdjustmentForm() {
      this.$refs.adjustment.dialog = true;
    },
    driverWalletBalance() {
      if (APIinterface.empty(this.is_refresh)) {
        this.loading_balance = true;
      }
      APIinterface.fetchDataByTokenPost("driverWalletBalance", "id=" + this.id)
        .then((data) => {
          this.balance_data = data.details;
        })
        .catch((error) => {
          //
        })
        .then((data) => {
          this.loading_balance = false;
          if (!APIinterface.empty(this.is_refresh)) {
            this.is_refresh();
          }
        });
    },
    confirmDelete() {
      APIinterface.dialog(
        this.$t("Clear wallet transactions"),
        this.$t(
          "Are you sure you want to permanently delete all transactions"
        ) + "?",
        this.$t("Okay"),
        this.$t("Cancel"),
        this.$q
      )
        .then((result) => {
          this.clearDriverWallet();
        })
        .catch((error) => {});
    },
    clearDriverWallet() {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost("clearDriverWallet", "id=" + this.id)
        .then((data) => {
          this.afterAdjustment();
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.$q.loading.hide();
        });
    },
  },
};
</script>
