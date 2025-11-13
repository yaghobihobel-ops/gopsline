<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md row items-stretch">
      <template v-if="loading">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>
      <template v-else>
        <q-card class="no-shadow full-width">
          <q-card-section>
            <template v-if="hasData">
              <div class="text-subtitle1">{{ $t("Payment information") }}</div>
              <q-space class="q-pa-sm"></q-space>
              <div class="text-caption">
                {{ data.message }}
              </div>

              <q-space class="q-pa-sm"></q-space>
              <q-list>
                <q-item>
                  <q-item-section>
                    <q-item-label caption>{{ $t("Bank name") }}</q-item-label>
                    <q-item-label>{{
                      data.payment_info.bank_name
                    }}</q-item-label>
                  </q-item-section>
                </q-item>
                <q-item>
                  <q-item-section>
                    <q-item-label caption>{{
                      $t("Account name")
                    }}</q-item-label>
                    <q-item-label>{{
                      data.payment_info.account_name
                    }}</q-item-label>
                  </q-item-section>
                </q-item>
                <q-item>
                  <q-item-section>
                    <q-item-label caption>{{
                      $t("Account number")
                    }}</q-item-label>
                    <q-item-label>{{
                      data.payment_info.account_number
                    }}</q-item-label>
                  </q-item-section>
                </q-item>
              </q-list>
            </template>
            <template v-else>
              <div class="full-width text-center">
                <p class="text-grey q-ma-none">{{ $t("No available data") }}</p>
              </div>
            </template>
          </q-card-section>
        </q-card>
      </template>
    </q-page>
  </q-pull-to-refresh>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  // name: 'PageName',
  data() {
    return {
      id: null,
      loading: false,
      data: [],
      is_refresh: undefined,
    };
  },
  mounted() {
    this.id = this.$route.query.id;
    if (!APIinterface.empty(this.id)) {
      this.getData();
    }
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
    refresh(done) {
      this.is_refresh = done;
      this.getData();
    },
    getData() {
      if (APIinterface.empty(this.is_refresh)) {
        this.loading = true;
      }
      APIinterface.fetchDataByTokenPost(
        "getInvoicePaymentInformation",
        "id=" + this.id
      )
        .then((data) => {
          this.data = data.details;
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
          if (!APIinterface.empty(this.is_refresh)) {
            this.is_refresh();
          }
        });
    },
  },
};
</script>
