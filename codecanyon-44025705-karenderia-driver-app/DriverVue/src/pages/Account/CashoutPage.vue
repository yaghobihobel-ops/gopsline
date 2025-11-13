<template>
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
        $t("Cash out")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-pull-to-refresh @refresh="refresh">
    <q-page :class="{ 'flex flex-center': loading }">
      <template v-if="loading">
        <div
          class="flex flex-center full-width q-pa-xl"
          style="min-height: calc(20vh)"
        >
          <q-spinner color="primary" size="2em" />
        </div>
      </template>
      <template v-else>
        <div class="q-pl-md q-pr-md q-pt-md row items-center">
          <div class="col">
            <div class="font12">{{ $t("Total earnings") }}</div>
            <div class="text-weight-bold text-h6">{{ balance.pretty }}</div>
          </div>
          <div class="col-4 text-right">
            <!-- <q-btn color="blue" flat no-caps size="sm">Edit Amount</q-btn> -->
            <div class="text-blue font12 cursor-pointer">
              {{ $t("Edit amount") }}
            </div>
            <q-popup-edit
              v-model="totalCashout"
              auto-save
              v-slot="scope"
              :validate="validateCashout"
            >
              <q-input
                v-model="scope.value"
                dense
                autofocus
                counter
                @keyup.enter="scope.set"
              />
            </q-popup-edit>
          </div>
        </div>

        <q-space class="q-pa-sm"></q-space>

        <q-list separator dense>
          <q-item>
            <q-item-section>{{ $t("Cashout") }}</q-item-section>
            <q-item-section side>
              <NumberFormat :amount="totalCashout"></NumberFormat>
            </q-item-section>
          </q-item>

          <q-item>
            <q-item-section>{{ $t("Processing fee") }}</q-item-section>
            <q-item-section side>{{ cashout_fee.pretty }}</q-item-section>
          </q-item>
          <q-item v-if="!hasBankaccount">
            <q-item-section>
              <q-btn color="primary" flat no-caps to="/account/add-bank">{{
                $t("Add Bank Account")
              }}</q-btn>
            </q-item-section>
          </q-item>
          <q-item v-else>
            <q-item-section>
              {{ bank_account.account_type }} -
              {{ bank_account.account_number }}</q-item-section
            >
          </q-item>
        </q-list>
        <div class="q-pl-md q-pr-md q-pt-md">
          <p class="font12">
            {{
              $t(
                "After confirming money will be transfered to you bank account"
              )
            }}.
            {{
              $t(
                "It usually takes 2-4 business days for transfers like this to go through"
              )
            }}.
          </p>
        </div>
        <q-footer class="bg-transparent q-pa-md text-dark">
          <div class="row justify-between q-mb-sm">
            <div class="text-weight-medium">{{ $t("You receive") }}</div>
            <div class="text-weight-bold text-h7">
              <NumberFormat
                :amount="totalCashout - cashout_fee.value"
              ></NumberFormat>
            </div>
          </div>

          <template v-if="can_cashout && hasBankaccount">
            <q-list bordered separator class="radius8">
              <q-slide-item
                @left="confirmCashout"
                left-color="light-green-4"
                class="radius8"
              >
                <template v-slot:left>
                  <q-spinner color="primary" size="2em" />
                </template>
                <q-item
                  class="text-white text-weight-bold btn-11"
                  style="background-color: #f8af01; color: #fff"
                >
                  <q-item-section class="text-center font17">{{
                    $t("Confirm Transfer")
                  }}</q-item-section>
                  <q-item-section avatar>
                    <q-avatar
                      text-color="white"
                      style="background-color: #f8af01; color: #fff"
                      icon="las la-arrow-right"
                    />
                  </q-item-section>
                </q-item>
              </q-slide-item>
            </q-list>
          </template>
          <template v-else>
            <q-btn
              color="primary"
              size="lg"
              :label="$t('Confirm Transfer')"
              unelevated
              class="fit"
              no-caps
              disable
            />
          </template>
        </q-footer>
      </template>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";
import { useActivityStore } from "stores/ActivityStore";

export default {
  name: "CashoutPage",
  components: {
    NumberFormat: defineAsyncComponent(() =>
      import("components/NumberFormat.vue")
    ),
  },
  data() {
    return {
      loading: false,
      first_loading: false,
      balance: [],
      can_cashout: false,
      payload: ["processing_fee", "get_bank_account", "max_cashout"],
      bank_account: [],
      cashout_fee: [],
      totalCashout: 0,
      label: this.$t("Edit amount"),
      //total_cashout: [],
    };
  },
  setup() {
    const Activity = useActivityStore();
    return { Activity };
  },
  created() {
    this.getWalletBalance();
  },
  computed: {
    hasBankaccount() {
      if (Object.keys(this.bank_account).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    refresh(done) {
      this.getWalletBalance(done);
    },
    getWalletBalance(done) {
      if (this.first_loading) {
        APIinterface.showLoadingBox("", this.$q);
      } else {
        this.loading = true;
      }
      APIinterface.fetchDataByTokenPost2("getWalletBalance", {
        payload: this.payload,
      })
        .then((data) => {
          this.first_loading = true;
          this.balance = data.details.balance;
          this.bank_account = data.details.bank_accout;
          this.cashout_fee = data.details.cashout_fee;

          this.Activity.money_config = data.details.money_config;

          // this.totalCashout =
          //   parseFloat(this.balance.raw) - parseFloat(this.cashout_fee.value);
          this.totalCashout = parseFloat(this.balance.raw);

          //this.total_cashout = data.details.total_cashout;

          if (this.totalCashout > 0) {
            this.can_cashout = true;
          } else {
            this.can_cashout = false;
          }
        })
        .catch((error) => {
          this.bank_account = [];
          this.balance = [];
          this.cashout_fee = [];
          //this.total_cashout = [];
        })
        .then((data) => {
          this.loading = false;
          APIinterface.hideLoadingBox(this.$q);
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    confirmCashout(done) {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        "RequestPayout",
        "amount=" + this.totalCashout
      )
        .then((data) => {
          APIinterface.notify("green-5", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/account/cashout-succesful",
            query: { id: data.details },
          });
        })
        .catch((error) => {
          done.reset();
          APIinterface.notify("dark", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    validateCashout(data) {
      if (parseFloat(data) > parseFloat(this.balance.raw)) {
        APIinterface.notify(
          "dark",
          this.$t("Cash out amount should not be greater than earnings"),
          "error_outline",
          this.$q
        );
        return false;
      }
      return true;
    },
  },
};
</script>
