<template>
  <q-pull-to-refresh @refresh="refresh">
    <q-page class="q-pa-md">
      <template v-if="loading">
        <q-inner-loading :showing="true" color="primary" size="md" />
      </template>
      <template v-else>
        <q-card class="no-shadow">
          <q-card-section>
            <div class="text-caption">
              {{ $t("Invoice No") }}#: {{ data.invoice_number }}
            </div>
            <div class="text-caption">
              {{ $t("Invoice Date") }} : {{ data.invoice_created }}
            </div>
            <div class="text-caption">
              {{ $t("Due Date") }} : {{ data.due_date }}
            </div>

            <q-space class="q-pa-xs"></q-space>
            <div
              class="bg-grey-1x q-pa-sm radius8 text-center"
              :class="{
                'bg-grey600 text-white': $q.dark.mode,
                'bg-grey-1': !$q.dark.mode,
              }"
            >
              <q-badge color="amber text-uppercase">{{
                data.payment_status
              }}</q-badge>
              <div class="text-h6">{{ data.amount_due }}</div>
              <div class="text-green text-caption">{{ $t("OVERDUE") }}</div>
            </div>

            <q-space class="q-pa-xs"></q-space>
            <div class="text-subtitle1">{{ $t("BILL TO") }}</div>
            <div class="text-caption">{{ data.restaurant_name }}</div>
            <div class="text-caption">
              {{ data.business_address }}
            </div>

            <q-space class="q-pa-sm"></q-space>

            <div
              class="bg-grey-1x q-pa-sm"
              :class="{
                'bg-grey600 text-white': $q.dark.mode,
                'bg-grey-1': !$q.dark.mode,
              }"
            >
              <div class="flex justify-between">
                <div class="text-overline">{{ $t("Description") }}</div>
                <div class="text-overline">{{ $t("Total") }}</div>
              </div>
            </div>
            <div
              class="bg-whitex q-pa-sm"
              :class="{
                'bg-grey600 text-white': $q.dark.mode,
                'bg-white': !$q.dark.mode,
              }"
            >
              <div class="row text-caption">
                <div class="col">
                  {{ $t("Commission") }} ({{ data.date_from }} -
                  {{ data.date_to }})
                </div>
                <div class="col text-right">{{ data.invoice_total }}</div>
              </div>
            </div>
            <q-separator></q-separator>
            <div
              class="bg-whitex q-pa-sm"
              :class="{
                'bg-grey600 text-white': $q.dark.mode,
                'bg-white': !$q.dark.mode,
              }"
            >
              <div class="row text-caption">
                <div class="col">{{ $t("Sub total") }}</div>
                <div class="col text-right">{{ data.invoice_total }}</div>
              </div>
            </div>
            <div
              class="bg-whitex q-pa-sm"
              :class="{
                'bg-grey600 text-white': $q.dark.mode,
                'bg-white': !$q.dark.mode,
              }"
            >
              <div class="row text-caption">
                <div class="col">{{ $t("Total") }}</div>
                <div class="col text-right">{{ data.invoice_total }}</div>
              </div>
            </div>
            <div
              class="bg-whitex q-pa-sm"
              :class="{
                'bg-grey600 text-white': $q.dark.mode,
                'bg-white': !$q.dark.mode,
              }"
            >
              <div class="row text-caption">
                <div class="col">{{ $t("Amount paid") }}</div>
                <div class="col text-right">{{ data.amount_paid }}</div>
              </div>
            </div>
            <div
              class="bg-whitex q-pa-sm"
              :class="{
                'bg-grey600 text-white': $q.dark.mode,
                'bg-white': !$q.dark.mode,
              }"
            >
              <div class="row text-caption">
                <div class="col text-subtitle2">{{ $t("AMOUNT DUE") }}</div>
                <div class="col text-right text-subtitle2">
                  {{ data.amount_due }}
                </div>
              </div>
            </div>
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
      APIinterface.fetchDataByTokenPost("invoiceDetails", "id=" + this.id)
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
