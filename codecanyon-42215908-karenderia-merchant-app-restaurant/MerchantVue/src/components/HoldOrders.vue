<template>
  <q-dialog
    v-model="dialog"
    class="rounded-borders-top"
    @before-show="beforeShow"
    full-width
    persistent
  >
    <q-card>
      <q-toolbar class="text-primary top-toolbar q-pl-md" dense>
        <q-toolbar-title
          class="text-darkx text-weight-bold"
          style="overflow: inherit"
          :class="{
            'text-white': $q.dark.mode,
            'text-dark': !$q.dark.mode,
          }"
        >
          {{ $t("Hold Order") }}
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
      <q-card-section>
        <q-form @submit="onSubmit">
          <q-input
            v-model="order_reference"
            :label="$t('Order Reference')"
            stack-label
            outlined
            color="grey-5"
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          >
          </q-input>

          <p class="text-body2 q-ma-none font12">
            {{
              $t(
                "The current order will be set on hold. You can retrieve this order from the pending tabs."
              )
            }}
            {{
              $t(
                "Providing a reference to it might help you to identify the order more quickly."
              )
            }}
          </p>

          <q-space class="q-pa-sm"></q-space>

          <div class="row fit q-gutter-sm">
            <div class="col">
              <q-btn
                :label="$t('Cancel')"
                color="dark"
                no-caps
                unelevated
                class="fit radius28 q-pl-lg q-pr-lg q-pt-sm q-pb-sm"
                style="height: 40px"
                v-close-popup
              ></q-btn>
            </div>
            <div class="col">
              <q-btn
                type="submit"
                color="green"
                text-color="white"
                :label="$t('Confirm')"
                unelevated
                class="fit radius28 q-pl-lg q-pr-lg q-pt-sm q-pb-sm"
                style="height: 40px"
                no-caps
                :loading="loading"
              />
            </div>
          </div>
        </q-form>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useCartStore } from "stores/CartStore";

export default {
  name: "HoldOrders",
  setup() {
    const DataStore = useDataStore();
    const CartStore = useCartStore();
    return { DataStore, CartStore };
  },
  data() {
    return {
      loading: false,
      dialog: false,
      order_reference: "",
    };
  },
  methods: {
    beforeShow() {
      this.order_reference = !APIinterface.empty(
        this.CartStore.getOrderReference
      )
        ? this.CartStore.getOrderReference
        : "";
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "applyHoldOrder",
        "order_reference=" +
          this.order_reference +
          "&cart_uuid=" +
          this.DataStore.cart_uuid
      )
        .then((data) => {
          this.dialog = false;
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.DataStore.place_data = [];
          this.DataStore.cart_uuid = "";
          this.$emit("afterHoldorders");
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
