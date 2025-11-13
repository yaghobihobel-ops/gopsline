<template>
  <q-dialog
    v-model="dialog"
    class="rounded-borders-top"
    @before-show="beforeShow"
    :maximized="true"
    persistent
    transition-show="fade"
  >
    <q-card>
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
            {{ $t("Create Payment") }}
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
        <q-card-section style="max-height: 80vh" class="scroll">
          <div class="row q-gutter-sm">
            <div
              class="col border-grey rounded-borders q-pa-sm text-center"
              :class="{
                'bg-grey600 text-white': $q.dark.mode,
              }"
            >
              <div class="text-subtitle2">{{ $t("Total Due") }}</div>
              <div class="text-caption">
                <NumberFormat :amount="total"></NumberFormat>
              </div>
            </div>
            <div
              class="col border-grey rounded-borders q-pa-sm text-center"
              :class="{
                'bg-grey600 text-white': $q.dark.mode,
              }"
            >
              <div class="text-subtitle2">{{ $t("Pay Left") }}</div>
              <div class="text-caption">
                <NumberFormat :amount="pay_left"></NumberFormat>
              </div>
            </div>
            <div
              class="col border-grey rounded-borders q-pa-sm text-center"
              :class="{
                'bg-grey600 text-white': $q.dark.mode,
              }"
            >
              <div class="text-subtitle2">{{ $t("Change") }}</div>
              <div class="text-caption">
                <NumberFormat :amount="change"></NumberFormat>
              </div>
            </div>
          </div>
          <q-space class="q-pa-xs"></q-space>

          <div class="border-grey radius8">
            <q-btn-toggle
              v-if="CartStore.getPreferedTime"
              v-model="whento_deliver"
              toggle-color="green"
              unelevated
              no-caps
              :options="CartStore.getPreferedTime"
              spread
            />
          </div>

          <q-space class="q-pa-xs"></q-space>

          <div v-if="whento_deliver == 'schedule'" class="q-gutter-y-smx">
            <q-select
              v-if="CartStore.getOpeningDates"
              outlined
              v-model="delivery_date"
              :options="CartStore.getOpeningDates"
              :label="$t('Date')"
              emit-value
              stack-label
              :rules="[
                (val) =>
                  (val && val.length > 0) || this.$t('This field is required'),
              ]"
              map-options
              @update:model-value="afterSelectDate"
            />

            <q-select
              outlined
              v-model="delivery_time"
              :options="getTimelist"
              :label="$t('Time')"
              option-value="start_time"
              option-label="pretty_time"
              stack-label
              emit-value
              :rules="[
                (val) =>
                  (val && val.length > 0) || this.$t('This field is required'),
              ]"
              map-options
            />
          </div>

          <q-space class="q-pa-xs"></q-space>
          <q-select
            outlined
            v-model="order_status"
            :label="$t('Order status')"
            :options="CartStore.getOrderStatus"
            stack-label
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
            emit-value
            map-options
          />

          <q-select
            outlined
            v-model="payment_code"
            :label="$t('Payment Method')"
            :options="CartStore.getPaymentMethod"
            option-value="payment_code"
            option-label="payment_name"
            stack-label
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
            emit-value
            map-options
          />

          <!-- <q-input
            outlined
            v-model.number="receive_amount"
            type="number"
            step="any"
            :label="$t('Receive amount')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[(val) => val > 0 || this.$t('This field is required')]"
          /> -->
          <q-input
            outlined
            v-model="receive_amount"
            :label="$t('Receive amount')"
            mask="#.##"
            fill-mask="0"
            reverse-fill-mask
            lazy-rules
            :rules="[(val) => val > 0 || this.$t('This field is required')]"
          />

          <template v-if="DataStore.cart_transaction_type == 'dinein'">
            <q-input
              outlined
              v-model.number="guest_number"
              mask="#############"
              :label="$t('Guest')"
              stack-label
              color="grey-5"
              lazy-rules
              :rules="[(val) => val > 0 || this.$t('This field is required')]"
            />

            <q-select
              outlined
              v-model="room_id"
              :label="$t('Room Name')"
              :options="CartStore.getRoomList"
              stack-label
              :rules="[
                (val) =>
                  (val && val.length > 0) || this.$t('This field is required'),
              ]"
              emit-value
              map-options
              @update:model-value="afterSelectRoom"
            />

            <q-select
              outlined
              v-model="table_id"
              :label="$t('Table Name')"
              :options="getTableList"
              stack-label
              :rules="[
                (val) =>
                  (val && val.length > 0) || this.$t('This field is required'),
              ]"
              emit-value
              map-options
            />
          </template>

          <div class="q-gutter-y-md">
            <q-input
              outlined
              v-model="payment_reference"
              :label="$t('Payment Reference number')"
              stack-label
              color="grey-5"
            />

            <q-input
              outlined
              v-model="order_notes"
              :label="$t('Add order notes')"
              stack-label
              color="grey-5"
              autogrow
            />
          </div>

          <q-space class="q-pa-md"></q-space>
        </q-card-section>
        <q-separator />
        <q-card-actions>
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Pay Now')"
            unelevated
            class="full-width"
            size="lg"
            no-caps
            :loading="loading"
            :disable="!hasValidPayment"
          />
        </q-card-actions>
      </q-form>
    </q-card>
  </q-dialog>
