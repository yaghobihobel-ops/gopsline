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
            {{ $t("Transaction information") }}
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
                  <div class="text-caption text-grey">{{ $t("Name") }}</div>
                  <div class="text-subtitle1">
                    {{ data.driver_name }}
                  </div>
                </div>
              </div>
              <div class="row">
                <div class="col">
                  <div class="text-caption text-grey">
                    {{ $t("Cash collected balance") }}
                  </div>
                  <div class="text-subtitle1">
                    <NumberFormat :amount="balance"></NumberFormat>
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
                <q-item-label>{{ $t("Amount") }}</q-item-label>
                <q-item-label caption>
                  <NumberFormat :amount="data.amount_collected"></NumberFormat>
                </q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>{{ $t("Date/Time") }}</q-item-label>
                <q-item-label caption>{{ data.transaction_date }}</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>{{ $t("Reference") }}</q-item-label>
                <q-item-label caption>{{ data.reference_id }}</q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
          <q-space class="q-pa-sm"></q-space>
          <q-separator></q-separator>
          <q-card-actions align="right" class="q-pt-md q-pb-md">
            <q-btn rounded color="dark" no-caps unelevated v-close-popup>{{
              $t("Close")
            }}</q-btn>
          </q-card-actions>
        </template>
      </template>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { defineAsyncComponent } from "vue";

export default {
  name: "CollectCashDetails",
  components: {
    NumberFormat: defineAsyncComponent(() =>
      import("components/NumberFormat.vue")
    ),
  },
  data() {
    return {
      dialog: false,
      loading: false,
      merchant: [],
      provider: [],
      transaction_uuid: "",
      transaction_type: "cashout",
      balance: 0,
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
  },
  methods: {
    getPayoutDetails(transaction_uuid) {
      this.transaction_uuid = transaction_uuid;
      this.dialog = true;
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "collectTransactions",
        "collection_uuid=" + this.transaction_uuid
      )
        .then((data) => {
          this.data = data.details.data;
          this.balance = data.details.balance;
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
