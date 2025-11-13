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
        $t("Bank information")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page>
    <template v-if="loading">
      <div
        class="flex flex-center full-width q-pa-xl"
        style="min-height: calc(50vh)"
      >
        <q-spinner color="primary" size="2em" />
      </div>
    </template>

    <q-form v-else @submit="onSubmit" class="q-pa-md">
      <q-input
        v-model="account_name"
        :label="$t('Bank account holders name')"
        outlined
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      >
      </q-input>

      <q-input
        v-model="account_number_iban"
        :label="$t('Bank account number/IBAN')"
        outlined
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      >
      </q-input>

      <q-input
        v-model="swift_code"
        :label="$t('Swift Code')"
        outlined
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      >
      </q-input>

      <q-input
        v-model="bank_name"
        :label="$t('Bank name in full')"
        outlined
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      >
      </q-input>

      <q-input
        v-model="bank_branch"
        :label="$t('Bank branch city')"
        outlined
        color="grey-5"
        lazy-rules
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      >
      </q-input>

      <q-footer
        class="q-pa-md"
        :class="{
          'bg-mydark ': $q.dark.mode,
          'bg-white ': !$q.dark.mode,
        }"
      >
        <q-btn
          type="submit"
          color="primary"
          text-color="white"
          :label="$t('Submit')"
          unelevated
          class="full-width"
          size="lg"
          no-caps
          :loading="loading"
        />
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  // name: 'Bankinfo',
  data() {
    return {
      loading: false,
      account_name: "",
      account_number_iban: "",
      swift_code: "",
      bank_name: "",
      bank_branch: "",
    };
  },
  created() {
    this.getBankinfo();
  },
  methods: {
    getBankinfo() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getBankinfo")
        .then((data) => {
          this.account_name = data.details.account_name;
          this.account_number_iban = data.details.account_number_iban;
          this.swift_code = data.details.swift_code;
          this.bank_name = data.details.bank_name;
          this.bank_branch = data.details.bank_branch;
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
    onSubmit() {
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost("updateBankInfo", {
        account_name: this.account_name,
        account_number_iban: this.account_number_iban,
        swift_code: this.swift_code,
        bank_name: this.bank_name,
        bank_branch: this.bank_branch,
      })
        .then((data) => {
          APIinterface.notify("green-5", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
  },
};
</script>
