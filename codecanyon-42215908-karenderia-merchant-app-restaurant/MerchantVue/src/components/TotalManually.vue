<template>
  <q-dialog
    v-model="dialog"
    position="bottom"
    class="rounded-borders-top"
    @before-show="beforeShow"
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
          {{ $t("Apply Total Manually") }}
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
            v-model="total"
            outlined
            color="grey-5"
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('Please enter numbers'),
            ]"
            type="number"
            step="any"
          >
          </q-input>
          <q-btn
            type="submit"
            color="primary"
            text-color="white"
            :label="$t('Apply')"
            unelevated
            class="full-width"
            size="lg"
            no-caps
            :loading="loading"
          />
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
  name: "TotalManually",
  data() {
    return {
      loading: false,
      dialog: false,
      total: 0,
    };
  },
  setup() {
    const CartStore = useCartStore();
    const DataStore = useDataStore();
    return { CartStore, DataStore };
  },
  methods: {
    beforeShow() {
      this.total = 0;
    },
    onSubmit() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "addTotal",
        "total=" +
          this.total +
          "&cart_uuid=" +
          this.DataStore.cart_uuid +
          "&transaction_type=" +
          this.DataStore.cart_transaction_type
      )
        .then((data) => {
          if (APIinterface.empty(this.DataStore.cart_uuid)) {
            this.DataStore.cart_uuid = data.details.cart_uuid;
          }

          this.dialog = false;
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$emit("afterApplytotal");
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
