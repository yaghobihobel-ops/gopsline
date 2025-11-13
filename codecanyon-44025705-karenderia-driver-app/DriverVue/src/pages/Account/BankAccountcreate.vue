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
        $t("Bank account")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page>
    <q-form @submit="onSubmit" class="q-pl-md q-pr-md">
      <h6 class="text-weight-bold no-margin font16">
        {{ $t("Bank account details") }}
      </h6>
      <p class="text-weight-light q-ma-none">
        {{ $t("Please enter correct bank details to avoid delayed payment") }}.
      </p>
      <q-space class="q-pa-sm"></q-space>

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
        :label="$t('Bank branch')"
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
  name: "BankAccountcreate",
  data() {
    return {
      loading: false,
      data: [],
      account_name: "",
      account_number_iban: "",
      swift_code: "",
      bank_name: "",
      bank_branch: "",
    };
  },
  methods: {
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost2("Addbankaccount", {
        account_name: this.account_name,
        account_number_iban: this.account_number_iban,
        swift_code: this.swift_code,
        bank_name: this.bank_name,
        bank_branch: this.bank_branch,
      })
        .then((data) => {
          APIinterface.notify("green-5", data.msg, "check_circle", this.$q);
          this.$router.push("/account/cashout");
        })
        .catch((error) => {
          APIinterface.notify("dark", error, "error", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
