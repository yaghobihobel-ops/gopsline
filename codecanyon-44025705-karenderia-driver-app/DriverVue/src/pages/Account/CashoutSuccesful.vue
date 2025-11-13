<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
  >
    <q-toolbar>
      <q-toolbar-title class="text-weight-bold">{{
        $t("Cash out")
      }}</q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page class="q-pa-md flex flex-center bg-grey-1">
    <template v-if="loading">
      <q-spinner color="primary" size="2em" />
    </template>

    <template v-else>
      <div class="text-center">
        <svg
          class="checkmark"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 52 52"
        >
          <circle
            class="checkmark__circle"
            cx="26"
            cy="26"
            r="25"
            fill="none"
          />
          <path
            class="checkmark__check"
            fill="none"
            d="M14.1 27.2l7.1 7.2 16.7-16.8"
          />
        </svg>

        <div class="text-h6">{{ data.cashout }}</div>
        <div class="font12 text-weight-light q-mt-sm">
          {{
            $t(
              "Please note that it can take up to 2 to 4 banking days for transfer to complete"
            )
          }}.
        </div>
        <div class="font12 text-weight-light q-mt-md">
          {{ data.cashout_left }}
        </div>
      </div>

      <q-footer class="bg-grey-1 text-dark q-pa-md">
        <q-btn
          type="submit"
          class="fit"
          unelevated
          color="primary"
          :label="$t('Done')"
          no-caps
          size="lg"
          to="/home/earning"
        />
      </q-footer>
    </template>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "CashoutSuccesful",
  data() {
    return {
      data: [],
      loading: "",
      transaction_id: "",
    };
  },
  created() {
    this.transaction_id = this.$route.query.id;
    this.getCashoutTransaction();
  },
  methods: {
    getCashoutTransaction() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "getCashoutTransaction",
        "transaction_id=" + this.transaction_id
      )
        .then((data) => {
          this.data = data.details;
        })
        .catch((error) => {
          //this.$router.push("/404");
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
