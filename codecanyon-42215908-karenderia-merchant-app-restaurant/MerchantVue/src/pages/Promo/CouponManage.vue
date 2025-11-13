<template>
  <q-page class="q-pa-md">
    <template v-if="loading">
      <q-inner-loading :showing="true" color="primary" size="md" />
    </template>
    <q-form v-else @submit="formSubmit">
      <q-input
        v-model="voucher_name"
        :label="$t('Coupon name')"
        stack-label
        outlined
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
      />

      <q-select
        v-model="voucher_type"
        :options="DriverStore.getPromoAttributes.voucher_type"
        :label="$t('Coupon Type')"
        stack-label
        behavior="dialog"
        outlined
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        emit-value
        map-options
      />

      <div class="row q-gutter-x-sm">
        <q-input
          v-model="amount"
          type="number"
          step="any"
          :label="$t('Discount')"
          stack-label
          outlined
          :rules="[
            (val) => (val && val > 0) || this.$t('This field is required'),
          ]"
          class="col"
        />
        <q-input
          v-model="min_order"
          :label="$t('Minimum Order')"
          type="number"
          step="any"
          stack-label
          outlined
          class="col"
        />
      </div>

      <div class="row q-gutter-x-sm q-mb-md">
        <q-input
          v-model="max_order"
          type="number"
          step="any"
          :label="$t('Maximum Order')"
          stack-label
          outlined
          class="col"
        />
        <q-input
          v-model="max_discount_cap"
          :label="$t('Maximum Discount Cap')"
          type="number"
          step="any"
          stack-label
          outlined
          class="col"
        />
      </div>

      <q-select
        v-model="days_available"
        :options="DriverStore.getPromoAttributes.days"
        :label="$t('Days Available')"
        stack-label
        behavior="menu"
        outlined
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        emit-value
        map-options
        multiple
      />

      <q-input
        v-model="expiration"
        mask="date"
        :rules="['date']"
        stack-label
        outlined
        :label="$t('Expiration')"
        class="col"
      >
        <q-popup-proxy
          cover
          transition-show="scale"
          transition-hide="scale"
          ref="datePopup"
        >
          <q-date
            v-model="expiration"
            color="disabled"
            text-color="dark"
            @update:model-value="() => $refs.datePopup.hide()"
          >
            <div class="row items-center justify-end">
              <q-btn
                v-close-popup
                :label="$t('Close')"
                color="dark"
                flat
                no-caps
              />
            </div>
          </q-date>
        </q-popup-proxy>
      </q-input>

      <q-select
        v-model="transaction_type"
        :options="DriverStore.getPromoAttributes.transaction_list"
        :label="$t('Transaction Type')"
        stack-label
        behavior="menu"
        outlined
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        emit-value
        map-options
        multiple
      />

      <q-select
        v-model="used_once"
        :options="DriverStore.getPromoAttributes.coupon_options"
        :label="$t('Coupon Options')"
        stack-label
        behavior="menu"
        outlined
        :rules="[
          (val) => (val && val > 0) || this.$t('This field is required'),
        ]"
        emit-value
        map-options
      />

      <template v-if="used_once == 5">
        <q-input
          v-model="max_number_use"
          :label="$t('Define max number of use')"
          type="number"
          step="any"
          stack-label
          outlined
        />
      </template>
      <template v-else-if="used_once == 6">
        <SelectCustomer
          ref="customer"
          @create-customer="createCustomer"
          :options_data="
            CartStore.customer_data ? CartStore.customer_data : customer_data
          "
          :template="2"
        ></SelectCustomer>
        <q-space class="q-pa-sm"></q-space>
      </template>

      <q-toggle v-model="visible" color="primary" :label="$t('Visible')" />

      <q-select
        v-model="status"
        :options="DataStore.status_list"
        :label="$t('Status')"
        stack-label
        behavior="menu"
        outlined
        :rules="[
          (val) => (val && val.length > 0) || this.$t('This field is required'),
        ]"
        emit-value
        map-options
      />

      <q-footer class="q-pa-md myshadow bg-white">
        <q-btn
          type="submit"
          color="amber-6"
          text-color="disabled"
          unelevated
          class="full-width radius8"
          size="lg"
          no-caps
          :loading="loading1"
        >
          <div class="text-weight-bold text-subtitle2">{{ $t("Save") }}</div>
        </q-btn>
      </q-footer>
    </q-form>
  </q-page>
</template>

<script>
import { defineAsyncComponent } from "vue";
import APIinterface from "src/api/APIinterface";
import { useDataStore } from "stores/DataStore";
import { useDriverStore } from "stores/DriverStore";
import { useCartStore } from "stores/CartStore";

export default {
  name: "CouponManage",
  components: {
    SelectCustomer: defineAsyncComponent(() =>
      import("components/SelectCustomer.vue")
    ),
  },
  data() {
    return {
      id: "",
      data: [],
      loading: false,
      loading1: false,
      voucher_name: "",
      voucher_type: "fixed amount",
      amount: 0,
      min_order: 0,
      days_available: [],
      expiration: "",
      transaction_type: [],
      used_once: "",
      visible: true,
      status: "publish",
      max_number_use: "",
      max_order: null,
      max_discount_cap: null,
    };
  },
  setup(props) {
    const DataStore = useDataStore();
    const DriverStore = useDriverStore();
    const CartStore = useCartStore();
    return { DataStore, DriverStore, CartStore };
  },
  created() {
    this.DriverStore.PromoAttributes();
  },
  mounted() {
    this.id = this.$route.query.id;

    this.DataStore.page_title = this.id
      ? this.$t("Update Coupon")
      : this.$t("Add Coupon");

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

      APIinterface.fetchDataByTokenPost("getCoupon", "id=" + this.id)
        .then((data) => {
          this.data = data.details;
          this.voucher_name = data.details.voucher_name;
          this.voucher_type = data.details.voucher_type;
          this.amount = data.details.amount;
          this.min_order = data.details.min_order;
          this.max_order = data.details.max_order;
          this.max_discount_cap = data.details.max_discount_cap;
          this.expiration = data.details.expiration;
          this.used_once = data.details.used_once;
          this.visible = data.details.visible == 1 ? true : false;
          this.status = data.details.status;
          this.days_available = data.details.days_available;
          this.transaction_type = data.details.transaction_type;
          this.max_number_use = data.details.max_number_use;
          this.CartStore.customer_id = data.details.selected_customer;
        })
        .catch((error) => {
          APIinterface.ShowAlert(error, this.$q.capacitor, this.$q);
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
        voucher_name: this.voucher_name,
        voucher_type: this.voucher_type,
        amount: this.amount,
        min_order: this.min_order,
        days_available: this.days_available,
        expiration: this.expiration,
        transaction_type: this.transaction_type,
        used_once: this.used_once,
        visible: this.visible,
        status: this.status,
        max_number_use: this.max_number_use,
        selected_customer: this.CartStore.customer_id,
        max_order: this.max_order,
        max_discount_cap: this.max_discount_cap,
      };
      this.loading1 = true;
      APIinterface.fetchDataByTokenPost(
        !APIinterface.empty(this.id) ? "UpdateCoupon" : "AddCoupon",
        params
      )
        .then((data) => {
          APIinterface.ShowSuccessful(data.msg, this.$q);
          this.DataStore.cleanData("coupon_list");
          this.$router.replace({
            path: "/promo/coupon-list",
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
