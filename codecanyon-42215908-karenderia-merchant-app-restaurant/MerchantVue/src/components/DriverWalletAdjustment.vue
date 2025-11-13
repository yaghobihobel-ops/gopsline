<template>
  <q-dialog
    v-model="dialog"
    class="rounded-borders-top"
    @before-show="beforeShow"
    persistent
    position="bottom"
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
          {{ $t("Create adjustment") }}
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
            outlined
            v-model="transaction_description"
            :label="$t('Transaction Description')"
            stack-label
            color="grey-5"
            lazy-rules
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-select
            v-model="transaction_type"
            :label="$t('Transaction Type')"
            :options="transaction_list"
            stack-label
            behavior="dialog"
            outlined
            color="grey-5"
            emit-value
            map-options
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
          />

          <q-input
            v-model="transaction_amount"
            type="number"
            step="any"
            :label="$t('Amount')"
            stack-label
            outlined
            color="grey-5"
          />

          <q-space class="q-pa-sm"></q-space>

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
        </q-form>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
import APIinterface from "src/api/APIinterface";

export default {
  name: "DriverWalletAdjustment",
  props: ["id"],
  data() {
    return {
      dialog: false,
      transaction_description: "",
      transaction_type: "credit",
      transaction_amount: 0,
      transaction_list: [
        {
          value: "credit",
          label: this.$t("Credit"),
        },
        {
          value: "debit",
          label: this.$t("Debit"),
        },
      ],
    };
  },
  setup() {
    return {};
  },
  methods: {
    onSubmit() {
      this.$q.loading.show({
        spinnerSize: 30,
        spinnerColor: "primary",
      });
      APIinterface.fetchDataByTokenPost("driverWalletAdjustment", {
        id: this.id,
        transaction_description: this.transaction_description,
        transaction_type: this.transaction_type,
        transaction_amount: this.transaction_amount,
      })
        .then((response) => {
          this.dialog = false;
          this.$emit("afterAdjustment");
        })
        .catch((error) => {})
        .then((data) => {
          this.$q.loading.hide();
        });
    },
  },
};
</script>
