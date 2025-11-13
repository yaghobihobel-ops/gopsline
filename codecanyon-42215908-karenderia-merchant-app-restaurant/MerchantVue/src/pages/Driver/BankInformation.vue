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
      <q-toolbar-title class="text-weight-bold">
        {{ $t("Bank information") }}
        <template v-if="hasData">
          -
          {{ data.first_name }} {{ data.last_name }}
        </template>
      </q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
      'flex flex-center': !loading && !hasData,
    }"
    class="q-pa-md"
  >
    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-form v-else @submit="formSubmit">
      <template v-if="hasData">
        <q-input
          v-model="account_name"
          :label="$t('Bank account holders name')"
          stack-label
          outlined
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <q-input
          v-model="account_number_iban"
          :label="$t('Bank account number/IBAN')"
          stack-label
          outlined
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <q-input
          v-model="swift_code"
          :label="$t('Swift Code')"
          stack-label
          outlined
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <q-input
          v-model="bank_name"
          :label="$t('Bank name in full')"
          stack-label
          outlined
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <q-input
          v-model="bank_branch"
          :label="$t('Bank branch city')"
          stack-label
          outlined
          color="grey-5"
          :rules="[
            (val) =>
              (val && val.length > 0) || this.$t('This field is required'),
          ]"
        />

        <q-footer>
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Save')"
            unelevated
            class="full-width radius8"
            size="lg"
            no-caps
          />
        </q-footer>
      </template>
      <template v-else>
        <div class="text-grey">{{ $t("No available data") }}</div>
      </template>
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "BankInformation",
  data() {
    return {
      loading: false,
      id: "",
      data: [],
      account_name: "",
      account_number_iban: "",
      swift_code: "",
      bank_name: "",
      bank_branch: "",
    };
  },
  components: {},
  computed: {
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  mounted() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.getBankInfo();
    }
  },
  methods: {
    getBankInfo() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getBankInfo", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.account_name = this.data.account_name;
          this.account_number_iban = this.data.account_number_iban;
          this.swift_code = this.data.swift_code;
          this.bank_name = this.data.bank_name;
          this.bank_branch = this.data.bank_branch;
        })
        .catch((error) => {
          //
        })
        .then((data) => {
          this.loading = false;
        });
    },
    formSubmit() {
      APIinterface.showLoadingBox("", this.$q);
      let params = {
        id: this.id,
        account_name: this.account_name,
        account_number_iban: this.account_number_iban,
        swift_code: this.swift_code,
        bank_name: this.bank_name,
        bank_branch: this.bank_branch,
      };
      APIinterface.fetchDataByTokenPost("AddDriverBankInfo", params)
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    //
  },
};
</script>
