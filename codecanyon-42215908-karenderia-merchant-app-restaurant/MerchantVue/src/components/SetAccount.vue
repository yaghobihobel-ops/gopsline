<template>
  <q-dialog v-model="dialog" position="bottom" @before-show="beforeShow">
    <q-card class="rounded-borders-top">
      <q-form @submit="onSubmit">
        <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
          <q-toolbar-title
            class="text-darkx text-weight-bold"
            style="overflow: inherit"
            :class="{
              'text-white': $q.dark.mode,
              'text-dark': !$q.dark.mode,
            }"
          >
            {{ $t("Set your default payout account") }}
          </q-toolbar-title>
          <q-btn
            icon="las la-times"
            color="grey"
            flat
            round
            dense
            v-close-popup
          />
        </q-toolbar>
        <q-card-section>
          <template v-if="DataStore.loading_payout_settings">
            <div class="row q-gutter-x-sm justify-center q-my-md">
              <q-circular-progress
                indeterminate
                rounded
                size="sm"
                color="primary"
              />
              <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
            </div>
          </template>

          <div v-else>
            <q-tabs
              v-model="tab"
              dense
              active-color="primary"
              active-class="active-tabs"
              indicator-color="primary"
              align="justify"
              no-caps
              mobile-arrows
              class="text-disabled"
            >
              <q-tab
                v-for="items in DataStore.payout_provider"
                :key="items"
                :name="items.value"
                :label="items.label"
                no-caps
                class="no-wrap q-pa-none"
              >
              </q-tab>
            </q-tabs>
            <q-separator></q-separator>
          </div>

          <q-space class="q-pa-sm"></q-space>

          <q-tab-panels
            v-model="tab"
            animated
            transition-prev="fade"
            transition-next="fade"
          >
            <template v-for="items in DataStore.payout_provider" :key="items">
              <q-tab-panel :name="items.value" class="q-pa-none">
                <template v-if="items.value == 'paypal'">
                  <q-input
                    outlined
                    v-model="email_address"
                    :label="$t('Email address')"
                    stack-label
                    lazy-rules
                    :rules="[
                      (val) => !!val || $t('This field is required'),
                      (val) =>
                        /.+@.+\..+/.test(val) ||
                        $t('Please enter a valid email address'),
                    ]"
                  />
                </template>

                <template v-else-if="items.value == 'stripe'">
                  <q-input
                    outlined
                    v-model="account_number"
                    :label="$t('Account number')"
                    stack-label
                    lazy-rules
                    :rules="[
                      (val) =>
                        (val && val.length > 0) ||
                        this.$t('This field is required'),
                    ]"
                  />
                  <q-input
                    outlined
                    v-model="account_holder_name"
                    :label="$t('Account name')"
                    stack-label
                    lazy-rules
                    :rules="[
                      (val) =>
                        (val && val.length > 0) ||
                        this.$t('This field is required'),
                    ]"
                  />

                  <q-select
                    outlined
                    v-model="account_holder_type"
                    :label="$t('Account holder type')"
                    stack-label
                    behavior="dialog"
                    transition-show="fade"
                    transition-hide="fade"
                    :options="DataStore.payout_account_type"
                    lazy-rules
                    :rules="[(val) => !!val || $t('This field is required')]"
                    emit-value
                    map-options
                  />
                  <q-select
                    outlined
                    v-model="currency"
                    :label="$t('Currency')"
                    stack-label
                    behavior="dialog"
                    transition-show="fade"
                    transition-hide="fade"
                    :options="DataStore.payout_currency"
                    lazy-rules
                    :rules="[(val) => !!val || $t('This field is required')]"
                    emit-value
                    map-options
                  />

                  <q-input
                    outlined
                    v-model="routing_number"
                    :label="$t('Routing number')"
                    stack-label
                    :rules="[
                      (val) =>
                        (val && val.length > 0) ||
                        this.$t('This field is required'),
                    ]"
                  />

                  <q-select
                    outlined
                    v-model="country"
                    :label="$t('Country')"
                    stack-label
                    behavior="dialog"
                    transition-show="fade"
                    transition-hide="fade"
                    :options="DataStore.payout_country"
                    :rules="[(val) => !!val || $t('This field is required')]"
                  />
                </template>

                <template v-else-if="items.value == 'bank'">
                  <q-input
                    outlined
                    v-model="account_name"
                    :label="$t('Bank Account Holders Name')"
                    stack-label
                    lazy-rules
                    :rules="[
                      (val) =>
                        (val && val.length > 0) ||
                        this.$t('This field is required'),
                    ]"
                  />
                  <q-input
                    outlined
                    v-model="account_number_iban"
                    :label="$t('Bank Account Number/IBAN')"
                    stack-label
                    lazy-rules
                    :rules="[
                      (val) =>
                        (val && val.length > 0) ||
                        this.$t('This field is required'),
                    ]"
                  />
                  <q-input
                    outlined
                    v-model="swift_code"
                    :label="$t('SWIFT Code')"
                    stack-label
                    lazy-rules
                    :rules="[
                      (val) =>
                        (val && val.length > 0) ||
                        this.$t('This field is required'),
                    ]"
                  />
                  <q-input
                    outlined
                    v-model="bank_name"
                    :label="$t('Bank Name in Full')"
                    stack-label
                    lazy-rules
                    :rules="[
                      (val) =>
                        (val && val.length > 0) ||
                        this.$t('This field is required'),
                    ]"
                  />
                  <q-input
                    outlined
                    v-model="bank_branch"
                    :label="$t('Bank Branch City')"
                    stack-label
                    lazy-rules
                    :rules="[
                      (val) =>
                        (val && val.length > 0) ||
                        this.$t('This field is required'),
                    ]"
                  />
                </template>
              </q-tab-panel>
            </template>
          </q-tab-panels>
        </q-card-section>
        <q-card-actions class="row" v-if="!DataStore.loading_payout_settings">
          <q-btn
            unelevated
            no-caps
            color="disabled"
            text-color="disabled"
            class="radius10 col"
            size="lg"
            v-close-popup
          >
            <div class="text-weight-bold text-subtitle2">
              {{ $t("Cancel") }}
            </div>
          </q-btn>
          <q-btn
            unelevated
            no-caps
            color="amber-6"
            text-color="disabled"
            class="radius10 col"
            size="lg"
            type="submit"
          >
            <div class="text-weight-bold text-subtitle2">
              {{ $t("Submit") }}
            </div>
          </q-btn></q-card-actions
        >
      </q-form>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "SetAccount",
  data() {
    return {
      dialog: false,
      tab: "paypal",
      loading: false,
      tab_menu: [
        {
          label: this.$t("Paypal"),
          value: "paypal",
        },
        {
          label: this.$t("Stripe"),
          value: "stripe",
        },
        {
          label: this.$t("Bank Transfer"),
          value: "bank",
        },
      ],
      email_address: "",
      account_holder_name: "",
      account_holder_type: "individual",
      account_number: "",
      country: "",
      currency: "",
      payment_provider: "",
      routing_number: "",
      account_name: "",
      account_number_iban: "",
      swift_code: "",
      bank_name: "",
      bank_branch: "",
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  methods: {
    beforeShow() {
      if (Object.keys(this.DataStore.payout_settings_data).length <= 0) {
        this.DataStore.getPayoutSettings(null);
      }

      this.email_address = "";
      this.account_name = "";
      this.account_number_iban = "";
      this.swift_code = "";
      this.bank_name = "";
      this.bank_branch = "";

      this.account_number = "";
      this.account_holder_name = "";
      this.payment_provider = "";
      this.routing_number = "";

      if (Object.keys(this.DataStore.payout_settings_data).length > 0) {
        this.country = this.DataStore.payout_settings_data.default_country;
        this.currency = this.DataStore.payout_settings_data.default_currency;
      }
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByToken("SetPayoutAccount", {
        payment_provider: this.tab,
        email_address: this.email_address,

        account_number: this.account_number,
        account_holder_name: this.account_holder_name,
        account_holder_type: this.account_holder_type,
        currency: this.currency,
        country: this.country,
        routing_number: this.routing_number,

        account_name: this.account_name,
        account_number_iban: this.account_number_iban,
        swift_code: this.swift_code,
        bank_name: this.bank_name,
        bank_branch: this.bank_branch,
      })
        .then((data) => {
          this.dialog = false;
          APIinterface.ShowSuccessful(data.msg, this.$q);
          this.$emit("afterSetaccount");
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
