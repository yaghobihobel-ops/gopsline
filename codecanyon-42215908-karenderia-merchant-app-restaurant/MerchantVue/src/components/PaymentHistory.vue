<template>
  <q-dialog @show="show" @hide="hide" v-model="dialog" position="bottom">
    <q-card class="rounded-borders-top">
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-weight-bold"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
          style="text-overflow: initial"
        >
          {{ $t("Payment history") }}
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
      <div class="q-pl-md q-pr-md q-pb-sm">
        <template v-if="!hasData">
          <div class="flex flex-center" style="min-height: 100px">
            <p class="text-grey">{{ $t("No available data") }}</p>
          </div>
        </template>
        <div class="timeline-modified q-pl-sm">
          <q-timeline :color="$q.dark.mode ? 'grey600' : 'primary'">
            <template v-for="items in getData" :key="items">
              <q-timeline-entry
                icon="check"
                :color="items.status == 'unpaid' ? 'blue' : 'primary'"
              >
                <template v-slot:title
                  >{{ items.transaction_description }} {{ $t("Reference") }}#{{
                    items.payment_reference
                  }}</template
                >
                <template v-slot:subtitle> {{ items.date_created }} </template>
                <div class="flex q-gutter-sm">
                  <div class="text-dark">{{ items.trans_amount }}</div>
                  <div
                    :class="{
                      'text-blue': items.status == 'unpaid',
                      'text-green': items.status == 'paid',
                    }"
                  >
                    {{ items.status }}
                  </div>
                  <div class="text-grey">{{ items.reason }}</div>
                </div>
              </q-timeline-entry>
            </template>
          </q-timeline>
        </div>
      </div>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "PaymentHistory",
  props: ["order_uuid"],
  data() {
    return {
      dialog: false,
      data: [],
      loading: false,
      order_status: [],
    };
  },
  computed: {
    getData() {
      return this.data;
    },
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
  },
  mounted() {
    this.getOrderHistory();
  },
  methods: {
    getOrderHistory() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "getPaymentHistory",
        "order_uuid=" + this.order_uuid
      )
        .then((data) => {
          this.data = data.details.data;
        })
        .catch((error) => {
          this.data = [];
        })
        .then((data) => {
          this.loading = false;
        });
    },
  },
};
</script>
