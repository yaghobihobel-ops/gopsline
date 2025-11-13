<template>
  <q-header
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
  >
    <q-toolbar>
      <q-btn
        @click="$router.back()"
        flat
        round
        dense
        icon="las la-angle-left"
        :color="$q.dark.mode ? 'white' : 'dark'"
      />
      <q-toolbar-title class="text-weight-bold">
        <template v-if="isEdit">
          {{ $t("Update Payment") }}
        </template>
        <template v-else>
          {{ $t("Add Payment") }}
        </template>
      </q-toolbar-title>
    </q-toolbar>
    <q-separator></q-separator>
  </q-header>
  <q-page
    :class="{
      'bg-mydark text-white': $q.dark.mode,
      'bg-white text-dark': !$q.dark.mode,
    }"
    class="q-pl-md q-pr-md"
  >
    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-form v-else @submit="formSubmit">
      <q-space class="q-pa-sm"></q-space>

      <q-select
        v-if="!isEdit"
        v-model="payment_id"
        :options="DriverStore.getPaymentProviderByMerchant"
        :label="$t('Payment')"
        stack-label
        behavior="dialog"
        outlined
        color="grey-5"
        :rules="[
          (val) => (val && val > 0) || this.$t('This field is required'),
        ]"
        emit-value
        map-options
      />

      <template v-if="hasJson">
        <q-toggle v-model="is_live" :label="$t('Production')" />
        <q-space class="q-pa-sm"></q-space>

        <template v-for="(items, keys) in data.attr_json" :key="items">
          <q-input
            :model-value="field_data[keys] ? field_data[keys] : ''"
            :label="items.label"
            stack-label
            outlined
            color="grey-5"
            :rules="[
              (val) =>
                (val && val.length > 0) || this.$t('This field is required'),
            ]"
            @update:model-value="(v) => setValue(v, keys)"
            :autogrow="items.field_type == 'textarea' ? true : false"
          />
        </template>

        <template v-if="hasInstructions">
          <q-card class="q-pa-sm shadow-1">
            <div class="text-subtitle1 text-weight-medium">
              {{ $t("Webhooks") }}
            </div>
            <template v-for="items in instructions" :key="items">
              {{ items }}
            </template>
          </q-card>
          <q-space class="q-pa-sm"></q-space>
        </template>
      </template>

      <q-select
        v-model="status"
        :options="status_list"
        :label="$t('Status')"
        stack-label
        behavior="dialog"
        outlined
        color="grey-5"
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        emit-value
        map-options
      />

      <q-footer>
        <q-btn
          type="submit"
          color="primary"
          text-color="white"
          :label="$t('Save')"
          unelevated
          class="full-width radius8"
          size="lg"
          no-caps
          :disable="CheckData"
        />
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import APIinterface from "src/api/APIinterface";
import { useDriverStore } from "stores/DriverStore";

export default {
  name: "PaymentManage",
  data() {
    return {
      id: "",
      data: [],
      loading: false,
      status: "active",
      payment_id: "",
      status_list: [
        {
          value: "active",
          label: this.$t("Active"),
        },
        {
          value: "inactive",
          label: this.$t("Inactive"),
        },
      ],
      is_live: true,
      attr_json: [],
      field_data: {},
      instructions: [],
    };
  },
  setup(props) {
    const DriverStore = useDriverStore();
    return { DriverStore };
  },
  created() {
    this.DriverStore.PaymentProviderByMerchant();
  },
  mounted() {
    this.id = this.$route.query.id;
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
    hasJson() {
      if (Object.keys(this.attr_json).length > 0) {
        return true;
      }
      return false;
    },
    hasInstructions() {
      if (Object.keys(this.instructions).length > 0) {
        return true;
      }
      return false;
    },
  },
  methods: {
    getData() {
      this.loading = true;
      APIinterface.fetchDataByTokenPost("getPayment", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.status = data.details.status;
          this.attr_json = data.details.attr_json;
          this.is_live = data.details.is_live;
          this.field_data = data.details.field_value;
          this.instructions = data.details.instructions;
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          this.loading = false;
        });
    },
    afterInput(data) {
      this.phone = data;
    },
    formSubmit() {
      let params = {
        id: this.id,
        payment_id: this.payment_id,
        status: this.status,
        is_live: this.is_live,
        field_data: this.field_data,
      };
      APIinterface.showLoadingBox("", this.$q);
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id) ? "UpdatePayment" : "AddPayment",
        params
      )
        .then((data) => {
          APIinterface.notify("light-green", data.msg, "check_circle", this.$q);
          this.$router.replace({
            path: "/payment/payment_list",
          });
        })
        .catch((error) => {
          APIinterface.notify("red-5", error, "error_outline", this.$q);
        })
        .then((data) => {
          APIinterface.hideLoadingBox(this.$q);
        });
    },
    setValue(value, name) {
      this.field_data[name] = value;
    },
    //
  },
};
</script>