</template>

<script>
import { defineAsyncComponent } from "vue";
import { useCartStore } from "stores/CartStore";
import { useDataStore } from "stores/DataStore";
import APIinterface from "src/api/APIinterface";

export default {
  name: "PosCreatePayment",
  props: ["total"],
  components: {
    NumberFormat: defineAsyncComponent(() =>
      import("components/NumberFormat.vue")
    ),
  },
  data() {
    return {
      loading: false,
      dialog: false,
      whento_deliver: "now",
      delivery_date: "",
      delivery_time: "",
      order_status: "",
      receive_amount: 0,
      payment_code: "",
      payment_reference: "",
      order_notes: "",
      pay_left: 0,
      change: 0,
      room_id: "",
      table_id: "",
      guest_number: 1,
    };
  },
  setup() {
    const CartStore = useCartStore();
    const DataStore = useDataStore();
    return { CartStore, DataStore };
  },
  watch: {
    total(newval, oldval) {
      this.receive_amount = newval;
    },
    receive_amount(newamount, oldamount) {
      this.pay_left = parseFloat(this.total) - parseFloat(newamount);
      if (this.pay_left <= 0) {
        this.pay_left = 0;
      }
      this.change = parseFloat(newamount) - parseFloat(this.total);
      if (this.change <= 0) {
        this.change = 0;
      }
    },
    CartStore: {
      immediate: true,
      deep: true,
      handler(newValue, oldValue) {
        if (!newValue.pos_loading) {
          if (Object.keys(newValue.pos_attributes).length > 0) {
            this.order_status = newValue.pos_attributes.order_status;
            this.payment_code = newValue.pos_attributes.default_payment;
          }
        }
      },
    },
  },
  computed: {
    getTimelist() {
      if (Object.keys(this.CartStore.pos_attributes).length > 0) {
        if (
          this.CartStore.pos_attributes.opening_hours.time_ranges[
            this.delivery_date
          ]
        ) {
          return this.CartStore.pos_attributes.opening_hours.time_ranges[
            this.delivery_date
          ];
        }
      }
      return [];
    },
    getTableList() {
      if (Object.keys(this.CartStore.pos_attributes).length > 0) {
        if (this.CartStore.pos_attributes.table_list[this.room_id]) {
          return this.CartStore.pos_attributes.table_list[this.room_id];
        }
      }
      return [];
    },
    hasValidPayment() {
      if (APIinterface.empty(this.DataStore.cart_transaction_type)) {
        return false;
      }
      if (this.receive_amount <= 0) {
        return false;
      }
      if (APIinterface.empty(this.payment_code)) {
        return false;
      }
      if (this.pay_left.toFixed(2) > 0) {
        return false;
      }
      return true;
    },
  },
  methods: {
    afterSelectRoom() {
      this.table_id = "";
    },
    afterSelectDate() {
      this.delivery_time = "";
    },
    onSubmit() {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      this.loading = true;

      let place_id = this.DataStore.place_data
        ? this.DataStore.place_data.place_id
        : "";

      APIinterface.fetchDataByTokenPost("submitPOSOrder", {
        place_id: place_id,
        place_data: this.DataStore.place_data,
        cart_uuid: this.DataStore.cart_uuid,
        whento_deliver: this.whento_deliver,
        transaction_type: this.DataStore.cart_transaction_type,
        delivery_date: this.delivery_date,
        delivery_time: this.delivery_time,
        order_status: this.order_status,
        receive_amount: this.receive_amount,
        payment_code: this.payment_code,
        payment_reference: this.payment_reference,
        order_notes: this.order_notes,
        order_change: this.change,
        guest_number: this.guest_number,
        room_id: this.room_id,
        table_id: this.table_id,
      })
        .then((data) => {
          this.$emit("afterPlaceorder");
          this.DataStore.place_data = [];
          this.DataStore.cart_uuid = "";

          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.push({
            path: "/orderview",
            query: { order_uuid: data.details.order_uuid },
          });
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
          this.$q.loading.hide();
        });
    },
  },
};
</script>
