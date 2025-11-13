<template>
  <q-page class="q-pa-md">
    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-form v-else @submit="formSubmit">
      <q-select
        v-model="shipping_type"
        :label="$t('Shipping Type')"
        :options="shipping_list"
        stack-label
        behavior="menu"
        outlined
        emit-value
        map-options
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />

      <div class="row q-gutter-x-sm">
        <q-input
          v-model="distance_from"
          type="number"
          step="any"
          :label="$t('From')"
          stack-label
          outlined
          :rules="[
            (val) =>
              val === 0 ||
              ((!!val || val === 0) && Number(val) >= 0) ||
              $t('Value must be 0 or greater'),
          ]"
          class="col"
        />
        <q-input
          v-model="distance_to"
          type="number"
          step="any"
          :label="$t('To')"
          stack-label
          outlined
          :rules="[
            (val) => (val && val > 0) || this.$t('This field is required'),
          ]"
          class="col"
        />
      </div>

      <q-input
        v-model="distance_price"
        type="number"
        step="any"
        :label="$t('Price')"
        stack-label
        outlined
        :rules="[
          (val) => (val && val > 0) || this.$t('This field is required'),
        ]"
      />

      <q-input
        v-model="estimation"
        :label="$t('Delivery estimation')"
        stack-label
        outlined
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        :hint="$t('in minutes example 10-20mins')"
        mask="##-##"
      />

      <q-space class="q-pa-sm"></q-space>

      <div class="row q-gutter-x-sm">
        <q-input
          v-model="minimum_order"
          type="number"
          step="any"
          :label="$t('Minimum Order')"
          stack-label
          outlined
          class="col"
        />
        <q-input
          v-model="maximum_order"
          type="number"
          step="any"
          :label="$t('Maximum Order')"
          stack-label
          outlined
          class="col"
        />
      </div>

      <q-footer class="q-pa-md bg-white myshadow">
        <q-btn
          type="submit"
          color="amber-6"
          text-color="disabled"
          unelevated
          class="full-width radius8"
          size="lg"
          no-caps
          :loading="loading1"
          :disable="CheckData"
        >
          <div class="text-weight-bold text-subtitle2">
            {{ this.id > 0 ? $t("Update") : $t("Submit") }}
          </div>
        </q-btn>
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";

export default {
  name: "ReviewManage",
  components: {},
  data() {
    return {
      id: "",
      data: [],
      loading: false,
      loading1: false,
      shipping_type: "standard",
      distance_from: 0,
      distance_to: 0,
      distance_price: 0,
      estimation: "",
      minimum_order: 0,
      maximum_order: 0,
      shipping_list: [
        {
          value: "standard",
          label: this.$t("Standard"),
        },
        {
          value: "priority",
          label: this.$t("Priority"),
        },
        {
          value: "no_rush",
          label: this.$t("No rush"),
        },
      ],
    };
  },
  setup() {
    const DataStore = useDataStore();
    return { DataStore };
  },
  mounted() {
    this.id = this.$route.query.id;
    this.DataStore.page_title = this.$t("Delivery Rates");
    if (!APIinterface.empty(this.id)) {
      this.getData();
    }
  },
  computed: {
    isEdit() {
      if (!APIinterface.empty(this.id)) {
        return true;
      }
      return false;
    },
    hasData() {
      if (Object.keys(this.data).length > 0) {
        return true;
      }
      return false;
    },
    CheckData() {
      if (!APIinterface.empty(this.id)) {
        if (Object.keys(this.data).length <= 0) {
          return true;
        }
      }
      return false;
    },
  },
  methods: {
    getData() {
      this.loading = true;

      APIinterface.fetchDataByTokenPost("getDynamicRates", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.shipping_type = data.details.shipping_type;
          this.distance_from = data.details.distance_from;
          this.distance_to = data.details.distance_to;
          this.distance_price = data.details.distance_price;
          this.estimation = data.details.estimation;
          this.minimum_order = data.details.minimum_order;
          this.maximum_order = data.details.maximum_order;
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    formSubmit() {
      this.loading1 = true;
      let params = {
        id: this.id,
        shipping_type: this.shipping_type,
        distance_from: this.distance_from,
        distance_to: this.distance_to,
        distance_price: this.distance_price,
        estimation: this.estimation,
        minimum_order: this.minimum_order,
        maximum_order: this.maximum_order,
      };
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id) ? "UpdateDynamicRates" : "AddDynamicRates",
        params
      )
        .then((data) => {
          this.DataStore.cleanData("delivery_settings");
          APIinterface.ShowSuccessful(data.msg, this.$q);
          this.$router.replace({
            path: "/services/delivery_settings",
          });
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
        })
        .then((data) => {
          this.loading1 = false;
        });
    },
    //
  },
};
</script>
