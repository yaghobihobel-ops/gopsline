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
          $t("Settings")
        }}</q-toolbar-title>
      </q-toolbar>
      <q-separator></q-separator>
    </q-header>
    <q-page
      :class="{
        'bg-mydark text-white': $q.dark.mode,
        'bg-white text-dark': !$q.dark.mode,
      }"
    >
      <template v-if="loading">
        <q-inner-loading
          :showing="true"
          color="primary"
          size="md"
          label-class="dark"
          class="transparent"
        />
      </template>
      <q-form v-else @submit="onSubmit">
        <div class="q-pa-md q-gutter-md">
          <p class="q-mb-none">{{ $t("This will appear in your receipt") }}</p>
          <q-input
            outlined
            v-model="merchant_tax_number"
            :label="$t('Tax number')"
            stack-label
            color="grey-5"
            lazy-rules
          />

          <q-select
            outlined
            v-model="merchant_two_flavor_option"
            :options="DataStore.two_flavor_options"
            :label="$t('Two Flavor Options')"
            color="grey-5"
            stack-label
            map-options
            emit-value
          />

          <q-input
            outlined
            v-model="merchant_extenal"
            :label="$t('Website address')"
            stack-label
            color="grey-5"
            lazy-rules
          />

          <div class="column">
            <q-toggle
              v-model="merchant_close_store"
              :label="$t('Close Store')"
            />
            <q-toggle
              v-model="merchant_enabled_voucher"
              :label="$t('Enabled Voucher')"
            />
            <q-toggle
              v-model="merchant_enabled_tip"
              :label="$t('Enabled Tips')"
            />
          </div>

          <q-select
            outlined
            v-model="merchant_default_tip"
            :label="$t('Default Tip')"
            color="grey-5"
            stack-label
            :options="DataStore.tips"
            options-html
            map-options
            emit-value
          />

          <q-select
            outlined
            v-model="merchant_tip_type"
            :label="$t('Tip Type')"
            color="grey-5"
            stack-label
            :options="DataStore.tip_type"
            options-html
            map-options
            emit-value
          />

          <q-select
            outlined
            v-model="tips_in_transactions"
            :label="$t('Services')"
            color="grey-5"
            :options="DataStore.services"
            multiple
            behavior="dialog"
            transition-show="fade"
            transition-hide="fade"
            options-html
            map-options
            emit-value
          />
        </div>

        <q-footer
          class="q-pl-md q-pr-md q-pb-xs"
          :class="{
            'bg-mydark ': $q.dark.mode,
            'bg-white ': !$q.dark.mode,
          }"
        >
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Save')"
            unelevated
            class="full-width radius8"
            size="lg"
            no-caps
            :loading="loading2"
          />
        </q-footer>
      </q-form>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";

export default {
  // name: 'PageName',
  data() {
    return {
      loading: false,
      loading2: false,
      merchant_tax_number: "",
      merchant_two_flavor_option: 0,
      merchant_extenal: "",
      merchant_close_store: false,
      merchant_enabled_voucher: false,
      merchant_enabled_tip: false,
      merchant_default_tip: "",
      merchant_tip_type: "",
      tips_in_transactions: [],
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    return { DataStore };
  },
  created() {
    this.getSettings();
  },
  methods: {
    refresh(done) {
      this.getSettings(done);
    },
    getSettings(done) {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getSettings")
        .then((data) => {
          this.merchant_tax_number = data.details.merchant_tax_number;

          if (!APIinterface.empty(data.details.merchant_two_flavor_option)) {
            this.merchant_two_flavor_option = parseInt(
              data.details.merchant_two_flavor_option
            );
          }
          this.merchant_extenal = data.details.merchant_extenal;
          this.merchant_close_store = data.details.merchant_close_store;
          this.merchant_enabled_voucher = data.details.merchant_enabled_voucher;
          this.merchant_enabled_tip = data.details.merchant_enabled_tip;
          this.merchant_default_tip = data.details.merchant_default_tip;
          this.merchant_tip_type = data.details.merchant_tip_type;
          this.tips_in_transactions = data.details.tips_in_transactions;
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
          if (!APIinterface.empty(done)) {
            done();
          }
        });
    },
    onSubmit() {
      this.loading2 = true;
      APIinterface.fetchDataByToken("saveSettings", {
        merchant_tax_number: this.merchant_tax_number,
        merchant_two_flavor_option: this.merchant_two_flavor_option,
        merchant_extenal: this.merchant_extenal,
        merchant_close_store: this.merchant_close_store,
        merchant_enabled_voucher: this.merchant_enabled_voucher,
        merchant_enabled_tip: this.merchant_enabled_tip,
        merchant_default_tip: this.merchant_default_tip,
        merchant_tip_type: this.merchant_tip_type,
        tips_in_transactions: this.tips_in_transactions,
      })
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading2 = false;
        });
    },
  },
};
</script>
