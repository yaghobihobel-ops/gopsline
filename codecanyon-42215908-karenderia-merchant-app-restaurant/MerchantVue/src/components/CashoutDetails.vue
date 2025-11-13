<template>
  <q-dialog
    v-model="dialog"
    class="rounded-borders-top"
    @before-show="beforeShow"
    persistent
    position="bottom"
    transition-show="fade"
  >
    <q-card>
      <template v-if="loading">
        <div style="min-height: 50vh">
          <q-inner-loading :showing="true" size="md" color="primary">
          </q-inner-loading>
        </div>
      </template>

      <template v-else>
        <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
          <q-toolbar-title
            class="text-darkx text-weight-bold"
            style="overflow: inherit"
            :class="{
              'text-white': $q.dark.mode,
              'text-dark': !$q.dark.mode,
            }"
          >
            {{ $t("Cashout Details") }}
          </q-toolbar-title>
          <q-space></q-space>
          <q-btn
            @click="dialog = !true"
            color="white"
            square
            unelevated
            text-color="grey"
            icon="las la-times"
            dense
            no-caps
            size="sm"
            class="border-grey radius8"
          />
        </q-toolbar>
        <q-card-section class="q-pt-none">
          <template v-if="!hasData">
            <div
              class="flex flex-center"
              style="min-height: calc(50vh); max-height: 50vh"
            >
              <div class="text-grey">{{ $t("No data available") }}</div>
            </div>
          </template>
          <template v-else>
            <div
              class="bg-grey-1x q-pa-sm radius8"
              :class="{
                'bg-grey600 text-white': $q.dark.mode,
                'bg-grey-1': !$q.dark.mode,
              }"
            >
              <div class="row">
                <div class="col">
                  <div class="text-caption text-grey">{{ $t("Amount") }}</div>
                  <div class="text-subtitle1">
                    {{ data.transaction_amount }}
                  </div>
                </div>
                <div class="col">
                  <div class="text-caption text-grey">{{ $t("Merchant") }}</div>
                  <div class="text-subtitle1">
                    {{ merchant.restaurant_name }}
                  </div>
                </div>
              </div>

              <div class="row">
                <div class="col">
                  <div class="text-caption text-grey">
                    {{ $t("Payment Method") }}
                  </div>
                  <div class="text-subtitle1">
                    {{ provider.payment_name }}
                  </div>
                </div>
                <div class="col">
                  <div class="text-caption text-grey">
                    {{ $t("Date requested") }}
                  </div>
                  <div class="text-subtitle1 font12">
                    {{ data.transaction_date }}
                  </div>
                </div>
              </div>
            </div>
          </template>
        </q-card-section>

        <template v-if="hasData">
          <q-list separator>
            <q-item>
              <q-item-section>
                <q-item-label>{{ $t("Account Holders Name") }}</q-item-label>
                <q-item-label caption>{{ data.account_name }}</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>{{
                  $t("Bank Account Number/IBAN")
                }}</q-item-label>
                <q-item-label caption>{{
                  data.account_number_iban
                }}</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>{{ $t("SWIFT Code") }}</q-item-label>
                <q-item-label caption>{{
                  data.account_number_iban
                }}</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>{{ $t("Bank Name in Full") }}</q-item-label>
                <q-item-label caption>{{ data.bank_name }}</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>{{ $t("Bank Branch City") }}</q-item-label>
                <q-item-label caption>{{ data.bank_branch }}</q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
          <q-space class="q-pa-sm"></q-space>
          <q-separator></q-separator>
          <q-card-actions align="right" class="q-pt-md q-pb-md">
            <q-btn rounded color="dark" no-caps unelevated v-close-popup>{{
              $t("Close")
            }}</q-btn>

            <q-btn
              rounded
              color="amber"
              no-caps
              unelevated
              :disable="data.status == 'unpaid' ? false : true"
              @click="confirmCancelPayout"
              >{{ $t("Cancel Payout") }}</q-btn
            >
            <q-btn
              rounded
              color="green"
              no-caps
              unelevated
              :disable="data.status == 'unpaid' ? false : true"
              @click="payoutPaid"
              >{{ $t("Set to Paid") }}</q-btn
            >
          </q-card-actions>
        </template>
      </template>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "CashoutDetails",
  data() {
    return {
      dialog: false,
      loading: false,
      merchant: [],
      provider: [],
      transaction_uuid: "",
      transaction_type: "cashout",
    };
  },
  setup() {
    return {};
  },
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    CanChangeStatus() {
      if (Object.keys(this.data).length > 0) {
        console.log(this.data.status);
        if (this.data.status == "unpaid") {
          return false;
        }
      }
      return true;
    },
  },
  methods: {
    getPayoutDetails(transaction_uuid) {
      this.transaction_uuid = transaction_uuid;
      this.dialog = true;
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "getPayoutDetails",
        "transaction_uuid=" + this.transaction_uuid
      )
        .then((data) => {
          this.data = data.details.data;
          this.merchant = data.details.merchant;
          this.provider = data.details.provider;
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    confirmCancelPayout() {
      this.$q
        .dialog({
          title: this.$t("Cancel Payout"),
          message: this.$t("are you sure?"),
          transitionShow: "fade",
          transitionHide: "fade",
          cancel: true,
          ok: {
            unelevated: true,
            color: "primary",
            rounded: false,
            "text-color": "white",
            size: "md",
            label: this.$t("Confirm"),
            "no-caps": true,
          },
          cancel: {
            unelevated: true,
            color: "dark",
            rounded: false,
            outline: true,
            size: "md",
            label: this.$t("Cancel"),
            "no-caps": true,
          },
        })
        .onOk(() => {
          this.cancelPayout();
        });
    },
    cancelPayout() {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost(
        "cancelPayout",
        "transaction_uuid=" +
          this.transaction_uuid +
          "&transaction_type=" +
          this.transaction_type
      )
        .then((data) => {
          this.dialog = false;
          this.$emit("afterCancelpayout");
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.$q.loading.hide();
        });
    },
    payoutPaid() {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost(
        "payoutPaid",
        "transaction_uuid=" +
          this.transaction_uuid +
          "&transaction_type=" +
          this.transaction_type
      )
        .then((data) => {
          this.dialog = false;
          this.$emit("afterUpdate");
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
