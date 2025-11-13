<template>
  <q-page class="q-pa-md">
    <template v-if="loading">
      <div
        class="row q-gutter-x-sm justify-center absolute-center text-center full-width"
      >
        <q-circular-progress indeterminate rounded size="sm" color="primary" />
        <div class="text-subtitle1 text-grey">{{ $t("Loading") }}...</div>
      </div>
    </template>
    <q-card class="q-pa-none no-shadow" v-else>
      <q-card-section class="q-pa-sm">
        <q-form @submit="onSubmit">
          <template v-if="user_data.merchant_type == 1">
            <q-input
              v-model="merchant_service_fee"
              type="number"
              step="any"
              :label="$t('Service Fee')"
              stack-label
              outlined
              :rules="[(val) => val > 0 || this.$t('This field is required')]"
            />
          </template>

          <q-input
            v-model="estimation"
            :label="$t('Pickup estimation')"
            stack-label
            outlined
            :rules="[
              (val) => val.length > 0 || this.$t('This field is required'),
            ]"
            mask="##-##"
            :hint="$t('in minutes example 10-20mins')"
          />
          <q-space class="q-pa-sm"></q-space>

          <div class="q-gutter-y-md">
            <q-input
              v-model="minimum_order"
              type="number"
              step="any"
              :label="$t('Minimum Order')"
              stack-label
              outlined
            />
            <q-input
              v-model="maximum_order"
              type="number"
              step="any"
              :label="$t('Maximum Order')"
              stack-label
              outlined
            />
          </div>

          <q-space class="q-pa-sm"></q-space>

          <div class="text-body2">
            {{ $t("Customer Pickup Instructions") }}
          </div>
          <p class="text-caption line-normal">
            {{ $t("customer_pickup_instructions") }}
          </p>

          <q-input v-model="instructions" stack-label outlined autogrow />

          <q-space class="q-pa-sm"></q-space>

          <q-footer class="q-pa-md bg-white myshadow">
            <q-btn
              type="submit"
              color="amber-6"
              text-color="disabled"
              unelevated
              class="full-width radius10"
              size="lg"
              no-caps
              :loading="loading_submit"
            >
              <div class="text-weight-bold text-subtitle2">
                {{ $t("Save") }}
              </div>
            </q-btn>
          </q-footer>
        </q-form>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import auth from "src/api/auth";
import { useDataStore } from "src/stores/DataStore";

export default {
  name: "PickupSettings",
  data() {
    return {
      loading: false,
      loading_submit: false,
      data: [],
      estimation: "",
      minimum_order: "",
      maximum_order: "",
      instructions: "",
      service_code: "pickup",
      instructions_type: "customer_pickup_instructions",
      user_data: [],
      merchant_service_fee: "",
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    this.DataStore.page_title = this.$t("Pickup");
    this.getSettings();
    this.user_data = auth.getUser();
  },
  methods: {
    getSettings() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost(
        "getOrderTypeSettings",
        "service_code=" +
          this.service_code +
          "&instructions_type=" +
          this.instructions_type
      )
        .then((data) => {
          this.data = data.details;
          this.estimation = this.data.estimation;
          this.minimum_order = this.data.minimum_order;
          this.maximum_order = this.data.maximum_order;
          this.instructions = this.data.instructions;
          this.merchant_service_fee = this.data.merchant_service_fee;
        })
        .catch((error) => {})
        .then((data) => {
          this.loading = false;
        });
    },
    onSubmit() {
      this.loading_submit = true;
      APIinterface.fetchDataByTokenPost("saveOrderTypeSettings", {
        service_code: this.service_code,
        instructions_type: this.instructions_type,
        estimation: this.estimation,
        minimum_order: this.minimum_order,
        maximum_order: this.maximum_order,
        instructions: this.instructions,
        merchant_service_fee: this.merchant_service_fee,
      })
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading_submit = false;
        });
    },
  },
};
</script>
